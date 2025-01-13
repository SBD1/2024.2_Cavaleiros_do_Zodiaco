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

