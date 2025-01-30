CREATE OR REPLACE FUNCTION listar_sagas(player_id INT)
RETURNS TABLE (
    id_saga INT,
    nome_saga TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id_saga, 
        s.nome :: TEXT
    FROM 
        saga s
    LEFT JOIN 
        missao m ON s.id_missao_requisito = m.id_missao
    LEFT JOIN 
        player_missao pm ON pm.id_missao = m.id_missao AND pm.id_player = player_id
    WHERE 
        s.id_missao_requisito IS NULL 
        OR pm.status_missao = 'c';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION mudar_saga(player_id INT, nova_saga_id INT)
RETURNS TEXT AS $$
DECLARE
    saga_disponivel BOOLEAN;
    casa_inicial_da_saga INT;
    sala_inicial_da_saga INT;
BEGIN
    -- Verifica se a saga está disponível para o jogador
    SELECT EXISTS(
        SELECT 1 
        FROM listar_sagas(player_id) 
        WHERE id_saga = nova_saga_id
    ) INTO saga_disponivel;

    IF NOT saga_disponivel THEN
        RETURN '❌ A saga selecionada não está disponível para o jogador.';
    END IF;

    -- Verifica se o jogador existe
    IF NOT EXISTS (SELECT 1 FROM player WHERE id_player = player_id) THEN
        RETURN '❌ Jogador não encontrado.';
    END IF;

    -- Verifica se a saga existe
    IF NOT EXISTS (SELECT 1 FROM saga WHERE id_saga = nova_saga_id) THEN
        RETURN '❌ Saga não encontrada.';
    END IF;

    -- Encontra a casa com o menor id_casa dentro da saga escolhida
    SELECT MIN(casa.id_casa) INTO casa_inicial_da_saga
    FROM casa
    WHERE casa.id_saga = nova_saga_id;

    -- Se nenhuma casa for encontrada, retorna erro
    IF casa_inicial_da_saga IS NULL THEN
        RETURN '❌ Nenhuma casa inicial encontrada para esta saga.';
    END IF;

    -- Encontra a sala com o menor id_sala dentro da casa escolhida
    SELECT MIN(sala.id_sala) INTO sala_inicial_da_saga
    FROM sala
    WHERE sala.id_casa = casa_inicial_da_saga;

    -- Se nenhuma sala for encontrada, retorna erro
    IF sala_inicial_da_saga IS NULL THEN
        RETURN '❌ Nenhuma sala inicial encontrada para esta casa.';
    END IF;

    UPDATE public.party
    SET id_sala = sala_inicial_da_saga
    WHERE id_player = player_id;

    RETURN 'Sucesso';
END;
$$ LANGUAGE plpgsql;
