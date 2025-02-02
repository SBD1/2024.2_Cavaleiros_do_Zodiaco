CREATE OR REPLACE PROCEDURE get_inventario_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN cur FOR
        SELECT * FROM inventario_view
        WHERE id_player = p_id_player;
END;
$$;

CREATE OR REPLACE PROCEDURE get_missoes_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN cur FOR
        SELECT m.nome, m.dialogo_durante, m.dialogo_completa, pm.status_missao, im.nome, s.nome, c.nome, saga.nome FROM Player_missao as pm
        JOIN
        Missao AS m
        ON pm.id_missao = m.id_missao
        JOIN
        Item_missao AS im
        ON m.item_necessario = im.id_item
        JOIN
        Boss as b
        ON b.id_item_missao = im.id_item
        JOIN
        Sala AS s 
        ON s.id_sala = b.id_sala
        JOIN
        Casa AS c 
        ON c.id_casa = s.id_casa
        JOIN
        Saga as saga 
        ON saga.id_saga = c.id_saga
        WHERE pm.id_player = p_id_player 
        AND (status_missao = 'i' OR status_missao = 'c');
END;
$$;

CREATE OR REPLACE PROCEDURE get_casa_atual(IN p_id_player INT, INOUT cur REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN cur FOR
        SELECT s.id_casa FROM 
        Party as p
        JOIN
        Sala AS s 
        ON p.id_sala = s.id_sala
        WHERE p.id_player = p_id_player;
END;
$$;

CREATE OR REPLACE PROCEDURE get_grupo_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN cur FOR
        SELECT * FROM grupo_view
        WHERE id_player = p_id_player;
END;
$$;


CREATE OR REPLACE PROCEDURE trocar_cavaleiro_party(
    IN p_id_player INT,
    IN p_id_cavaleiro_novo INT,
    IN p_id_cavaleiro_removido INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    total_cavaleiros INT;
    id_sala_var INT; -- Nome atualizado para evitar ambiguidades
BEGIN
    -- Obtém o ID da sala (party) do jogador
    SELECT id_sala INTO id_sala_var FROM party WHERE id_player = p_id_player LIMIT 1;

    -- Se a party não existir, sair com erro
    IF id_sala_var IS NULL THEN
        RAISE EXCEPTION 'O jogador não tem uma party.';
    END IF;

    -- Conta quantos cavaleiros já estão na party
    SELECT COUNT(*) INTO total_cavaleiros 
    FROM instancia_cavaleiro ic
    WHERE ic.id_party = id_sala_var; -- Agora está claro que estamos referenciando a variável correta

    -- Se a party já tiver 3 cavaleiros, verifica se o cavaleiro escolhido pertence à party
    IF total_cavaleiros >= 3 THEN
        IF NOT EXISTS (SELECT 1 FROM instancia_cavaleiro WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido) THEN
            RAISE EXCEPTION 'O cavaleiro escolhido para remoção não está na party.';
        END IF;

        -- Em vez de deletar, apenas remove o cavaleiro da party (seta NULL)
        UPDATE instancia_cavaleiro 
        SET id_party = NULL 
        WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido;

        RAISE NOTICE 'Cavaleiro % foi removido da party e está disponível novamente.', p_id_cavaleiro_removido;
    END IF;

    -- Adiciona o novo cavaleiro na party
    INSERT INTO instancia_cavaleiro (id_cavaleiro, id_party, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico)
    SELECT 
        p_id_cavaleiro_novo, 
        id_sala_var,  -- Corrigido para `id_sala_var`
        nivel, 0, hp_max, magia_max, hp_max, magia_max, velocidade_base, ataque_fisico_base, ataque_magico_base
    FROM cavaleiro
    WHERE id_cavaleiro = p_id_cavaleiro_novo;

    RAISE NOTICE 'Cavaleiro % foi adicionado à party.', p_id_cavaleiro_novo;
END;
$$;
