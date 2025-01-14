## DML

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 11/12/2023 | Criação do Documento | Vinícius Rufino |
| 1.0 | 11/12/2023 | Finalização do documento | [Lucas Avelar](https://github.com/LucasAvelar2711) |

```sql
ALTER TABLE santuario RENAME TO saga;
ALTER TABLE saga RENAME COLUMN id_santuario TO id_saga;
ALTER TABLE saga RENAME COLUMN id_missao_proximo_santuario TO id_missao_proxima_saga;
ALTER TABLE casa RENAME COLUMN id_santuario TO id_saga;
ALTER TABLE Missao ALTER COLUMN nome TYPE VARCHAR USING NULL;

INSERT INTO Saga (id_saga, id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
VALUES (1, NULL, NULL, 'Saga SafeHouse', 'O início da jornada dos Cavaleiros de Bronze, onde cresceram e descobriram seus destinos.', 1);



INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (1, 1, NULL, NULL, 'Casa SafeHouse', 'O lugar onde os
Cavaleiros de Bronze viveram antes de serem enviados para seus treinamentos.', 1);



INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (1, 1, 'Sala Principal SafeHouse', 2, 3, NULL, NULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (2, 1, 'Sala Das Missões', NULL, 1, NULL, NULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
VALUES (3, 1, 'Oficina de Armaduras de Mu', 1, NULL, NULL, NULL);

INSERT INTO Saga (id_saga, id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
VALUES (2, NULL, NULL, 'Saga das 12 Casas', 'Os Cavaleiros de Bronze enfrentam os Cavaleiros de Ouro para salvar Atena.', 1);

ALTER TABLE Tipo_Item ALTER COLUMN tipo_item TYPE enum_tipo_item USING NULL;

INSERT INTO public.tipo_item (id_item, tipo_item)
VALUES(1, 'i');

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

INSERT INTO party (id_player, id_sala)
VALUES(1, 1);

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

```