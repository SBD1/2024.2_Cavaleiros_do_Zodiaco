## DML

### Data Manipulation Language (DML)

A Linguagem de Manipulação de Dados (DML) é utilizada para inserir, atualizar, excluir e gerenciar os dados armazenados nas tabelas. Comandos DML são fundamentais para a operação diária do banco de dados.

```sql
ALTER TABLE santuario RENAME TO saga;
ALTER TABLE saga RENAME COLUMN id_santuario TO id_saga;
ALTER TABLE saga RENAME COLUMN id_missao_proximo_santuario TO id_missao_proxima_saga;
ALTER TABLE casa RENAME COLUMN id_santuario TO id_saga;
ALTER TABLE Missao ALTER COLUMN nome TYPE VARCHAR USING NULL;

INSERT INTO Saga ( id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
VALUES ( NULL, NULL, 'Saga SafeHouse', 'O início da jornada dos Cavaleiros de Bronze, onde cresceram e descobriram seus destinos.', 1);



INSERT INTO Casa (id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES ( 1, NULL, NULL, 'Casa SafeHouse', 'O lugar onde os
Cavaleiros de Bronze viveram antes de serem enviados para seus treinamentos.', 1);



INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES ( 1, 'Sala Principal SafeHouse', 2, 3, NULL, NULL);

INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES ( 1, 'Sala Das Missões', NULL, 1, NULL, NULL);

INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES ( 1, 'Oficina de Armaduras de Mu', 1, NULL, NULL, NULL);

INSERT INTO Saga (id_saga, id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
VALUES (2, NULL, NULL, 'Saga das 12 Casas', 'Os Cavaleiros de Bronze enfrentam os Cavaleiros de Ouro para salvar Atena.', 1);

ALTER TABLE Tipo_Item ALTER COLUMN tipo_item TYPE enum_tipo_item USING NULL;

INSERT INTO public.tipo_item (tipo_item)
VALUES('i');

INSERT INTO public.item_missao
(id_item, nome, descricao)
VALUES(1, 'Benção de Mu', 'Ao derrotar Mu ele abençoa os Cavaleiros');

INSERT INTO public.missao
(id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa)
VALUES( NULL, 1, 'Derrote o Cavaleiro de Áries', '', '', '');



INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (2, 2, NULL, 1, 'Casa Áries', 'A casa protegida por Mu, o Cavaleiro de Áries, que repara as armaduras dos Cavaleiros de Bronze.', 1);



INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (4, 2, 'Covil dos esqueletos', 5, NULL, NULL, NULL);


INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (5, 2, 'Covil Dos Anões', NULL, 4, 6, 7);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (6, 2, 'Covil das serpentes', NULL, NULL, NULL, 5);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (7, 2, 'Sala dos Cavaleiros Negros', 8, NULL, 5, NULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (8, 2, 'Sala de combate de Áries', NULL, 7, NULL, NULL);


INSERT INTO Elemento (id_elemento, nome, descricao)
VALUES
  (1, 'Fogo', 'Controla o calor e as chamas, usado frequentemente para atacar com intensidade.'),
  (2, 'Água', 'Flui e adapta-se, frequentemente usada para defesa e restrição de movimentos.'),
  (3, 'Terra', 'Sólido e confiável, usado para defesa e ataques físicos.'),
  (4, 'Vento', 'Rápido e inconstante, usado para movimentação rápida e ataques evasivos.'),
  (5, 'Trovão', 'Poderoso e chocante, usado para ataques elétricos rápidos e devastadores.');
UPDATE Elemento SET fraco_contra = 2, forte_contra = 3 WHERE id_elemento = 1;  -- Fogo fraco contra Água, forte contra Terra
UPDATE Elemento SET fraco_contra = 3, forte_contra = 1 WHERE id_elemento = 2;  -- Água fraca contra Terra, forte contra Fogo
UPDATE Elemento SET fraco_contra = 4, forte_contra = 5 WHERE id_elemento = 3; -- Terra fraca contra Vento, forte contra Trovão
UPDATE Elemento SET fraco_contra = 1, forte_contra = 3 WHERE id_elemento = 4; -- Vento fraco contra Fogo, forte contra Terra
UPDATE Elemento SET fraco_contra = 3, forte_contra = 2 WHERE id_elemento = 5; -- Trovão fraco contra Terra, forte contra Água
INSERT INTO Classe (nome, descricao)
VALUES
  ('Tank', 'O Tank é a muralha inabalável do grupo, projetado para absorver dano e proteger seus aliados. Com armaduras robustas e habilidades de provocação, ele garante que os inimigos mantenham o foco nele, permitindo que o restante do time lute em segurança.'),
  ('DPS', 'O DPS é o principal responsável por causar dano aos inimigos. Seja com ataques rápidos e precisos ou habilidades devastadoras, sua função é derrotar oponentes o mais rápido possível enquanto explora pontos fracos.'),
  ('Healer', 'O Healer é o sustentáculo do grupo, focado em manter os aliados vivos e fortalecidos. Suas habilidades de cura, purificação e suporte fazem dele uma classe essencial para enfrentar longas batalhas e chefes difíceis.');

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

CREATE OR REPLACE FUNCTION setar_sala_inicial(id_player_input INT)
RETURNS VOID AS $$
DECLARE
    sala_inicial_id INT;
BEGIN
    -- Recupera o menor id_sala da tabela sala
    SELECT MIN(id_sala) INTO sala_inicial_id FROM public.sala;

    -- Verifica se existe uma sala
    IF sala_inicial_id IS NOT NULL THEN
        -- Atualiza o id_sala_safe do player
        UPDATE public.player
        SET id_sala_safe = sala_inicial_id
        WHERE id_player = id_player_input;

        -- Insere na party
        INSERT INTO public.party (id_player, id_sala)
        VALUES (id_player_input, sala_inicial_id);
    ELSE
        RAISE EXCEPTION 'Nenhuma sala encontrada na tabela sala.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION setar_nova_sala(id_player_input INT, id_sala_input INT)
RETURNS VOID AS $$
BEGIN
    -- Verifica se a sala existe
    IF EXISTS (SELECT 1 FROM public.sala WHERE id_sala = id_sala_input) THEN
        -- Atualiza o id_sala na tabela party para o jogador
        UPDATE public.party
        SET id_sala = id_sala_input
        WHERE id_player = id_player_input;

        -- Verifica se o jogador já está na tabela party, caso contrário, insere
        IF NOT FOUND THEN
            INSERT INTO public.party (id_player, id_sala)
            VALUES (id_player_input, id_sala_input);
        END IF;
    ELSE
        RAISE EXCEPTION 'Sala com id_sala % não encontrada.', id_sala_input;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_salas_conectadas(id_player_input INT)
RETURNS TABLE(id_sala INT, nome VARCHAR) AS $$
BEGIN
    RETURN QUERY
    WITH salas_conectadas AS (
        SELECT
            unnest(ARRAY[s.id_sala_norte, s.id_sala_sul, s.id_sala_leste, s.id_sala_oeste]) AS id_sala_direcao
        FROM public.sala s
        WHERE s.id_sala = (
            SELECT p.id_sala
            FROM public.party p
            WHERE p.id_player = id_player_input
            LIMIT 1
        )
    )
    SELECT
        s.id_sala, s.nome
    FROM salas_conectadas sc
    JOIN public.sala s ON sc.id_sala_direcao = s.id_sala
    WHERE sc.id_sala_direcao IS NOT NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.get_player_info(player_id integer)
RETURNS text
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN (
        SELECT STRING_AGG(
            FORMAT(
                'Nome: %s %sNível: %s%sXP Acumulado: %s%sHP Máximo: %s%sMagia Máxima: %s%sHP Atual: %s%sMagia Atual: %s%sVelocidade: %s%sAtaque Físico Base: %s%sAtaque Mágico Base: %s%sElemento: %s',
                p.nome, E'\n',
                p.nivel, E'\n',
                p.xp_acumulado, E'\n',
                p.hp_max, E'\n',
                p.magia_max, E'\n',
                p.hp_atual, E'\n',
                p.magia_atual, E'\n',
                p.velocidade, E'\n',
                p.ataque_fisico_base, E'\n',
                p.ataque_magico_base, E'\n',
                e.nome
            ),
            E'\n'  -- Delimitador entre os registros (caso haja mais de um)
        )
        FROM player p
        INNER JOIN elemento e ON e.id_elemento = p.id_elemento
        WHERE p.id_player = player_id
    );
END;
$function$;


CREATE OR REPLACE FUNCTION listar_jogadores_formatados()
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT STRING_AGG(
            FORMAT(
                'Nome: %s Nível: %s Elemento: %s ',
                p.nome,
                p.nivel,
                e.nome
            ),
            E'\n'  -- Delimitador entre as entradas
        )
        FROM 
            player p
        INNER JOIN 
            elemento e ON e.id_elemento = p.id_elemento
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_sala_atual(id_player_input INT)
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT STRING_AGG(
            FORMAT('Sala Atual: %s',s.nome),
            '\n'
        )
        FROM sala s
        INNER JOIN party p ON s.id_sala = p.id_sala
        WHERE p.id_player = id_player_input
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_nome_sala(id_sala_input INT)
RETURNS VARCHAR AS $$
BEGIN
    RETURN (
        SELECT s.nome
        FROM sala s
        WHERE s.id_sala = id_sala_input
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;

INSERT INTO Elemento (id_elemento, nome, descricao)
VALUES
  (1, 'Fogo', 'Controla o calor e as chamas, usado frequentemente para atacar com intensidade.'),
  (2, 'Água', 'Flui e adapta-se, frequentemente usada para defesa e restrição de movimentos.'),
  (3, 'Terra', 'Sólido e confiável, usado para defesa e ataques físicos.'),
  (4, 'Vento', 'Rápido e inconstante, usado para movimentação rápida e ataques evasivos.'),
  (5, 'Trovão', 'Poderoso e chocante, usado para ataques elétricos rápidos e devastadores.');


UPDATE Elemento SET fraco_contra = 2, forte_contra = 3 WHERE id_elemento = 1;  -- Fogo fraco contra Água, forte contra Terra
UPDATE Elemento SET fraco_contra = 3, forte_contra = 1 WHERE id_elemento = 2;  -- Água fraca contra Terra, forte contra Fogo
UPDATE Elemento SET fraco_contra = 4, forte_contra = 5 WHERE id_elemento = 3; -- Terra fraca contra Vento, forte contra Trovão
UPDATE Elemento SET fraco_contra = 1, forte_contra = 3 WHERE id_elemento = 4; -- Vento fraco contra Fogo, forte contra Terra
UPDATE Elemento SET fraco_contra = 3, forte_contra = 2 WHERE id_elemento = 5; -- Trovão fraco contra Terra, forte contra Água

INSERT INTO Classe (nome, descricao)
VALUES
  ('Tank', 'O Tank é a muralha inabalável do grupo, projetado para absorver dano e proteger seus aliados. Com armaduras robustas e habilidades de provocação, ele garante que os inimigos mantenham o foco nele, permitindo que o restante do time lute em segurança.'),
  ('DPS', 'O DPS é o principal responsável por causar dano aos inimigos. Seja com ataques rápidos e precisos ou habilidades devastadoras, sua função é derrotar oponentes o mais rápido possível enquanto explora pontos fracos.'),
  ('Healer', 'O Healer é o sustentáculo do grupo, focado em manter os aliados vivos e fortalecidos. Suas habilidades de cura, purificação e suporte fazem dele uma classe essencial para enfrentar longas batalhas e chefes difíceis.');

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
        xp_acumulado,
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

INSERT INTO audios (nome, nome_arquivo, descricao) VALUES
('Tema de Abertura', 'tema_abertura.mp3', 'Música que toca na abertura do jogo.'),
('Tema de Encerramento', 'tema_encerramento.mp3', 'Música que toca ao final do jogo.');

INSERT INTO Consumivel (
    nome, 
    descricao, 
    preco_venda, 
    saude_restaurada, 
    magia_restaurada, 
    saude_maxima, 
    magia_maxima
)
VALUES
-- Poção que recupera vida
('Poção de Vida', 'Recupera 50 pontos de vida.', 100, 50, 0, 0, 0),

-- Poção que aumenta a saúde máxima
('Elixir da Vida', 'Aumenta a saúde máxima em 20 pontos.', 300, 0, 0, 20, 0),

-- Poção que recupera magia
('Poção de Magia', 'Recupera 40 pontos de magia.', 120, 0, 40, 0, 0),

-- Poção que aumenta a magia máxima
('Elixir da Magia', 'Aumenta a magia máxima em 15 pontos.', 350, 0, 0, 0, 15);

INSERT INTO item_a_venda( id_item, preco_compra, nivel_minimo)
VALUES (1,10,1), (2,50,5), (3,10,1), (4,50,5);

-- dps fogo
INSERT INTO Inimigo(id_classe, id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio)
VALUES(2, 1, 'Aspirante a Cavaleiro de Bronze Fogo', 1, 0, 20, 15, 20, 20, 10, 2, 'Você acha que vai se tornar um verdadeiro cavaleiro? HAHAHAHA');

-- healer agua
INSERT INTO Inimigo(id_classe, id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio)
VALUES(3, 2, 'Aspirante a Cavaleiro de Bronze Agua', 1, 0, 10, 30, 15, 10, 2, 10, 'Você acha que vai se tornar um verdadeiro cavaleiro? HAHAHAHA');

-- tank terra
INSERT INTO Inimigo(id_classe, id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio)
VALUES(1, 3, 'Aspirante a Cavaleiro de Bronze Terra', 1, 0, 5, 35, 20, 30, 5, 0, 'Você acha que vai se tornar um verdadeiro cavaleiro? HAHAHAHA');

ALTER TABLE santuario RENAME TO saga;
ALTER TABLE saga RENAME COLUMN id_santuario TO id_saga;
ALTER TABLE saga RENAME COLUMN id_missao_proximo_santuario TO id_missao_proxima_saga;
ALTER TABLE casa RENAME COLUMN id_santuario TO id_saga;
ALTER TABLE Missao ALTER COLUMN nome TYPE VARCHAR USING NULL;

INSERT INTO Saga ( id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
VALUES ( NULL, NULL, 'Saga SafeHouse', 'O início da jornada dos Cavaleiros de Bronze, onde cresceram e descobriram seus destinos.', 1);



INSERT INTO Casa (id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES ( 1, NULL, NULL, 'Casa SafeHouse', 'O lugar onde os
Cavaleiros de Bronze viveram antes de serem enviados para seus treinamentos.', 1);



INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES ( 1, 'Sala Principal SafeHouse', 2, 3, NULL, NULL);

INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES ( 1, 'Sala Das Missões', NULL, 1, NULL, NULL);

INSERT INTO Sala ( id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES ( 1, 'Oficina de Armaduras de Mu', 1, NULL, NULL, NULL);




INSERT INTO public.Sala_Segura (id_sala)
VALUES(1);

INSERT INTO Party (id_player, id_sala) VALUES (1,1); -- REMOVER DEPOIS 
INSERT INTO Party (id_player, id_sala) VALUES (2,1); -- REMOVER DEPOIS

INSERT INTO Saga (id_saga, id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
VALUES (nextval('santuario_id_santuario_seq'::regclass), NULL, NULL, 'Saga Guerra Galáctica', 'Um torneio lendário onde os Cavaleiros de Atena lutam pelo prêmio supremo: a sagrada Armadura de Ouro de Sagitário. Cada batalha testa força, coragem e o poder do Cosmo, enquanto segredos e rivalidades ameaçam a paz no Santuário. O início de uma jornada épica pela proteção da deusa Atena!', 1);

INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (nextval('casa_id_casa_seq'::regclass), 2, NULL, NULL, 'Grécia', 'O lugar onde o cavaleiro de Pegasus conseguiu sua armadura.', 1);


INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (nextval('casa_id_casa_seq'::regclass), 2, NULL, NULL, 'Arena da Guerra Galáctica', 'descricao', 3);

-- salas da casa 1 Grecia

INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 4
VALUES (2, 'Entrada Campo de Treinamento', 5, NULL, NULL, NULL);

INSERT INTO Grupo_inimigo(id_sala)
VALUES(4);

SELECT public.criar_instancia_inimigo(1,1);

INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 5
VALUES (2, 'Campo de Treinamento', 6, 4, 7, 8);

INSERT INTO Grupo_inimigo(id_sala)
VALUES(5);

SELECT public.criar_instancia_inimigo(1,2);
SELECT public.criar_instancia_inimigo(3,2);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 6
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Floresta da Perseverança', 12, 5, NULL, NULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 7
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Gruta do Desafio', NULL, NULL, 10, 5);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 8
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Colina dos Ventos Gelados', NULL, NULL, 5, 9 );

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 9
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Lago Congelado', NULL, NULL, 8, NULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 10
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Templo Abandonado', NULL, 11, NULL, 7);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 11
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena Final', 10, NULL, NULL, NULL); -- boss cassios

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 12
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Templo Sagrado', NULL, 6, NULL, NULL);  -- boss shinra de cobra



-- salas da casa 3 arena galactica

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 13
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Geki', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 14
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Jabu', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 15
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Hyoga', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 16
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Shiryu', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 17
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Shun', NULL, NULL, NULL, NULL);


-- implementar casa dos cavaleiros negros se der tempo

INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Orelha de Cassios', 'A orelha perdida de Cassios, símbolo de sua derrota após um combate feroz.');

INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (NULL, 5, 'Derrote Cassios', 'Cassios, o imponente guerreiro treinado por Shaina, ameaça o equilíbrio do Santuário com sua força bruta.', 'Sua missão é enfrentar Cassios em combate. Cuidado, ele é forte e implacável. Apenas os mais habilidosos sobreviverão.', 'Você derrotou Cassios em um combate épico e adquiriu sua orelha como prova de sua vitória.');


INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Veneno de Cobra', 'Um frasco contendo o veneno letal de Shaina, a Amazona de Prata. Um item raro e perigoso.');


INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (1, 6, 'Derrote Shaina', 'Shaina, a Amazona de Prata, tem causado problemas em nosso território. Ela é perigosa e deve ser detido.', 'Sua missão é enfrentar e derrotar Shaina. Lembre-se, ela é rápido e usa seu veneno para enfraquecer seus inimigos.', 'Parabéns! Você derrotou Shaina e adquiriu seu mortal Veneno de Cobra. Sua bravura será lembrada.');


INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao) 
VALUES (12, 5, 'Shaina de Cobra', 1, 150, 100, 100, 100, 100, 100, 100, 100, 30, 'Você ousa desafiar uma Amazona de Prata? Sentirá o poder do veneno da Cobra!', 'Eu avisei... sua força é insignificante contra o meu veneno mortal!', 'Impossível! Como um cavaleiro tão inferior conseguiu me derrotar?!', 'Se deseja sair vivo, mostre que é digno e enfrente-me com coragem!');



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

INSERT INTO public.npc_ferreiro( id_sala, id_missao_desbloqueia, nome, descricao, dialogo_inicial, dialogo_reparar, dialogo_upgrade)
VALUES(3, 1, 'Mu de Áries', 'O principal reparador de armaduras no universo de Cavaleiros do Zodíaco, Mu é a escolha perfeita para ser o ferreiro.', 'Bem-vindo, Cavaleiro. As armaduras são a essência de sua força. O que você busca hoje?', 'Esta armadura sofreu bastante em combate... Deixe-me restaurá-la ao seu estado original. Um Cavaleiro deve proteger seu espírito.', 'Com as ferramentas certas e seu cosmos, posso reforçar sua armadura. Prepare-se para suportar um poder ainda maior!');
    
INSERT INTO public.npc_mercador( id_sala, nome, descricao, dialogo_inicial, dialogo_vender, dialogo_comprar, dialogo_sair)
VALUES(1, 'Jabu de Unicórnio', 'Jabu é um Cavaleiro prático e secundário, sempre disposto a ajudar. Ele se encaixa perfeitamente como um mercador de itens básicos e úteis.', 'Ei, Cavaleiro! Precisa de algo para sua próxima batalha? Tenho exatamente o que você precisa... e por um preço justo, é claro.', 'Tenho alguns itens úteis para você. Dê uma olhada no que está disponível!', 'Você está comprando algo? Vamos negociar o preço.', 'Volte sempre que precisar de algo. Até mais, Cavaleiro!');

INSERT INTO public.npc_quest( id_sala, nome, descricao, dialogo_inicial, dialogo_recusa)
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
        WHEN EXISTS (SELECT 1 FROM npc_ferreiro WHERE id_sala = id_sala_atual) THEN 'Ferreiro'
        WHEN EXISTS (SELECT 1 FROM npc_quest WHERE id_sala = id_sala_atual) THEN 'Missao'
        WHEN EXISTS (SELECT 1 FROM npc_mercador WHERE id_sala = id_sala_atual) THEN 'Mercador'
        ELSE NULL
    END
    INTO tipo_npc;

    RETURN tipo_npc;
END;
$$ LANGUAGE plpgsql;

```

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 11/12/2024 | Criação do Documento | Vinícius Rufino |
| 1.0 | 11/12/2024 | Finalização do documento | [Lucas Avelar](https://github.com/LucasAvelar2711) |
|  1.1 | 29/01/2025 | Melhoria do DML | Lucas Dourado |
|  2.0 | 02/02/2025 | Atualização do Documento | Vinícius Rufino |
|  2.1 | 03/02/2025 | Atualização do DML | Vinícius Rufino |