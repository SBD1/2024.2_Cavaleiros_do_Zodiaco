INSERT INTO public.habilidade
( classe_habilidade, elemento_habilidade, nome, custo, dano, descricao, frase_uso, nivel_necessario, audio)
VALUES( 
    2,  -- Classe de habilidade (1 pode ser "Ofensiva")
    3,  -- Elemento relacionado (1 pode ser "Cosmos")
    'Meteoro de Pégaso', 
    20,  -- Custo de uso (ex.: 20 de magia)
    100,
    'Um ataque poderoso com golpes consecutivos imbuídos de cosmos. Cada golpe atinge com a força do espírito de Pégaso.', 
    'Pegasus Ryu Sei Ken!', 
    5,  -- Nível necessário para desbloquear
    'meteoro_de_pegaso.mp3'
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

INSERT INTO public.habilidade
( classe_habilidade, elemento_habilidade, nome, dano, custo, descricao, frase_uso, nivel_necessario, audio)
VALUES( 
    2,  -- Classe de habilidade (1 pode ser "Ofensiva")
    6,  -- Elemento relacionado (1 pode ser "Cosmos")
    'Garras de trovão', 
    5,  -- Custo de uso (ex.: 20 de magia)
    7,
    'desfere uma série de golpes cortantes imbuídos de eletricidade, atingindo o inimigo com alta velocidade.', 
    '⚡ GARRAAS DE TROVÃO!! ⚡', 
    5,  -- Nível necessário para desbloquear
    'garras de trovao.mp3'
);

INSERT INTO public.livro
( id_habilidade, nome, descricao, preco_venda)
VALUES( -- Gerando um novo ID para o livro
    currval('habilidade_id_habilidade_seq'),  -- Associa o livro à habilidade recém-criada
    'Livro do Garras de trovão', 
    'Um pergaminho envolto em faíscas, contendo os segredos do golpe Garras de Trovão. Apenas guerreiros do elemento Raio podem aprender essa técnica', 
    500  -- Preço de venda (em unidades monetárias do jogo)
);

INSERT INTO public.habilidade
( classe_habilidade, elemento_habilidade, nome, dano, custo, descricao, frase_uso, nivel_necessario, audio)
VALUES( 
    2,  -- Classe de habilidade (2 pode ser "DPS")
    6,  -- Elemento relacionado (6 pode ser "Raio")
    'Venha Cobra', 
    4,  -- Dano do golpe
    6,  -- Custo de uso (ex.: 6 de magia)
    'Shaina invoca sua aura em forma de uma serpente elétrica, que avança rapidamente para atacar o inimigo.', 
    '🐍 VENHA, COBRAAA!🐍', 
    4,  -- Nível necessário para desbloquear
    'venha cobra.mp3'
);

INSERT INTO public.livro
( id_habilidade, nome, descricao, preco_venda)
VALUES( 
    currval('habilidade_id_habilidade_seq'),  -- Associa o livro à habilidade recém-criada
    'Livro do Venha Cobra', 
    'Um pergaminho antigo com marcas de serpentes, contendo o segredo do golpe Venha Cobra. Apenas guerreiros do elemento Raio podem aprender essa técnica.', 
    450  -- Preço de venda (em unidades monetárias do jogo)
);


INSERT INTO public.habilidade
( classe_habilidade, elemento_habilidade, nome, dano, custo, descricao, frase_uso, nivel_necessario, audio)
VALUES( 
    2,  -- Classe de habilidade (2 para "DPS")
    6,  -- Elemento (6 para "Raio")
    'Explosão Elétrica', 
    6,  -- Dano do golpe
    8,  -- Custo de uso
    'Canaliza uma onda de choque elétrica ao redor do usuário, atingindo todos os inimigos próximos.', 
    'QUEIMEM NA FÚRIA DOS RAIOS! EXPLOSÃO ELÉTRICA!', 
    6,  -- Nível necessário para desbloquear
    'explosao_eletrica.mp3'
);

INSERT INTO public.livro
( id_habilidade, nome, descricao, preco_venda)
VALUES( 
    currval('habilidade_id_habilidade_seq'),  -- Associa o livro à habilidade recém-criada
    'Livro da Explosão Elétrica', 
    'Um tomo antigo envolto por eletricidade, contendo o segredo do golpe Explosão Elétrica. Apenas guerreiros do elemento Raio podem aprender essa técnica.', 
    300  -- Preço de venda (em unidades monetárias do jogo)
);


INSERT INTO public.item_boss_dropa
(id_boss, id_item, quantidade)
VALUES(6, currval('tipo_item_id_item_seq'::regclass), 2);

INSERT INTO public.item_boss_dropa
(id_boss, id_item, quantidade)
VALUES(6, currval('tipo_item_id_item_seq'::regclass) - 1 , 2);

INSERT INTO public.item_boss_dropa
(id_boss, id_item, quantidade)
VALUES(6, currval('tipo_item_id_item_seq'::regclass) - 2 , 2);





-- 🟤 Materiais de BRONZE
INSERT INTO public.material (nome, preco_venda, descricao)
VALUES 
('Pepita de Bronze', 1, 'Uma pequena pepita de bronze usada para restauração e reforço de armaduras.'),
('Pedaço de Bronze', 10, 'Um pedaço de bronze refinado, formado por 10 pepitas de bronze.'),
('Bloco de Bronze', 50, 'Um bloco sólido de bronze, formado por 5 pedaços de bronze.');

INSERT INTO item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES (currval('tipo_item_id_item_seq'), 2, 1), (currval('tipo_item_id_item_seq')-1, 2, 1), (currval('tipo_item_id_item_seq')-2, 2, 1);


-- ⚪ Materiais de PRATA
INSERT INTO public.material (nome, preco_venda, descricao)
VALUES 
('Pepita de Prata', 2, 'Uma pequena pepita de prata usada para restauração e reforço de armaduras.'),
('Pedaço de Prata', 20, 'Um pedaço de prata refinado, formado por 10 pepitas de prata.'),
('Bloco de Prata', 100, 'Um bloco sólido de prata, formado por 5 pedaços de prata.');

INSERT INTO item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES (currval('tipo_item_id_item_seq'), 2, 1), (currval('tipo_item_id_item_seq')-1, 2, 1), (currval('tipo_item_id_item_seq')-2, 2, 1);

-- 🟡 Materiais de OURO
INSERT INTO public.material (nome, preco_venda, descricao)
VALUES 
('Pepita de Ouro', 5, 'Uma pequena pepita de ouro usada para restauração e reforço de armaduras.'),
('Pedaço de Ouro', 50, 'Um pedaço de ouro refinado, formado por 10 pepitas de ouro.'),
('Bloco de Ouro', 250, 'Um bloco sólido de ouro, formado por 5 pedaços de ouro.');

INSERT INTO item_a_venda
(id_item, preco_compra, nivel_minimo)
VALUES (currval('tipo_item_id_item_seq')-2, 2, 1), (currval('tipo_item_id_item_seq')-1, 2, 1);

-- Receitas para criar Pedaços e Blocos
INSERT INTO Receita (id_item_gerado, descricao, nivel_minimo)
VALUES 
(currval('tipo_item_id_item_seq') - 7, 'Criar Pedaço de Bronze com Pepitas', 1),
(currval('tipo_item_id_item_seq') - 6, 'Criar Bloco de Bronze com Pedaços', 15),
(currval('tipo_item_id_item_seq') - 4, 'Criar Pedaço de Prata com Pepitas', 20),
(currval('tipo_item_id_item_seq') - 3, 'Criar Bloco de Prata com Pedaços', 25),
(currval('tipo_item_id_item_seq') - 1, 'Criar Pedaço de Ouro com Pepitas',30),
(currval('tipo_item_id_item_seq') , 'Criar Bloco de Ouro com Pedaços', 35);


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
VALUES(currval('tipo_item_id_item_seq'), 3, 5);




-- Cabeça
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max)
VALUES
('c', 'Elmo de Pégaso', 
'Protege a cabeça do cavaleiro com sua resistência mágica e física, refletindo a energia indomável do cosmos.', 
'Bronze', 50, 70, 10, 15, 100);

