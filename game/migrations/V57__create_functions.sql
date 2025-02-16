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

CREATE OR REPLACE FUNCTION verificar_boss_sala(player_id_input INT)
RETURNS TABLE (
    id_boss INT,
    nome_boss TEXT,
    hp_atual INT,
    id_missao INT,
    status_missao TEXT,
    id_missao_anterior INT,
    nome_missao_anterior TEXT,
    status_missao_anterior TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id_boss, 
        b.nome::TEXT,  
        b.hp_atual, 
        m.id_missao, 
        pm.status_missao::TEXT,  
        m.id_missao_anterior,
        ma.nome::TEXT,
        pm_requisito.status_missao::TEXT
    FROM boss b
    LEFT JOIN missao m ON b.id_item_missao = m.item_necessario
    LEFT JOIN player_missao pm ON m.id_missao = pm.id_missao AND pm.id_player = player_id_input
    LEFT JOIN player_missao pm_requisito 
        ON m.id_missao_anterior = pm_requisito.id_missao 
        AND pm_requisito.id_player = player_id_input
    LEFT JOIN missao ma ON m.id_missao_anterior = ma.id_missao 
    WHERE b.id_sala = get_id_sala_atual(player_id_input);
END $$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION verificar_desbloqueio_ferreiro(p_id_player INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    desbloqueado BOOLEAN;
BEGIN
    -- Verificar se o NPC Ferreiro foi desbloqueado
    SELECT CASE
        WHEN pm.status_missao = 'c' THEN TRUE
        ELSE FALSE
    END
    INTO desbloqueado
    FROM ferreiro nf
    LEFT JOIN player_missao pm
        ON pm.id_missao = nf.id_missao_desbloqueia
        AND pm.id_player = p_id_player
    WHERE nf.id_npc = 1; -- Garantir que é o NPC Ferreiro com ID 1

    -- Retornar o resultado
    RETURN COALESCE(desbloqueado, FALSE);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obter_hp_inimigo(p_id_instancia_inimigo INTEGER)
RETURNS TEXT AS $$
DECLARE
    v_hp TEXT;
BEGIN
    SELECT ii.hp_atual || '/' || i.hp_max
    INTO v_hp
    FROM instancia_inimigo ii
    INNER JOIN grupo_inimigo gi ON gi.id_grupo = ii.id_grupo
    INNER JOIN inimigo i ON i.id_inimigo = ii.id_inimigo
    WHERE ii.id_instancia = p_id_instancia_inimigo;

    RETURN COALESCE(v_hp, 'HP desconhecido');
END;
$$ LANGUAGE plpgsql;
