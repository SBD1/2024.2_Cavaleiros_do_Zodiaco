INSERT INTO public.habilidade
( classe_habilidade, elemento_habilidade, nome, custo, descricao, frase_uso, nivel_necessario)
VALUES( 
    1,  -- Classe de habilidade (1 pode ser "Ofensiva")
    1,  -- Elemento relacionado (1 pode ser "Cosmos")
    'Meteoro de Pégaso', 
    20,  -- Custo de uso (ex.: 20 de magia)
    'Um ataque poderoso com golpes consecutivos imbuídos de cosmos. Cada golpe atinge com a força do espírito de Pégaso.', 
    'Pegasus Ryu Sei Ken!', 
    5  -- Nível necessário para desbloquear
);

-- Inserindo o livro que desbloqueia a habilidade
INSERT INTO public.livro
( id_habilidade, nome, descricao, preco_venda)
VALUES( -- Gerando um novo ID para o livro
    currval('habilidade_id_habilidade_seq'),  -- Associa o livro à habilidade recém-criada
    'Livro do Meteoro de Pégaso', 
    'Este livro contém os segredos do Meteoro de Pégaso, permitindo ao portador aprender essa técnica lendária.', 
    500  -- Preço de venda (em unidades monetárias do jogo)
);

INSERT INTO item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES (
    currval('tipo_item_id_item_seq'),  -- Usa o ID do livro criado anteriormente
    2,  -- Preço de compra (valor superior ao preço de venda do livro)
    1     -- Nível mínimo necessário para comprar
);



-- 🟤 Materiais de BRONZE
INSERT INTO public.material (nome, preco_venda, descricao)
VALUES 
('Pepita de Bronze', 1, 'Uma pequena pepita de bronze usada para restauração e reforço de armaduras.'),
('Pedaço de Bronze', 10, 'Um pedaço de bronze refinado, formado por 10 pepitas de bronze.'),
('Bloco de Bronze', 50, 'Um bloco sólido de bronze, formado por 5 pedaços de bronze.');


-- ⚪ Materiais de PRATA
INSERT INTO public.material (nome, preco_venda, descricao)
VALUES 
('Pepita de Prata', 2, 'Uma pequena pepita de prata usada para restauração e reforço de armaduras.'),
('Pedaço de Prata', 20, 'Um pedaço de prata refinado, formado por 10 pepitas de prata.'),
('Bloco de Prata', 100, 'Um bloco sólido de prata, formado por 5 pedaços de prata.');

-- 🟡 Materiais de OURO
INSERT INTO public.material (nome, preco_venda, descricao)
VALUES 
('Pepita de Ouro', 5, 'Uma pequena pepita de ouro usada para restauração e reforço de armaduras.'),
('Pedaço de Ouro', 50, 'Um pedaço de ouro refinado, formado por 10 pepitas de ouro.'),
('Bloco de Ouro', 250, 'Um bloco sólido de ouro, formado por 5 pedaços de ouro.');

-- Receitas para criar Pedaços e Blocos
INSERT INTO Receita (id_item_gerado, descricao)
VALUES 
(currval('tipo_item_id_item_seq') - 7, 'Criar Pedaço de Bronze com Pepitas'),
(currval('tipo_item_id_item_seq') - 6, 'Criar Bloco de Bronze com Pedaços'),
(currval('tipo_item_id_item_seq') - 4, 'Criar Pedaço de Prata com Pepitas'),
(currval('tipo_item_id_item_seq') - 3, 'Criar Bloco de Prata com Pedaços'),
(currval('tipo_item_id_item_seq') - 1, 'Criar Pedaço de Ouro com Pepitas'),
(currval('tipo_item_id_item_seq') , 'Criar Bloco de Ouro com Pedaços');


INSERT INTO Material_Receita (id_receita, id_material, quantidade)
VALUES
(currval('tipo_item_id_item_seq') - 7, currval('tipo_item_id_item_seq') - 8, 10), -- 10 Pepitas de Bronze → 1 Pedaço de Bronze
(currval('tipo_item_id_item_seq') - 6, currval('tipo_item_id_item_seq') - 7, 5),  -- 5 Pedaços de Bronze → 1 Bloco de Bronze

-- Materiais necessários para criar Pedaços e Blocos de Prata
(currval('tipo_item_id_item_seq') - 4, currval('tipo_item_id_item_seq') - 5, 10), -- 10 Pepitas de Prata → 1 Pedaço de Prata
(currval('tipo_item_id_item_seq') - 3, currval('tipo_item_id_item_seq') - 4, 5),  -- 5 Pedaços de Prata → 1 Bloco de Prata

-- Materiais necessários para criar Pedaços e Blocos de Ouro
(currval('tipo_item_id_item_seq') - 1, currval('tipo_item_id_item_seq') - 2, 10), -- 10 Pepitas de Ouro → 1 Pedaço de Ouro
(currval('tipo_item_id_item_seq') , currval('tipo_item_id_item_seq') - 1, 5);  -- 5 Pedaços de Ouro → 1 Bloco de Ouro


