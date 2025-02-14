### Data Manipulation Language (DML)

### Introdução

O Data Manipulation Language (DML) é um subconjunto da linguagem SQL responsável pela manipulação dos dados armazenados em um banco de dados. Segundo Elmasri e Navathe, no livro "Sistemas de Banco de Dados", os comandos DML incluem inserção (INSERT), atualização (UPDATE) e remoção (DELETE) de dados. Essas operações são essenciais para a gestão dinâmica da informação dentro do sistema, permitindo modificações em tempo de execução sem alterar a estrutura do banco de dados.

### Objetivos

Este documento apresenta a implementação e utilização de comandos DML no sistema, detalhando suas funcionalidades, benefícios e aplicabilidades dentro do contexto do gerenciamento de dados. As operações DML garantem a inserção, modificação e exclusão de registros, assegurando a integridade e consistência das informações.

### V10_create_npc

Insere valores na tabela "custos_ferreiro", determinando os custos de restauração, melhora e desmanche de equipamentos.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INTO public.custos_ferreiro (tipo_acao, raridade, durabilidade_min, durabilidade_max, custo_alma) VALUES 
    ('restaurar', 'Bronze', 75, 100, 5),
    ('restaurar', 'BronzeINSERT', 50, 74, 10),
    ('restaurar', 'Bronze', 25, 49, 15),
    ('restaurar', 'Bronze', 0, 24, 20),

    ('restaurar', 'Prata', 75, 100, 10),
    ('restaurar', 'Prata', 50, 74, 20),
    ('restaurar', 'Prata', 25, 49, 30),
    ('restaurar', 'Prata', 0, 24, 40),

    ('restaurar', 'Ouro', 75, 100, 25),
    ('restaurar', 'Ouro', 50, 74, 40),
    ('restaurar', 'Ouro', 25, 49, 60),
    ('restaurar', 'Ouro', 0, 24, 80);

    INSERT INTO public.custos_ferreiro (tipo_acao, raridade, custo_alma) VALUES 
    ('melhorar', 'Bronze', 20),
    ('melhorar', 'Prata', 50);

    INSERT INTO public.custos_ferreiro (tipo_acao, raridade, custo_alma) VALUES 
    ('desmanchar', 'Bronze', 1),
    ('desmanchar', 'Prata', 5),
    ('desmanchar', 'Ouro', 15);

    ```
</details>

### V36_insert_elemento_classe_table

Insere novos elementos na tabela "Elemento" e define suas relações de fraqueza e força.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Elemento (id_elemento, nome, descricao)
    VALUES
    (1, 'Água', 'Flui e adapta-se, frequentemente usada para defesa e restrição de movimentos.'),
    (2, 'Fogo', 'Controla o calor e as chamas, usado frequentemente para atacar com intensidade.'),
    (3, 'Luz', 'Sólido e confiável, usado para defesa e ataques físicos.'),
    (4, 'Terra', 'Sólido e confiável, usado para defesa e ataques físicos.'),
    (5, 'Trevas', 'Sólido e confiável, usado para defesa e ataques físicos.'),
    (6, 'Trovão', 'Poderoso e chocante, usado para ataques elétricos rápidos e devastadores.'),
    (7, 'Vento', 'Rápido e inconstante, usado para movimentação rápida e ataques evasivos.');



    UPDATE Elemento SET fraco_contra = 4, forte_contra = 2 WHERE id_elemento = 1;  -- Agua fraco contra Terra, forte contra Fogo
    UPDATE Elemento SET fraco_contra = 1, forte_contra = 7 WHERE id_elemento = 2;  -- Fogo fraco contra Água, forte contra Vento
    UPDATE Elemento SET fraco_contra = 0, forte_contra = 5 WHERE id_elemento = 3; -- Luz forte contra trevas mas sem desvantagens
    UPDATE Elemento SET fraco_contra = 6, forte_contra = 1 WHERE id_elemento = 4; -- Terra fraco contra Trovão, forte contra Água
    UPDATE Elemento SET fraco_contra = 3, forte_contra = 0 WHERE id_elemento = 5; -- Trevas fraco contra Luz, forte contra nada
    UPDATE Elemento SET fraco_contra = 7, forte_contra = 4 WHERE id_elemento = 6; -- Trovão fraco contra Vento, forte contra Terra
    UPDATE Elemento SET fraco_contra = 2, forte_contra = 6 WHERE id_elemento = 7; -- Vento fraco contra Fogo, forte contra Trovão

    INSERT INTO Classe (nome, descricao)
    VALUES
    ('Tank', 'O Tank é a muralha inabalável do grupo, projetado para absorver dano e proteger seus aliados. Com armaduras robustas e habilidades de provocação, ele garante que os inimigos mantenham o foco nele, permitindo que o restante do time lute em segurança.'),
    ('DPS', 'O DPS é o principal responsável por causar dano aos inimigos. Seja com ataques rápidos e precisos ou habilidades devastadoras, sua função é derrotar oponentes o mais rápido possível enquanto explora pontos fracos.'),
    ('Healer', 'O Healer é o sustentáculo do grupo, focado em manter os aliados vivos e fortalecidos. Suas habilidades de cura, purificação e suporte fazem dele uma classe essencial para enfrentar longas batalhas e chefes difíceis.');
    ```
