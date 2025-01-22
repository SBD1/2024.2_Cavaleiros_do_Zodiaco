CREATE OR REPLACE FUNCTION insert_cdz_player(p_nome_cdz TEXT) 
RETURNS void AS
$$
DECLARE
    id_elemento_min INT;
    id_elemento_max INT;
BEGIN
    -- Obter o mínimo e o máximo ID do elemento
    SELECT MIN(id_elemento), MAX(id_elemento) 
    INTO id_elemento_min, id_elemento_max 
    FROM Elemento;

    -- Inserir o registro com valores parcialmente aleatórios e outros fixos
    INSERT INTO player (
        id_elemento,
        nome,
        nivel,
        xp_acumulado,
        hp_max,
        magia_max,
        hp_atual,
        magia_atual,
        velocidade,
        ataque_fisico_base,
        ataque_magico_base,
        id_sala_safe
    )
    VALUES (
        floor(random() * (id_elemento_max - id_elemento_min + 1) + id_elemento_min), -- ID do elemento aleatório dentro do intervalo válido
        p_nome_cdz, -- Nome fornecido por parâmetro
        1, -- Nível fixo
        0, -- XP acumulado fixo
        20, -- HP Máximo fixo
        20, -- Magia Máxima fixa
        20, -- HP Atual fixo
        20, -- Magia Atual fixa
        floor(random() * 61), -- Velocidade aleatória (0 a 60)
        floor(random() * 61), -- Ataque físico base aleatório (0 a 60)
        floor(random() * 61), -- Ataque mágico base aleatório (0 a 60)
        1 -- Sala Safe ID fixa
    );

END;
$$
LANGUAGE plpgsql;
