CREATE OR REPLACE FUNCTION criar_instancia_inimigo(p_id_inimigo INT, p_id_grupo INT DEFAULT NULL)
RETURNS VOID AS $$
DECLARE
    v_inimigo RECORD;
BEGIN

    SELECT *
    INTO v_inimigo
    FROM inimigo
    WHERE id_inimigo = p_id_inimigo;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Inimigo com ID % não encontrado', p_id_inimigo;
    END IF;

    INSERT INTO instancia_inimigo (
        id_inimigo,
        id_grupo,
        hp_atual,
        magia_atual,
        ataque_fisico,
        ataque_magico,
        velocidade
    )
    VALUES (
        p_id_inimigo,              
        p_id_grupo,                
        v_inimigo.hp_max,         
        v_inimigo.magia_max,       
        10,                         
        10,
        10                          
    );

END;
$$ LANGUAGE plpgsql;