</details>

### V37_insert_into_player

Insere registros na tabela "Parte_Corpo", estabelecendo suas características.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO public.parte_corpo (id_parte_corpo, nome, defesa_magica, defesa_fisica, chance_acerto, chance_acerto_critico)
    VALUES 
        ('c', 'Cabeça', 5, 10, 80, 5),
        ('t', 'Tronco', 8, 15, 90, 3),
        ('b', 'Braços', 4, 7, 85, 8),
        ('p', 'Pernas', 6, 9, 88, 6);

    ```
</details>

### V48_insert_into_audio

Adiciona registros na tabela "audios", armazenando informações sobre trilhas sonoras do jogo.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO audios (nome, nome_arquivo, descricao) VALUES
    ('Tema de Abertura', 'tema_abertura.mp3', 'Música que toca na abertura do jogo.'),
    ('Tema de Encerramento', 'tema_encerramento.mp3', 'Música que toca ao final do jogo.');
    ```
</details>

### V51_insert_inimigos

Insere novos inimigos na tabela "Inimigo", definindo suas estatísticas e falas.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Inimigo(id_classe, id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, velocidade, ataque_fisico, ataque_magico, dinheiro, fala_inicio)
    VALUES(2, 1, 'Aspirante a Cavaleiro de Bronze Fogo', 1, 0, 20, 15, 20, 20, 10, 2, 'Você acha que vai se tornar um verdadeiro cavaleiro? HAHAHAHA');

    -- healer agua
    INSERT INTO Inimigo(id_classe, id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, velocidade, ataque_fisico, ataque_magico, dinheiro, fala_inicio)
    VALUES(3, 2, 'Aspirante a Cavaleiro de Bronze Agua', 1, 0, 10, 30, 15, 10, 2, 10, 'Você acha que vai se tornar um verdadeiro cavaleiro? HAHAHAHA');

    -- tank terra
    INSERT INTO Inimigo(id_classe, id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, velocidade, ataque_fisico, ataque_magico, dinheiro, fala_inicio)
    VALUES(1, 3, 'Aspirante a Cavaleiro de Bronze Terra', 1, 0, 5, 35, 20, 30, 5, 0, 'Você acha que vai se tornar um verdadeiro cavaleiro? HAHAHAHA');
    ```
</details>

### V53_insert_saga01

Introduz dados na tabela "Saga" e relaciona missões e salas do jogo.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Saga ( id_missao_requisito, nome, descricao, nivel_recomendado)
    VALUES ( NULL, 'Saga SafeHouse', 'O início da jornada dos Cavaleiros de Bronze, onde cresceram e descobriram seus destinos.', 1);



    INSERT INTO Casa (id_saga, id_missao_requisito, nome, descricao, nivel_recomendado)
    VALUES ( 1, NULL, 'Casa SafeHouse', 'O lugar onde os
    Cavaleiros de Bronze viveram antes de serem enviados para seus treinamentos.', 1);



    INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
    VALUES ( 1, 'Sala Principal SafeHouse', 2, 3, NULL, NULL);

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
    VALUES ( 1, 'Sala Das Missões', NULL, 1, NULL, NULL);

    INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
    VALUES ( 1, 'Oficina de Armaduras de Mu', 1, NULL, NULL, NULL);




    INSERT INTO public.Sala_Segura (id_sala)
    VALUES(1);
    ```
