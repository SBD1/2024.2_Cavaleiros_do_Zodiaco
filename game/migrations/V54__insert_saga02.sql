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

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 13
VALUES ( nextval('sala_id_sala_seq'::regclass), 3, 'Arena de batalha Geki', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 14
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Jabu', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 15
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Hyoga', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 16
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Shiryu', NULL, NULL, NULL, NULL);

-- INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) -- id 17
-- VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena de batalha Shun', NULL, NULL, NULL, NULL);


-- implementar casa dos cavaleiros negros se der tempo

