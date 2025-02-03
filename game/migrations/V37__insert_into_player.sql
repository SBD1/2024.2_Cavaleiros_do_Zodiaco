CREATE OR REPLACE FUNCTION insert_random_cdz_player()
RETURNS void AS
$$
DECLARE
    nome_cdz TEXT;
    id_elemento_min INT;
    id_elemento_max INT;
BEGIN
    -- Gerar um nome aleatório que não esteja na tabela player
    WITH nomes AS (
        SELECT unnest(ARRAY ['Arion', 'Celestis', 'Drakon', 'Helion', 'Zephyr']) AS nome
    )
    SELECT nome INTO nome_cdz 
    FROM nomes 
    WHERE nome NOT IN (SELECT p.nome FROM player p) 
    ORDER BY random() 
    LIMIT 1;

    -- Verifica se conseguiu obter um nome válido
    IF nome_cdz IS NULL THEN
        RAISE NOTICE 'Todos os nomes já foram usados. Nenhum novo jogador foi criado.';
        RETURN;
    END IF;

    -- Obter o mínimo e o máximo ID do elemento
    SELECT MIN(id_elemento), MAX(id_elemento) INTO id_elemento_min, id_elemento_max FROM Elemento;

    -- Inserir o registro com valores aleatórios
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
        ataque_fisico_base,
        ataque_magico_base
    )
    VALUES (
        floor(random() * (id_elemento_max - id_elemento_min + 1) + id_elemento_min), -- ID do elemento aleatório dentro do intervalo válido
        nome_cdz, -- Nome aleatório e único gerado
        1, -- Nível inicial fixo
        0, -- XP acumulado inicial
        20, -- HP Máximo fixo
        20, -- Magia Máxima fixa
        20, -- HP Atual fixo
        20, -- Magia Atual fixa
        floor(random() * 61), -- Velocidade aleatória (0 a 60)
        floor(random() * 61), -- Ataque físico base aleatório (0 a 60)
        floor(random() * 61) -- Ataque mágico base aleatório (0 a 60)
    );
    
    RAISE NOTICE 'Novo jogador % foi criado com sucesso!', nome_cdz;
END;
$$
LANGUAGE plpgsql;


SELECT insert_random_cdz_player();
SELECT insert_random_cdz_player();

INSERT INTO inventario (id_player, dinheiro)
VALUES 
    (1, 50),
    (2, 50);


INSERT INTO public.parte_corpo (id_parte_corpo, nome, defesa_magica, defesa_fisica, chance_acerto, chance_acerto_critico)
VALUES 
    ('c', 'Cabeça', 5, 10, 80, 5),
    ('t', 'Tronco', 8, 15, 90, 3),
    ('b', 'Braços', 4, 7, 85, 8),
    ('p', 'Pernas', 6, 9, 88, 6);
