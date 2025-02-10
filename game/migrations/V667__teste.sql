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
VALUES(8, currval('tipo_item_id_item_seq'::regclass), 3);