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

INSERT INTO public.material
(nome, preco_venda, descricao)
VALUES( 'Pepita de ferro', 1, 'pepita de ferro');

INSERT INTO public.item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES(currval('tipo_item_id_item_seq'), 2, 1);

INSERT INTO public.material
(nome, preco_venda, descricao)
VALUES( 'Slack de Ferro', 2, 'slack de ferro');


INSERT INTO public.receita
(id_item_gerado, descricao)
VALUES(currval('tipo_item_id_item_seq'), 'é um slack de ferro poxa');

INSERT INTO public.material_receita
(id_receita, id_material, quantidade)
VALUES(9, 8, 4);

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
VALUES(13,'p', 1, 'Bronze', 40, 50, 10, 15, 90, 450);