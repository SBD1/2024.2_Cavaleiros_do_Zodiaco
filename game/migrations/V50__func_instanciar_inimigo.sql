CREATE OR REPLACE FUNCTION criar_instancia_inimigo(p_id_inimigo INT, p_id_grupo INT DEFAULT NULL)
RETURNS VOID AS $$
DECLARE
    v_inimigo RECORD;
BEGIN
    -- Verificar se o inimigo existe
    SELECT *
    INTO v_inimigo
    FROM inimigo
    WHERE id_inimigo = p_id_inimigo;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Inimigo com ID % não encontrado', p_id_inimigo;
    END IF;

    -- Criar uma nova instância do inimigo
    INSERT INTO instancia_inimigo (
        id_inimigo,
        id_grupo,
        hp_atual,
        magia_atual,
        defesa_fisica_bonus,
        defesa_magica_bonus
    )
    VALUES (
        p_id_inimigo,              -- ID do inimigo
        p_id_grupo,                -- ID do grupo, pode ser NULL
        v_inimigo.hp_max,          -- HP inicial igual ao HP máximo do inimigo
        v_inimigo.magia_max,       -- Magia inicial igual ao máximo do inimigo
        0,                         -- Defesa física bônus padrão
        0                          -- Defesa mágica bônus padrão
    );

END;
$$ LANGUAGE plpgsql;
