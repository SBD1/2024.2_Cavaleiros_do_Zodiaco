CREATE OR REPLACE FUNCTION get_cavaleiros_disponiveis(p_id_player INT)
RETURNS TABLE(id_cavaleiro INT, nome TEXT, esta_na_party BOOLEAN)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id_cavaleiro, 
        c.nome::TEXT, 
        EXISTS (
            SELECT 1 FROM instancia_cavaleiro ic 
            JOIN party p ON ic.id_party = p.id_sala
            WHERE p.id_player = p_id_player AND ic.id_cavaleiro = c.id_cavaleiro
        ) AS esta_na_party
    FROM cavaleiro c;
END;
$$;



CREATE OR REPLACE FUNCTION get_party_cavaleiros(p_id_player INT)
RETURNS TABLE(id_cavaleiro INT, nome TEXT) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT c.id_cavaleiro, c.nome::TEXT
    FROM instancia_cavaleiro ic
    JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro
    WHERE ic.id_party = (SELECT id_party FROM party WHERE id_player = p_id_player LIMIT 1);
END;
$$;


CREATE OR REPLACE FUNCTION sala_tem_inimigos(p_id_sala INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_tem_inimigos BOOLEAN := FALSE; 
BEGIN
  
    SELECT EXISTS (
        SELECT 1 FROM instancia_inimigo ii
        INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
        WHERE gi.id_sala = p_id_sala
    )
    INTO v_tem_inimigos;

  
    RETURN COALESCE(v_tem_inimigos, FALSE);
END;
$$;


CREATE OR REPLACE FUNCTION get_id_sala_atual(id_player_input INT)
RETURNS INT AS $$
DECLARE
    v_id_sala INT;
BEGIN
    SELECT s.id_sala
    INTO v_id_sala
    FROM sala s
    INNER JOIN party p ON s.id_sala = p.id_sala
    WHERE p.id_player = id_player_input
    LIMIT 1;  

    RETURN v_id_sala;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION player_tem_inimigos(id_player_input INT)
RETURNS BOOLEAN AS $$
DECLARE
    v_id_sala INT;
    v_tem_inimigos BOOLEAN;
BEGIN
    -- Obtém o ID da sala atual do jogador
    v_id_sala := get_id_sala_atual(id_player_input);

    -- Se o jogador não estiver em nenhuma sala, retorna FALSE
    IF v_id_sala IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Verifica se a sala tem inimigos
    v_tem_inimigos := sala_tem_inimigos(v_id_sala);

    RETURN v_tem_inimigos;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sala_tem_boss(p_id_sala INT, p_id_player INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_tem_boss BOOLEAN := FALSE;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM boss b
        WHERE b.id_sala = p_id_sala
        AND b.id_boss IN (
            SELECT DISTINCT b.id_boss 
            FROM boss b
            INNER JOIN item_missao im ON im.id_item = b.id_item_missao
            INNER JOIN missao m ON m.item_necessario = im.id_item
            LEFT JOIN player_missao pm 
                ON pm.id_missao = m.id_missao_anterior 
                AND pm.status_missao = 'c'
            LEFT JOIN player p ON p.id_player = pm.id_player
            WHERE p.id_player = p_id_player 
               OR m.id_missao_anterior IS NULL
        )
    ) INTO v_tem_boss;

    RETURN COALESCE(v_tem_boss, FALSE);
END;
$$;


CREATE OR REPLACE FUNCTION player_tem_boss(id_player_input INT)
RETURNS BOOLEAN AS $$
DECLARE
    v_id_sala INT;
    v_tem_boss BOOLEAN;
BEGIN
    v_id_sala := get_id_sala_atual(id_player_input);

    IF v_id_sala IS NULL THEN
        RETURN FALSE;
    END IF;

    v_tem_boss := sala_tem_boss(v_id_sala, id_player_input);

    RETURN v_tem_boss;
END;
$$ LANGUAGE plpgsql;
