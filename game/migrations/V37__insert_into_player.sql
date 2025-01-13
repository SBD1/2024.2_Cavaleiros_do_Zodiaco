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
    INSERT INTO public.player
    (id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, hp_atual, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, id_sala_safe)
    VALUES
    (floor(random() * (id_elemento_max - id_elemento_min + 1) + id_elemento_min), nome_cdz, floor(random() * 61), floor(random() * 61), floor(random() * 61), floor(random() * 61), floor(random() * 61), floor(random() * 61), floor(random() * 61), floor(random() * 61), floor(random() * 61), floor(random() * 61));
END;
$$
LANGUAGE plpgsql;

SELECT insert_random_cdz_player();
