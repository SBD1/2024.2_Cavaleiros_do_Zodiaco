CREATE OR REPLACE FUNCTION listar_jogadores_formatados_v2()
RETURNS TABLE (
    id_player INTEGER,
    nome TEXT,
    nivel INTEGER,
    elemento TEXT,
    hp_max INTEGER,
    magia_max INTEGER,
    hp_atual INTEGER,
    magia_atual INTEGER,
    ataque_fisico_base INTEGER,
    ataque_magico_base INTEGER,
    dinheiro INTEGER
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        p.id_player,  -- Adicionando o ID do jogador
        p.nome::TEXT AS nome,  -- Nome do jogador (de player)
        p.nivel,
        e.nome::TEXT AS elemento,  -- Nome do elemento (de elemento)
        p.hp_max,
        p.magia_max, 
        p.hp_atual, 
        p.magia_atual, 
        p.ataque_fisico_base, 
        p.ataque_magico_base,
        i.dinheiro
    FROM player p
    INNER JOIN elemento e ON e.id_elemento = p.id_elemento
    INNER JOIN inventario i on i.id_player = p.id_player
    ORDER BY p.id_player;
END;
$$ LANGUAGE plpgsql;
