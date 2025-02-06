CREATE OR REPLACE FUNCTION public.get_player_info_v2(player_id INTEGER)
RETURNS TABLE (
    nome TEXT,
    nivel INTEGER,
    xp_atual INTEGER,
    hp_max INTEGER,
    magia_max INTEGER,
    hp_atual INTEGER,
    magia_atual INTEGER,
    velocidade INTEGER,
    ataque_fisico INTEGER,
    ataque_magico INTEGER,
    elemento TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        p.nome::TEXT,  -- Conversão explícita para TEXT
        p.nivel,
        p.xp_atual,
        p.hp_max,
        p.magia_max,
        p.hp_atual,
        p.magia_atual,
        p.velocidade,
        p.ataque_fisico,
        p.ataque_magico,
        e.nome::TEXT   -- Conversão explícita para TEXT
    FROM player p
    INNER JOIN elemento e ON e.id_elemento = p.id_elemento
    WHERE p.id_player = player_id;
END;
$$ LANGUAGE plpgsql;
