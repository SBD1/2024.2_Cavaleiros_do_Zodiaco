CREATE OR REPLACE FUNCTION listar_jogadores_formatados_v2()
RETURNS TABLE (
    id_player INTEGER,
    nome TEXT,
    nivel INTEGER,
    elemento TEXT,
    descricao TEXT,
    fraco_contra TEXT,
    forte_contra TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        p.id_player,  -- Adicionando o ID do jogador
        p.nome::TEXT AS nome,  -- Nome do jogador (de player)
        p.nivel,
        e.nome::TEXT AS elemento,  -- Nome do elemento (de elemento)
        e.descricao::TEXT,
        (SELECT e2.nome FROM elemento e2 WHERE e2.id_elemento = e.fraco_contra)::TEXT AS fraco_contra,
        (SELECT e3.nome FROM elemento e3 WHERE e3.id_elemento = e.forte_contra)::TEXT AS forte_contra
    FROM player p
    INNER JOIN elemento e ON e.id_elemento = p.id_elemento
    ORDER BY p.id_player;
END;
$$ LANGUAGE plpgsql;
