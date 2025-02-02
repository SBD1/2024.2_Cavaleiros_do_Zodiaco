

-- Inserindo os cavaleiros na tabela `cavaleiro`
INSERT INTO public.cavaleiro 
(id_classe, id_elemento, nome, nivel, hp_max, magia_max, velocidade_base, ataque_fisico_base, ataque_magico_base)
VALUES
    ( 2, 1, '⚡Seiya', 10, 1000, 500, 70, 180, 90), 
    ( 1, 2, '🐉Shiryu', 10, 1400, 400, 50, 150, 80),  
    ( 3, 2, '❄️Hyoga', 10, 1100, 700, 60, 120, 130),  
    ( 3, 4, '⛓️Shun', 10, 1000, 800, 75, 100, 140),  
    ( 2, 1, '🔥Ikki', 10, 1200, 500, 80, 190, 110);   


INSERT INTO public.instancia_cavaleiro (id_player, id_cavaleiro, id_party, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico)
SELECT 
    1,
    c.id_cavaleiro, 
    1, 
    c.nivel, 
    0,
    c.hp_max, 
    c.magia_max, 
    c.hp_max, 
    c.magia_max, 
    c.velocidade_base, 
    c.ataque_fisico_base, 
    c.ataque_magico_base
FROM public.cavaleiro c
WHERE c.nome IN ('⚡Seiya','🐉Shiryu', '❄️Hyoga');