-- Restaurar Armadura (Bronze)
INSERT INTO material_necessario_ferreiro (id_material, id_custo_ferreiro, quantidade)
VALUES
(currval('tipo_item_id_item_seq') - 8, 1, 5),  -- 5 Pepitas de Bronze para restaurar (75-100 durabilidade)
(currval('tipo_item_id_item_seq') - 8, 2, 10), -- 10 Pepitas de Bronze para restaurar (50-74 durabilidade)
(currval('tipo_item_id_item_seq') - 8, 3, 15), -- 15 Pepitas de Bronze para restaurar (25-49 durabilidade)
(currval('tipo_item_id_item_seq') - 8, 4, 20), -- 20 Pepitas de Bronze para restaurar (0-24 durabilidade)

-- Restaurar Armadura (Prata)
(currval('tipo_item_id_item_seq') - 4, 5, 5),  -- 5 Pedaços de Prata para restaurar (75-100 durabilidade)
(currval('tipo_item_id_item_seq') - 4, 6, 10), -- 10 Pedaços de Prata para restaurar (50-74 durabilidade)
(currval('tipo_item_id_item_seq') - 4, 7, 15), -- 15 Pedaços de Prata para restaurar (25-49 durabilidade)
(currval('tipo_item_id_item_seq') - 4, 8, 20), -- 20 Pedaços de Prata para restaurar (0-24 durabilidade)

-- Restaurar Armadura (Ouro)
(currval('tipo_item_id_item_seq'), 9, 2),  -- 2 Blocos de Ouro para restaurar (75-100 durabilidade)
(currval('tipo_item_id_item_seq'), 10, 4), -- 4 Blocos de Ouro para restaurar (50-74 durabilidade)
(currval('tipo_item_id_item_seq'), 11, 6), -- 6 Blocos de Ouro para restaurar (25-49 durabilidade)
(currval('tipo_item_id_item_seq'), 12, 8); -- 8 Blocos de Ouro para restaurar (0-24 durabilidade)

-- Melhorar Armadura (Bronze → Prata)
INSERT INTO material_necessario_ferreiro (id_material, id_custo_ferreiro, quantidade)
VALUES
(currval('tipo_item_id_item_seq') - 3 , 13, 3); -- 3 Blocos de Prata para melhorar de Bronze para Prata

-- Melhorar Armadura (Prata → Ouro)
INSERT INTO material_necessario_ferreiro (id_material, id_custo_ferreiro, quantidade)
VALUES
(currval('tipo_item_id_item_seq'), 14, 3); -- 3 Blocos de Ouro para melhorar de Prata para Ouro


INSERT INTO public.item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES(currval('tipo_item_id_item_seq'), 2, 1);




-- Cabeça
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max, preco_venda)
VALUES
('c', 'Elmo de Pégaso', 
'O elmo da Armadura de Pégaso protege a cabeça do cavaleiro com sua resistência mágica e física, refletindo a energia indomável do cosmos.', 
'Bronze', 50, 70, 10, 15, 100, 500);

INSERT INTO public.item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES(currval('tipo_item_id_item_seq'), 2, 1);

-- Tronco
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max, preco_venda)
VALUES
('t', 'Peitoral de Pégaso', 
'O peitoral da Armadura de Pégaso oferece excelente proteção contra ataques físicos e mágicos, simbolizando a coragem do cavaleiro.', 
'Bronze', 80, 100, 20, 25, 150, 1000);

INSERT INTO public.item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES(currval('tipo_item_id_item_seq'), 2, 1);

-- Braços
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max, preco_venda)
VALUES
('b', 'Braçadeiras de Pégaso', 
'As braçadeiras da Armadura de Pégaso aumentam a força física e protegem os braços em combates ferozes, permitindo golpes precisos e poderosos.', 
'Bronze', 30, 40, 15, 20, 80, 400);

INSERT INTO public.item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES(currval('tipo_item_id_item_seq'), 2, 1);

-- Pernas
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max, preco_venda)
VALUES
('p', 'Grevas de Pégaso', 
'As grevas da Armadura de Pégaso garantem proteção total às pernas do cavaleiro e aumentam a mobilidade e equilíbrio nos combates.', 
'Bronze', 40, 50, 10, 15, 90, 450);

INSERT INTO public.item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES(currval('tipo_item_id_item_seq'), 2, 1);

INSERT INTO public.armadura_instancia
(id_armadura, id_parte_corpo_armadura, id_inventario, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_atual, preco_venda)
VALUES(currval('tipo_item_id_item_seq'),'p', 1, 'Bronze', 40, 50, 10, 15, 90, 450);

-- INSERT INTO public.item_armazenado
-- (id_inventario, id_item, quantidade)
-- VALUES(1, 8, 100);

INSERT INTO public.armadura_instancia
(id_armadura, id_parte_corpo_armadura, id_inventario, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_atual, preco_venda)
VALUES(17, 'c',  1, 'Bronze', 1, 1, 1, 1, 1, 1);