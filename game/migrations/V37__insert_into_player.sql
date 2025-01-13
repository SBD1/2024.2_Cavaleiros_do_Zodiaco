CREATE OR REPLACE FUNCTION insert_random_cdz_player()
RETURNS void AS
$$
DECLARE
    nome_cdz TEXT;
    id_elemento_min INT;
    id_elemento_max INT;
BEGIN

    WITH nomes AS (
        SELECT unnest(ARRAY['Arion', 'Celestis', 'Drakon', 'Helion', 'Zephyr']) AS nome
    )
    SELECT nome INTO nome_cdz FROM nomes ORDER BY random() LIMIT 1;

    -- Obter o mínimo e o máximo ID do elemento
    SELECT MIN(id_elemento), MAX(id_elemento) INTO id_elemento_min, id_elemento_max FROM Elemento;

    -- Inserir o registro com valores aleatórios
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
    floor(random() * (id_elemento_max - id_elemento_min + 1) + id_elemento_min), -- Certifique-se de que id_elemento_max e id_elemento_min são definidos
    nome_cdz, -- Use aspas simples para valores de texto
    1, -- Nivel aleatório de 0 a 60
    0, -- XP acumulado aleatório de 0 a 60
    20,                   -- HP Máximo fixo
    20,                   -- Magia Máxima fixa
    20,                   -- HP Atual fixo
    20,                   -- Magia Atual fixa
    floor(random() * 61), -- Velocidade aleatória de 0 a 60
    floor(random() * 61), -- Ataque físico base aleatório de 0 a 60
    floor(random() * 61), -- Ataque mágico base aleatório de 0 a 60
    1                     -- Sala Safe ID fixa
);

END;
$$
LANGUAGE plpgsql;

SELECT insert_random_cdz_player();
SELECT insert_random_cdz_player();
