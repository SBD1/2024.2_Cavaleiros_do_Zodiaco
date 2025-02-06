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

    -- Obter o mínimo e o máximo ID do elemento
    SELECT MIN(id_elemento), MAX(id_elemento) 
    INTO id_elemento_min, id_elemento_max 
    FROM Elemento;

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
        floor(random() * (id_elemento_max - id_elemento_min + 1) + id_elemento_min), -- ID do elemento aleatório dentro do intervalo válido
        p_nome_cdz, -- Nome fornecido por parâmetro
        1, -- Nível fixo
        0, -- XP acumulado fixo
        100, -- HP Máximo fixo
        50, -- Magia Máxima fixa
        100, -- HP Atual fixo
        100, -- Magia Atual fixa
        50, -- Velocidade aleatória (0 a 60)
        20, -- Ataque físico  aleatório (0 a 60)
        10 -- Ataque mágico  aleatório (0 a 60)
    );

END;
$$
LANGUAGE plpgsql;
