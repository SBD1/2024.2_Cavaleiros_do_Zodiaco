CREATE OR REPLACE FUNCTION listar_sala_segura()
RETURNS INT AS $$
DECLARE
    sala_segura_id INT;
BEGIN
    SELECT id_sala INTO sala_segura_id FROM Sala_Segura
    LIMIT 1;

   RETURN sala_segura_id;
END;
$$ LANGUAGE plpgsql;