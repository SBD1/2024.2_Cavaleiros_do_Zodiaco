CREATE OR REPLACE FUNCTION get_cavaleiros_disponiveis()
RETURNS TABLE(id_cavaleiro INT, nome TEXT) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT c.id_cavaleiro, c.nome::TEXT FROM cavaleiro c;
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
