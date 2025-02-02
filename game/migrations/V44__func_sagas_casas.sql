CREATE OR REPLACE FUNCTION listar_sagas(player_id INT)
RETURNS TABLE (
    id_saga INT,
    nome_saga TEXT
) AS $$
DECLARE
    player_exists INT;
    saga_count INT;
BEGIN
    -- Verifica se o jogador existe
    SELECT COUNT(*) INTO player_exists FROM player WHERE id_player = player_id;
    IF player_exists = 0 THEN
        RAISE EXCEPTION 'O jogador com ID % não existe.', player_id;
    END IF;

    -- Conta quantas sagas estão disponíveis para o jogador
    SELECT COUNT(*) INTO saga_count
    FROM saga s
    LEFT JOIN missao m ON s.id_missao_requisito = m.id_missao
    LEFT JOIN player_missao pm ON pm.id_missao = m.id_missao AND pm.id_player = player_id
    WHERE s.id_saga <> 1 AND (s.id_missao_requisito IS NULL OR pm.status_missao = 'c');

    -- Se não houver sagas disponíveis, lança uma exceção específica
    IF saga_count = 0 THEN
        RAISE EXCEPTION 'Não existem sagas desbloqueadas para o jogador';
    END IF;

    -- Retorna as sagas disponíveis
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
        s.id_saga <> 1 AND (s.id_missao_requisito IS NULL OR pm.status_missao = 'c');

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
        IF (SELECT 1 FROM Saga WHERE id_saga = nova_saga_id)  THEN
            RAISE EXCEPTION 'O jogador ainda não desbloqueou a saga selecionada.';
        END IF;
        RAISE EXCEPTION 'Insira um número de saga válido.';
    END IF;

    -- Verifica se o jogador existe
    IF NOT EXISTS (SELECT 1 FROM player WHERE id_player = player_id) THEN
        RAISE EXCEPTION 'Jogador não encontrado.';
    END IF;

    -- Verifica se a saga existe
    IF NOT EXISTS (SELECT 1 FROM saga WHERE id_saga = nova_saga_id) THEN
        RAISE EXCEPTION 'Insira uma saga válida.';
    END IF;

    -- Encontra a casa com o menor id_casa dentro da saga escolhida
    SELECT MIN(casa.id_casa) INTO casa_inicial_da_saga
    FROM casa
    WHERE casa.id_saga = nova_saga_id;

    -- Se nenhuma casa for encontrada, retorna erro
    IF casa_inicial_da_saga IS NULL THEN
        RAISE EXCEPTION 'Nenhuma casa inicial encontrada para esta saga.';
    END IF;

    -- Encontra a sala com o menor id_sala dentro da casa escolhida
    SELECT MIN(sala.id_sala) INTO sala_inicial_da_saga
    FROM sala
    WHERE sala.id_casa = casa_inicial_da_saga;

    -- Se nenhuma sala for encontrada, retorna erro
    IF sala_inicial_da_saga IS NULL THEN
       RAISE EXCEPTION 'Nenhuma sala inicial encontrada para esta casa.';
    END IF;

    UPDATE public.party
    SET id_sala = sala_inicial_da_saga
    WHERE id_player = player_id;

    RETURN 'Player mudou de saga com Sucesso';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_casas(player_id INT)                    
RETURNS TABLE (
    id_casa INT,
    nome_casa TEXT
) 
AS $$
DECLARE                                                                                                          
    player_exists INT;                                                                                         
BEGIN
    -- Verifica se o jogador existe                                                                               
    SELECT COUNT(*) INTO player_exists 
    FROM player 
    WHERE id_player = player_id;                                  

    IF player_exists = 0 THEN                                                                                    
        RAISE EXCEPTION 'O jogador com ID % não existe.', player_id;
    END IF;                                                                                                       

    -- Retorna as casas disponíveis ordenadas por ID
    RETURN QUERY                                                                                                 
    SELECT 
        c.id_casa, 
        c.nome :: TEXT
    FROM 
        casa c
    LEFT JOIN 
        missao m ON c.id_missao_requisito = m.id_missao
    LEFT JOIN 
        player_missao pm ON pm.id_missao = m.id_missao AND pm.id_player = player_id
    WHERE 
        c.id_saga <> 1 
        AND (c.id_missao_requisito IS NULL OR pm.status_missao = 'c')
        AND c.id_saga = (
            SELECT sa.id_saga
            FROM party p
            JOIN sala s ON p.id_sala = s.id_sala
            JOIN casa ca ON ca.id_casa = s.id_casa
            JOIN saga sa ON sa.id_saga = ca.id_saga
            WHERE p.id_player = player_id
            LIMIT 1
        )
    ORDER BY c.id_casa; -- Ordena as casas pelo ID

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Nenhuma casa disponível foi encontrada para o jogador.';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mudar_casa(player_id INT, nova_casa_id INT)
RETURNS TEXT AS $$
DECLARE
    casa_disponivel BOOLEAN;
    saga_da_casa INT;
    sala_inicial_da_casa INT;
BEGIN
    SELECT id_saga INTO saga_da_casa FROM casa WHERE id_casa = nova_casa_id;

    IF saga_da_casa IS NULL THEN
        RAISE EXCEPTION 'A casa selecionada não existe.';
    END IF;

    SELECT EXISTS(
        SELECT 1 
        FROM listar_sagas(player_id) 
        WHERE id_saga = saga_da_casa
    ) INTO casa_disponivel;

    IF NOT casa_disponivel THEN
        RAISE EXCEPTION 'O jogador ainda não desbloqueou a saga desta casa.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM player WHERE id_player = player_id) THEN
        RAISE EXCEPTION 'Jogador não encontrado.';
    END IF;

    SELECT MIN(sala.id_sala) INTO sala_inicial_da_casa
    FROM sala
    WHERE sala.id_casa = nova_casa_id;

    IF sala_inicial_da_casa IS NULL THEN
        RAISE EXCEPTION 'Nenhuma sala inicial encontrada para esta casa.';
    END IF;

    UPDATE public.party
    SET id_sala = sala_inicial_da_casa
    WHERE id_player = player_id;

    RETURN 'Player mudou de casa com sucesso';
END;
$$ LANGUAGE plpgsql;