</details>

### V54_insert_saga02

Cria novos registros na tabela "Saga", expandindo o conteúdo narrativo do jogo.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Saga ( id_missao_requisito, nome, descricao, nivel_recomendado)
    VALUES ( NULL, 'Saga Guerra Galáctica', 'Um torneio lendário onde os Cavaleiros de Atena lutam pelo prêmio supremo: a sagrada Armadura de Ouro de Sagitário. Cada batalha testa força, coragem e o poder do Cosmo, enquanto segredos e rivalidades ameaçam a paz no Santuário. O início de uma jornada épica pela proteção da deusa Atena!', 1);

    INSERT INTO Casa ( id_saga, id_missao_requisito,  nome, descricao, nivel_recomendado)
    VALUES ( 2, NULL, 'Grécia', 'O lugar onde o cavaleiro de Pegasus conseguiu sua armadura.', 1);


    -- salas da casa 1 Grecia

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 4
    VALUES (2, 'Entrada Campo de Treinamento', 5, NULL, NULL, NULL);

    INSERT INTO Grupo_inimigo(id_sala)
    VALUES(4);

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 5
    VALUES (2, 'Campo de Treinamento', 6, 4, 7, 8);

    INSERT INTO Grupo_inimigo(id_sala)
    VALUES(5);


    INSERT INTO Sala  (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 6
    VALUES ( currval('casa_id_casa_seq'::regclass), 'Floresta da Perseverança', 12, 5, NULL, NULL);

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 7
    VALUES ( currval('casa_id_casa_seq'::regclass),  'Gruta do Desafio', NULL, NULL, 10, 5);

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 8
    VALUES ( currval('casa_id_casa_seq'::regclass), 'Colina dos Ventos Gelados', NULL, NULL, 5, 9 );

    INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 9
    VALUES ( currval('casa_id_casa_seq'::regclass), 'Lago Congelado', NULL, NULL, 8, NULL);

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 10
    VALUES ( currval('casa_id_casa_seq'::regclass),  'Templo Abandonado', NULL, 11, NULL, 7);

    -- id sala 11 boss cassios
    INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) 
    VALUES ( currval('saga_id_saga_seq'::regclass), 'Arena Final', 10, NULL, NULL, NULL); 

    INSERT INTO public.item_missao (nome, descricao) 
    VALUES ('Orelha de Cassios', 'A orelha perdida de Cassios, símbolo de sua derrota após um combate feroz.');

    INSERT INTO public.cavaleiro (id_classe, id_elemento, nome, nivel, hp_max, magia_max, velocidade, ataque_fisico, ataque_magico)
    VALUES( 2, 3, 'Seiya de Pégaso', 3, 100, 50, 70, 25, 25);

    INSERT INTO public.missao (id_missao_anterior, item_necessario, id_cavaleiro_desbloqueado, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
    VALUES (NULL, 5, currval('tipo_personagem_id_personagem_seq'), 'Derrote Cassios', 'Cassios, o imponente guerreiro treinado por Shaina, ameaça o equilíbrio do Santuário com sua força bruta.', 'Sua missão é enfrentar Cassios em combate. Cuidado, ele é forte e implacável. Apenas os mais habilidosos sobreviverão.', 'Você derrotou Cassios em um combate épico e adquiriu sua orelha como prova de sua vitória.');

    INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico, ataque_magico, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao, id_elemento) 
    VALUES (11, 5, 'Cassios', 2, 300, 200, 200, 50, 50, 60, 20, 10, 50, 'Você ousa desafiar Cassios, o campeão da força bruta? Prepare-se para ser esmagado!', 'Você é fraco demais para me enfrentar. Nem deveria ter tentado.', 'Impossível! Como um guerreiro tão insignificante conseguiu superar minha força bruta?', 'Se tem coragem para me enfrentar, venha com tudo ou será destruído!', 4);

    INSERT INTO public.item_boss_dropa
    (id_boss, id_item, quantidade)
    VALUES(5, 5, 1);

    UPDATE public.parte_corpo_boss
    SET defesa_fisica=10, defesa_magica=10, chance_acerto=100, chance_acerto_critico=70
    WHERE id_boss=currval('tipo_personagem_id_personagem_seq'::regclass) AND parte_corpo='c';

    UPDATE public.parte_corpo_boss
    SET defesa_fisica=30, defesa_magica=30, chance_acerto=70, chance_acerto_critico=30
    WHERE id_boss=currval('tipo_personagem_id_personagem_seq'::regclass) AND parte_corpo='t';

    UPDATE public.parte_corpo_boss
    SET defesa_fisica=20, defesa_magica=20, chance_acerto=70, chance_acerto_critico=30
    WHERE id_boss=currval('tipo_personagem_id_personagem_seq'::regclass) AND parte_corpo='b';

    UPDATE public.parte_corpo_boss
    SET defesa_fisica=20, defesa_magica=20, chance_acerto=70, chance_acerto_critico=30
    WHERE id_boss=currval('tipo_personagem_id_personagem_seq'::regclass) AND parte_corpo='p';

    -- id sala 12 boss shaina de cobra
    INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) 
    VALUES ( currval('saga_id_saga_seq'::regclass), 'Templo Sagrado', NULL, 6, NULL, NULL);  



    INSERT INTO public.item_missao (nome, descricao) 
    VALUES ('Veneno de Cobra', 'Um frasco contendo o veneno letal de Shaina, a Amazona de Prata. Um item raro e perigoso.');

    -- INSERT INTO public.item_boss_dropa
    -- (id_boss, id_item, quantidade)
    -- VALUES(6, 6, 1);

    INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
    VALUES (1, currval('tipo_item_id_item_seq'::regclass), 'Derrote Shaina', 'Shaina, a Amazona de Prata, tem causado problemas em nosso território. Ela é perigosa e deve ser detido.', 'Sua missão é enfrentar e derrotar Shaina. Lembre-se, ela é rápido e usa seu veneno para enfraquecer seus inimigos.', 'Parabéns! Você derrotou Shaina e adquiriu seu mortal Veneno de Cobra. Sua bravura será lembrada.');


    INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico, ataque_magico, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao, id_elemento) 
    VALUES (12, currval('tipo_item_id_item_seq'::regclass), 'Shaina de Cobra', 1, 150, 100, 100, 100, 100, 100, 100, 100, 30, 'Você ousa desafiar uma Amazona de Prata? Sentirá o poder do veneno da Cobra!', 'Eu avisei... sua força é insignificante contra o meu veneno mortal!', 'Impossível! Como um cavaleiro tão inferior conseguiu me derrotar?!', 'Se deseja sair vivo, mostre que é digno e enfrente-me com coragem!', 6);



    -- salas da casa 3 arena galactica
    INSERT INTO Casa ( id_saga, id_missao_requisito, nome, descricao, nivel_recomendado)
    VALUES (2, NULL, 'Arena da Guerra Galáctica', 'descricao', 3);

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 13
    VALUES ( currval('casa_id_casa_seq'::regclass), 'Arena de batalha Geki', NULL, NULL, NULL, NULL);
    ```
</details>

### V99_insert_excluir_DPS

Insere e remove habilidades de personagens conforme sua classe e elemento.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
    ```