INSERT INTO Receita
(id_item_gerado, descricao, nivel_minimo, alma_armadura)
VALUES(currval('tipo_item_id_item_seq'), 'Gerar cabeça de armadura foda', 1,100);

-- Tronco
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max)
VALUES
('t', 'Peitoral de Pégaso', 
'Oferece excelente proteção contra ataques físicos e mágicos, simbolizando a coragem do cavaleiro.', 
'Bronze', 80, 100, 20, 25, 100);

INSERT INTO Receita
(id_item_gerado, descricao, nivel_minimo, alma_armadura)
VALUES(currval('tipo_item_id_item_seq'), 'Gerar tronco de armadura foda', 1,100);

-- Braços
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max)
VALUES
('b', 'Braçadeiras de Pégaso', 
'Aumentam a força física e protegem os braços em combates ferozes, permitindo golpes precisos e poderosos.', 
'Bronze', 30, 40, 15, 20, 100);

INSERT INTO Receita
(id_item_gerado, descricao, nivel_minimo, alma_armadura)
VALUES(currval('tipo_item_id_item_seq'), 'Gerar braçadeira de armadura foda', 1,100);

-- Pernas
INSERT INTO public.armadura
( id_parte_corpo, nome, descricao, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max)
VALUES
('p', 'Grevas de Pégaso', 
'Garantem proteção total às pernas do cavaleiro e aumentam a mobilidade e equilíbrio nos combates.', 
'Bronze', 40, 50, 10, 15, 100);

