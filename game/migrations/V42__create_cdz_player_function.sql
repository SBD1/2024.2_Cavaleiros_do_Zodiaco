CREATE OR REPLACE FUNCTION insert_cdz_player(p_nome_cdz TEXT) 
RETURNS void AS
$$
DECLARE
    id_elemento_min INT;
    id_elemento_max INT;
    jogador_existente INT;
BEGIN
    -- Verificar se já existe um jogador com esse nome
    SELECT COUNT(*) INTO jogador_existente FROM player WHERE nome = p_nome_cdz;
    
    IF jogador_existente > 0 THEN
        RAISE EXCEPTION 'Jogador com nome existente' USING ERRCODE = 'P0001';
    END IF;


    -- Inserir o registro com valores parcialmente aleatórios e outros fixos
    INSERT INTO player (
        id_elemento,
        nome,
        nivel,
        xp_atual,
        hp_max,
        magia_max,
        hp_atual,
        magia_atual,
        velocidade,
        ataque_fisico,
        ataque_magico     
    )
    VALUES (
        6, -- ID do elemento aleatório dentro do intervalo válido
        p_nome_cdz, -- Nome fornecido por parâmetro
        1, -- Nível fixo
        0, -- XP acumulado fixo
        1000, -- HP Máximo fixo
        500, -- Magia Máxima fixa
        1000, -- HP Atual fixo
        50, -- Magia Atual fixa
        70, -- Velocidade aleatória (0 a 60)
        100, -- Ataque físico  aleatório (0 a 60)
        100 -- Ataque mágico  aleatório (0 a 60)
    );

END;
$$
LANGUAGE plpgsql;