</details>

### V103_insert_npcs

Adiciona NPCs ao jogo, como ferreiros e mercadores, com seus respectivos diálogos e funções.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO public.ferreiro (id_sala, id_missao_desbloqueia, nome, descricao, dialogo_inicial, dialogo_reparar, dialogo_upgrade, dialogo_desmanchar, dialogo_sair) 
    VALUES (3, 1, 'Mu de Áries', 'O principal reparador de armaduras no universo de Cavaleiros do Zodíaco, Mu é a escolha perfeita para ser o ferreiro.', 'Bem-vindo, Cavaleiro. As armaduras são a essência de sua força. O que você busca hoje?', 'Vejo que sua armadura sofreu em batalhas árduas... Deixe-me restaurá-la ao seu esplendor original. Um Cavaleiro deve sempre proteger sua essência.', 'Com a sinergia entre seu cosmo e minha maestria, posso aprimorar sua armadura. Prepare-se para enfrentar desafios ainda maiores!', 'Cada armadura carrega a energia de seu antigo dono... Se desejar, posso extrair essa essência para transformá-la em uma Alma de Armadura. Mas lembre-se, uma vez feito, não há volta.', 'Seu caminho é longo, Cavaleiro. Que sua armadura sempre o proteja. Volte sempre que precisar.');

    INSERT INTO public.mercador( id_sala, nome, descricao, dialogo_inicial, dialogo_vender, dialogo_comprar, dialogo_sair)
    VALUES(1, 'Jabu de Unicórnio', 'Jabu é um Cavaleiro prático e secundário, sempre disposto a ajudar. Ele se encaixa perfeitamente como um mercador de itens básicos e úteis.', 'Ah, Cavaleiro, chegou na hora certa! Estou com itens que podem ser exatamente o que você procura, e se tiver algo para vender, vamos negociar – nada escapa do meu faro para bons negócios!', 'Então, Cavaleiro, o que você tem para me oferecer? Estou sempre em busca de algo útil... mas espero que seja algo que valha o meu tempo.', 'Você está comprando algo? Vamos negociar o preço.', 'Volte sempre que precisar de algo. Até mais, Cavaleiro!');

    INSERT INTO public.quest( id_sala, nome, descricao, dialogo_inicial, dialogo_recusa)
    VALUES(2, 'Saori Kido', 'A deusa Athena, protetora da Terra, é uma guia espiritual e estratégica para os Cavaleiros do Zodíaco, sempre fornecendo missões importantes.', 'Cavaleiro, sua coragem e lealdade são indispensáveis. A batalha que se aproxima será decisiva. Posso contar com você?', 'Eu entendo que você não está pronto no momento. Mas lembre-se, o mundo depende de nós. Volte quando estiver preparado.');

    CREATE OR REPLACE FUNCTION verificar_npc_na_sala(id_jogador INTEGER)
    RETURNS TEXT AS $$
    DECLARE
        id_sala_atual INTEGER;
        tipo_npc TEXT;
    BEGIN
        SELECT id_sala
        INTO id_sala_atual
        FROM Party pa join Player pl
        ON pl.id_player = pa.id_player
        WHERE pl.id_player = id_jogador;

        SELECT CASE
            WHEN EXISTS (SELECT 1 FROM ferreiro WHERE id_sala = id_sala_atual) THEN 'Ferreiro'
            WHEN EXISTS (SELECT 1 FROM quest WHERE id_sala = id_sala_atual) THEN 'Missao'
            WHEN EXISTS (SELECT 1 FROM mercador WHERE id_sala = id_sala_atual) THEN 'Mercador'
            ELSE NULL
        END
        INTO tipo_npc;

        RETURN tipo_npc;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V666_ee

