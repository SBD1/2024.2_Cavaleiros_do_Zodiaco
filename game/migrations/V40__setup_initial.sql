INSERT INTO party (id_player, id_sala)
VALUES(1, 1);

CREATE OR REPLACE FUNCTION setar_sala_inicial(id_player_input INT)
RETURNS VOID AS $$
DECLARE
    sala_inicial_id INT;
BEGIN
    -- Recupera o menor id_sala da tabela sala
    SELECT MIN(id_sala) INTO sala_inicial_id FROM public.sala;

    -- Verifica se existe uma sala
    IF sala_inicial_id IS NOT NULL THEN
        -- Atualiza o id_sala_safe do player
        UPDATE public.player
        SET id_sala_safe = sala_inicial_id
        WHERE id_player = id_player_input;

        -- Insere na party
        INSERT INTO public.party (id_player, id_sala)
        VALUES (id_player_input, sala_inicial_id);
    ELSE
        RAISE EXCEPTION 'Nenhuma sala encontrada na tabela sala.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION setar_nova_sala(id_player_input INT, id_sala_input INT)
RETURNS VOID AS $$
BEGIN
    -- Verifica se a sala existe
    IF EXISTS (SELECT 1 FROM public.sala WHERE id_sala = id_sala_input) THEN
        -- Atualiza o id_sala_safe do player
        UPDATE public.player
        SET id_sala_safe = id_sala_input
        WHERE id_player = id_player_input;

        -- Insere ou atualiza na party
        DELETE FROM public.party
        WHERE id_player = id_player_input;

        INSERT INTO public.party (id_player, id_sala)
        VALUES (id_player_input, id_sala_input);
    ELSE
        RAISE EXCEPTION 'Sala com id_sala % não encontrada.', id_sala_input;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_salas_conectadas(id_player_input INT)
RETURNS TABLE(id_sala INT, nome VARCHAR) AS $$
BEGIN
    RETURN QUERY
    WITH salas_conectadas AS (
        SELECT
            unnest(ARRAY[id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste]) AS id_sala_direcao
        FROM public.sala
        WHERE id_sala = (
            SELECT id_sala
            FROM public.party p
            WHERE p.id_player = id_player_input
            LIMIT 1
        )
    )
    SELECT
        s.id_sala, s.nome
    FROM salas_conectadas sc
    JOIN public.sala s ON sc.id_sala_direcao = s.id_sala
    WHERE sc.id_sala_direcao IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_player_info(player_id INT)
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT STRING_AGG(
            FORMAT(
                'Nome: %s\nNível: %s\nXP Acumulado: %s\nHP Máximo: %s\nMagia Máxima: %s\nHP Atual: %s\nMagia Atual: %s\nVelocidade: %s\nAtaque Físico Base: %s\nAtaque Mágico Base: %s\nElemento: %s\n',
                p.nome,
                p.nivel,
                p.xp_acumulado,
                p.hp_max,
                p.magia_max,
                p.hp_atual,
                p.magia_atual,
                p.velocidade,
                p.ataque_fisico_base,
                p.ataque_magico_base,
                e.nome
            ),
            ''
        )
        FROM player p
        INNER JOIN elemento e ON e.id_elemento = p.id_elemento
        WHERE p.id_player = player_id
    );
END;
$$ LANGUAGE plpgsql;

