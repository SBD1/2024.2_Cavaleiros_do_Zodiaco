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