Insere registros específicos relacionados a missões, bosses e recompensas.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO public.saga
    (id_missao_requisito, nome, descricao, nivel_recomendado)
    VALUES( NULL, 'Sem SS', 'Não haverá SS por aqui', 0);

    INSERT INTO public.casa
    ( id_saga, id_missao_requisito, nome, descricao, nivel_recomendado)
    VALUES(  currval('saga_id_saga_seq'::regclass), NULL, 'SEM MS', 'Não haverá MS por aqui', 0);

    INSERT INTO public.sala
    (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
    VALUES( currval('casa_id_casa_seq'::regclass), 'SEM MM', 0, 0, 0, 0);

    INSERT INTO public.item_missao (nome, descricao) 
    VALUES ('666', 'Seria essa a aprovação em bancos?');

    INSERT INTO public.missao (id_missao_anterior, item_necessario, id_cavaleiro_desbloqueado, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
    VALUES (NULL, currval('tipo_item_id_item_seq'), NULL, '666', 'Seria assim que consegue o SS em bancos?', '666', '666');

    INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico, ataque_magico, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao, id_elemento) 
    VALUES (currval('sala_id_sala_seq'::regclass), currval('tipo_item_id_item_seq'), 'Mauricio Serrano', 666, 666, 666666, 666666, 666666, 666666, 666666, 666666, 666666, 666666, 'REPROVADO!!!', 'SR PRA VOCE', 'CHEATER', 'Só desiste não tem como ganhar', 1);
    ```
</details>

### Aprender habilidade

Atualiza ou insere habilidades para personagens, diferenciando entre jogadores e cavaleiros.

<details>
    <sumary>Migrações</sumary>

    ```python
    # 📌 Diferencia se o personagem é um Player ou um Cavaleiro
        if tipo_personagem == "player":
            cursor.execute("DELETE FROM habilidade_player WHERE id_player = %s AND slot = %s;", (id_personagem, escolha_slot))
            cursor.execute("INSERT INTO habilidade_player (id_player, id_habilidade, slot) VALUES (%s, %s, %s);", (id_personagem, id_habilidade, escolha_slot))
        else:
            cursor.execute("DELETE FROM habilidade_cavaleiro WHERE id_cavaleiro = %s AND slot = %s;", (id_personagem, escolha_slot))
            cursor.execute("INSERT INTO habilidade_cavaleiro (id_cavaleiro, id_habilidade, slot) VALUES (%s, %s, %s);", (id_personagem, id_habilidade, escolha_slot))

        console.print(f"[bold magenta]🔥 {nome_habilidade} aprendida e substituiu a habilidade antiga![/bold magenta]")

    else:
        # 📌 Aprender uma nova habilidade caso ainda tenha espaço
        if tipo_personagem == "player":
            cursor.execute("INSERT INTO habilidade_player (id_player, id_habilidade, slot) VALUES (%s, %s, %s);", (id_personagem, id_habilidade, len(habilidades_existentes) + 1))
        else:
            cursor.execute("INSERT INTO habilidade_cavaleiro (id_cavaleiro, id_habilidade, slot) VALUES (%s, %s, %s);", (id_personagem, id_habilidade, len(habilidades_existentes) + 1))

        console.print(f"[bold magenta]🔥 {nome_habilidade} aprendida com sucesso![/bold magenta]")

    input("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
    ```
</details>

### Criar jogador

Adiciona novos jogadores ao banco de dados, garantindo a correta inicialização de suas informações.

<details>
    <sumary>Migrações</sumary>

    ```python
    from rich.console import Console
from rich.panel import Panel
from ..database import obter_cursor

def criar_jogador(nome_cdz: str):
    """🎮 Cria um novo jogador no banco de dados."""

    console = Console()

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT insert_cdz_player(%s);", (nome_cdz,))
            
            console.print(Panel.fit(
                f"✅ [bold green]Jogador '{nome_cdz}' criado com sucesso![/bold green] 🎉",
                title="🏆 Novo Cavaleiro Criado!",
                border_style="green"
            ))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao criar jogador:[/bold red] {e}",
            title="⚠️ Erro",
            border_style="red"
        ))
