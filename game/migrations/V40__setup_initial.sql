

CREATE OR REPLACE FUNCTION setar_sala_inicial(id_player_input INT)
RETURNS VOID AS $$
DECLARE
    sala_inicial_id INT;
    existe_na_party BOOLEAN;
BEGIN
    -- Recupera o menor id_sala da tabela sala
    SELECT id_sala FROM public.sala_inicial;

    -- Verifica se existe uma sala
    IF sala_inicial_id IS NOT NULL THEN


        -- Verifica se o player já está na party
        SELECT EXISTS(
            SELECT 1 FROM public.party WHERE id_player = id_player_input
        ) INTO existe_na_party;

        -- Se já existir, apenas atualiza a sala
        IF existe_na_party THEN
            UPDATE public.party
            SET id_sala = sala_inicial_id
            WHERE id_player = id_player_input;
        ELSE
            -- Caso contrário, insere um novo registro na party
            INSERT INTO public.party (id_player, id_sala)
            VALUES (id_player_input, sala_inicial_id);
        END IF;
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
        -- Atualiza o id_sala na tabela party para o jogador
        UPDATE public.party
        SET id_sala = id_sala_input
        WHERE id_player = id_player_input;

        -- Verifica se o jogador já está na tabela party, caso contrário, insere
        IF NOT FOUND THEN
            INSERT INTO public.party (id_player, id_sala)
            VALUES (id_player_input, id_sala_input);
        END IF;
    ELSE
        RAISE EXCEPTION 'Sala com id_sala % não encontrada.', id_sala_input;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_salas_conectadas(id_player_input INT)
RETURNS TABLE(id_sala INT, nome VARCHAR, direcao VARCHAR) AS $$
BEGIN
    RETURN QUERY
    WITH salas_conectadas AS (
        SELECT s.id_sala_norte AS id_sala, CAST('Norte' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
            SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
        ) AND s.id_sala_norte IS NOT NULL
        UNION ALL
        SELECT s.id_sala_sul AS id_sala, CAST('Sul' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
            SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
        ) AND s.id_sala_sul IS NOT NULL
        UNION ALL
        SELECT s.id_sala_leste AS id_sala, CAST('Leste' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
            SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
        ) AND s.id_sala_leste IS NOT NULL
        UNION ALL
        SELECT s.id_sala_oeste AS id_sala, CAST('Oeste' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
            SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
        ) AND s.id_sala_oeste IS NOT NULL
    )
    SELECT sc.id_sala, s.nome, sc.direcao
    FROM salas_conectadas sc
    JOIN public.sala s ON sc.id_sala = s.id_sala;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.get_player_info(player_id integer)
RETURNS text
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN (
        SELECT STRING_AGG(
            FORMAT(
                'Nome: %s %sNível: %s%sXP Acumulado: %s%sHP Máximo: %s%sMagia Máxima: %s%sHP Atual: %s%sMagia Atual: %s%sVelocidade: %s%sAtaque Físico Base: %s%sAtaque Mágico Base: %s%sElemento: %s',
                p.nome, E'\n',
                p.nivel, E'\n',
                p.atual, E'\n',
                p.hp_max, E'\n',
                p.magia_max, E'\n',
                p.hp_atual, E'\n',
                p.magia_atual, E'\n',
                p.velocidade, E'\n',
                p.ataque_fisico_base, E'\n',
                p.ataque_magico_base, E'\n',
                e.nome
            ),
            E'\n'  -- Delimitador entre os registros (caso haja mais de um)
        )
        FROM player p
        INNER JOIN elemento e ON e.id_elemento = p.id_elemento
        WHERE p.id_player = player_id
    );
END;
$function$;


CREATE OR REPLACE FUNCTION listar_jogadores_formatados()
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT STRING_AGG(
            FORMAT(
                'Nome: %s Nível: %s Elemento: %s ',
                p.nome,
                p.nivel,
                e.nome
            ),
            E'\n'  -- Delimitador entre as entradas
        )
        FROM 
            player p
        INNER JOIN 
            elemento e ON e.id_elemento = p.id_elemento
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_sala_atual(id_player_input INT)
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT STRING_AGG(
            FORMAT('Sala Atual: %s',s.nome),
            '\n'
        )
        FROM sala s
        INNER JOIN party p ON s.id_sala = p.id_sala
        WHERE p.id_player = id_player_input
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_nome_sala(id_sala_input INT)
RETURNS VARCHAR AS $$
BEGIN
    RETURN (
        SELECT s.nome
        FROM sala s
        WHERE s.id_sala = id_sala_input
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;