INSERT INTO Receita
(id_item_gerado, descricao, nivel_minimo, alma_armadura)
VALUES(currval('tipo_item_id_item_seq'), 'Gerar perna de armadura foda', 1,100);



INSERT INTO public.item_boss_dropa
(id_boss, id_item, quantidade)
VALUES(6, 11 , 4);

INSERT INTO public.habilidade
( classe_habilidade, elemento_habilidade, nome, dano, custo, descricao, frase_uso, nivel_necessario, audio)
VALUES( 
    2,  -- Classe de habilidade (2 para "DPS")
    6,  -- Elemento (6 para "Raio")
    'Explosão Elétrica 2', 
    12,  -- Dano do golpe
    16,  -- Custo de uso
    'Canaliza uma onda de choque elétrica ao redor do usuár2io, atingindo todos os inimigos próximos.', 
    'QUEIMEM NA FÚRIA DOS RAIOS! EXPLOSÃO ELÉTRICA2!', 
    6,  -- Nível necessário para desbloquear
    'explosao_eletrica2.mp3'
);

INSERT INTO public.livro
( id_habilidade, nome, descricao, preco_venda)
VALUES( 
    currval('habilidade_id_habilidade_seq'),  -- Associa o livro à habilidade recém-criada
    'Livro da Explosão Elétrica 2', 
    'Um tomo antigo envolto por eletricidade, contendo o segredo do golpe Explosão Elétrica. Apenas guerreiros do elemento Raio podem aprender essa técnica.', 
    400  -- Preço de venda (em unidades monetárias do jogo)
);


INSERT INTO public.item_boss_dropa
(id_boss, id_item, quantidade)
VALUES(6, currval('tipo_item_id_item_seq'::regclass), 3);

INSERT INTO public.habilidade
( classe_habilidade, elemento_habilidade, nome, dano, custo, descricao, frase_uso, nivel_necessario, audio)
VALUES( 
    2,  -- Classe de habilidade (2 para "DPS")
    6,  -- Elemento (6 para "Raio")
    'Explosão Elétrica 3', 
    12,  -- Dano do golpe
    16,  -- Custo de uso
    'Canaliza uma onda de choque elétrica ao redor do usuár2io, atingindo todos os inimigos próximos.', 
    'QUEIMEM NA FÚRIA DOS RAIOS! EXPLOSÃO ELÉTRICA2!', 
    6,  -- Nível necessário para desbloquear
    'explosao_eletrica2.mp3'
);

INSERT INTO public.livro
( id_habilidade, nome, descricao, preco_venda)
VALUES( 
    currval('habilidade_id_habilidade_seq'),  -- Associa o livro à habilidade recém-criada
    'Livro da Explosão Elétrica 3', 
    'Um tomo antigo envolto por eletricidade, contendo o segredo do golpe Explosão Elétrica. Apenas guerreiros do elemento Raio podem aprender essa técnica.', 
    400  -- Preço de venda (em unidades monetárias do jogo)
);


INSERT INTO public.item_boss_dropa
(id_boss, id_item, quantidade)
VALUES(6, currval('tipo_item_id_item_seq'::regclass), 3);