from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from ..database import obter_cursor

def criar_jogador(console: Console):
    """🎮 Cria um novo jogador no banco de dados solicitando o nome ao usuário."""

    # Exibe painel de entrada
    console.print(Panel(
        Text("Digite o nome do novo cavaleiro:", style="bold cyan"),
        title="📝 Criação de Jogador",
        border_style="blue",
        expand=False
    ))

    nome_cdz = input("🎭 Nome do cavaleiro: ").strip()

    if not nome_cdz:
        console.print(Panel(
            Text("❌ Nome inválido! O nome do cavaleiro não pode estar vazio.", style="bold red"),
            title="⚠️ Erro",
            border_style="red",
            expand=False
        ))
        return

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT insert_cdz_player(%s);", (nome_cdz,))

        console.print(Panel(
            Text(f"✅ Jogador '{nome_cdz}' criado com sucesso! 🎉", style="bold green"),
            title="🏆 Novo Cavaleiro Criado!",
            border_style="green",
            expand=False
        ))

    except Exception as e:
        console.print(Panel(
            Text(f"❌ Erro ao criar jogador: {e}", style="bold red"),
            title="⚠️ Erro",
            border_style="red",
            expand=False
        ))
    ```
</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 11/12/2024 | Criação do Documento | [Vinícius Rufino](https://github.com/RufinoVfR) |
| 1.0 | 11/12/2024 | Finalização do documento | [Lucas Avelar](https://github.com/LucasAvelar2711) |
|  1.1 | 29/01/2025 | Melhoria do DML | Lucas Dourado |
|  2.0 | 02/02/2025 | Atualização do Documento | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  2.1 | 03/02/2025 | Atualização do DML | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  3.0 | 14/02/2025 | Atualização e refatoração do documento para versão final | [Vinícius Rufino](https://github.com/RufinoVfR) |