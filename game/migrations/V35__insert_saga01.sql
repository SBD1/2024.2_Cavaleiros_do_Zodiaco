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


INSERT INTO public.tipo_item (id_item, tipo_item)
VALUES(1, 'i');


