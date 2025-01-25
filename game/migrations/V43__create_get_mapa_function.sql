CREATE OR REPLACE FUNCTION get_mapa()
RETURNS TABLE(id_sala INT, nome VARCHAR, norte INT, sul INT, leste INT, oeste INT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id_sala, 
        s.nome, 
        s.id_sala_norte AS norte, 
        s.id_sala_sul AS sul, 
        s.id_sala_leste AS leste, 
        s.id_sala_oeste AS oeste
    FROM public.sala s;
END;
$$ LANGUAGE plpgsql;
