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
    INSERT INTO instancia_cavaleiro (id_player,id_cavaleiro, id_party, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico)
    SELECT 
        p_id_player,
        p_id_cavaleiro_novo, 
        id_sala_var,  -- Corrigido para `id_sala_var`
        nivel, 0, hp_max, magia_max, hp_max, magia_max, velocidade_base, ataque_fisico_base, ataque_magico_base
    FROM cavaleiro
    WHERE id_cavaleiro = p_id_cavaleiro_novo;

    RAISE NOTICE 'Cavaleiro % foi adicionado à party.', p_id_cavaleiro_novo;
END;
$$;

CREATE OR REPLACE PROCEDURE comprar_item(
    p_id_player INT,
    p_id_item INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_dinheiro_atual NUMERIC;
    v_preco_item NUMERIC;
    v_level_minimo INT;
    v_jogador_level INT;
    v_id_inventario INT;
    v_quantidade_atual INT;
BEGIN
    -- Verificar o dinheiro disponível do jogador
    SELECT dinheiro, id_player INTO v_dinheiro_atual, v_id_inventario
    FROM inventario
    WHERE id_player = p_id_player;

    IF v_dinheiro_atual IS NULL THEN
        RAISE EXCEPTION 'Jogador não encontrado.';
    END IF;

    -- Verificar o preço e o nível mínimo do item
    SELECT preco_compra, nivel_minimo INTO v_preco_item, v_level_minimo
    FROM item_a_venda
    WHERE id_item = p_id_item;

    IF v_preco_item IS NULL THEN
        RAISE EXCEPTION 'Item não encontrado.';
    END IF;

    -- Verificar o nível do jogador
    SELECT nivel INTO v_jogador_level
    FROM player
    WHERE id_player = p_id_player;

    IF v_jogador_level IS NULL THEN
        RAISE EXCEPTION 'Jogador não encontrado.';
    END IF;

    IF v_jogador_level < v_level_minimo THEN
        RAISE EXCEPTION 'Você precisa ser nível % para comprar este item.', v_level_minimo;
    END IF;

    -- Verificar se o jogador tem dinheiro suficiente
    IF v_dinheiro_atual < v_preco_item THEN
        RAISE EXCEPTION 'Dinheiro insuficiente para comprar o item.';
    END IF;

    -- Subtrair o preço do item do dinheiro do jogador
    UPDATE inventario
    SET dinheiro = dinheiro - v_preco_item
    WHERE id_player = v_id_inventario;

    -- Verificar se o item já existe no inventário do jogador
    SELECT quantidade INTO v_quantidade_atual
    FROM item_armazenado
    WHERE id_inventario = v_id_inventario
      AND id_item = p_id_item;

    -- Se o item não existir, adicioná-lo ao inventário com quantidade 1
    IF NOT FOUND THEN
        INSERT INTO item_armazenado (id_inventario, id_item, quantidade)
        VALUES (v_id_inventario, p_id_item, 1);
    ELSE
        -- Caso contrário, incrementar a quantidade do item existente
        UPDATE item_armazenado
        SET quantidade = quantidade + 1
        WHERE id_inventario = v_id_inventario
          AND id_item = p_id_item;
    END IF;

    RAISE NOTICE 'Item comprado com sucesso!';

END $$;
