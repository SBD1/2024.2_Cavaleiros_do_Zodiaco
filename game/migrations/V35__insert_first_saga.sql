ALTER TABLE santuario RENAME TO saga;


INSERT INTO Saga (id_saga, id_missao_requisito, id_missao_pro
xima_saga, nome, descricao, nivel_recomendado)
VALUES (1, NULL, NULL, 'Saga SafeHouse', 'O início da jornada do
s Cavaleiros de Bronze, onde cresceram e descobriram seus des
tinos.', 1);



INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_m
issao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (1, 1, NULL, NULL, 'Casa SafeHouse', 'O lugar onde os
Cavaleiros de Bronze viveram antes de serem enviados para seu
s treinamentos.', 1);



INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (1, 1, 'Sala Principal SafeHouse', 2, 3, NULL, N
ULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (2, 1, 'Sala Das Missões', NULL, 1, NULL, NULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (3, 1, 'Oficina de Armaduras de Mu', 1, NULL, NULL, N
ULL);

INSERT INTO Saga (id_saga, id_missao_requisito, id_missao_pro
xima_saga, nome, descricao, nivel_recomendado)
VALUES (2, NULL, NULL, 'Saga das 12 Casas', 'Os Cavaleiros de Br
onze enfrentam os Cavaleiros de Ouro para salvar Atena.', 1);

INSERT INTO public.missao
(id_missao, id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa)
VALUES(nextval('missao_id_missao_seq'::regclass), 0, 0, 0, '', '', '');

INSERT INTO public.missao
(id_missao, id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa)
VALUES(nextval('missao_id_missao_seq'::regclass), 0, 0, 0, '', '', '');

INSERT INTO public.item_missao
(id_item, nome, descricao)
VALUES(0, '', '');



INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_m
issao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (2, 2, NULL, 1, 'Casa Áries', 'A casa protegida por M
u, o Cavaleiro de Áries, que repara as armaduras dos Cavaleir
os de Bronze.', 1);



INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (1, 1, 'Sala de Entrada de Áries', 2, 3, NULL, NULL);


INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (2, 1, 'Covil Dos Anões', NULL, 1, 3, NUL
L);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (3, 1, 'Sala da Meditação Cósmica de Áries', NULL, NUL
L, 1, 2);



INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_m
issao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (2, 1, 1, 3, 'Casa de Touro', 'A casa protegida por Al
debaran, que desafia os Cavaleiros de Bronze com sua força in
igualável.', 10);



INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (2, 2, 'Sala do Duelo de Touro', NULL, 3, NULL, 2);
INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (3, 2, 'Galeria de Tatuagens do Zodíaco', 3, NULL, 1,
NULL);

INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (4, 2, 'Salão da Força de Aldebaran', 1, 2, NULL, NUL
L);



INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_m
issao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (3, 1, 2, 4, 'Casa de Gêmeos', 'Uma casa cheia de ilus
ões, protegida pelo enigmático Saga.', 15);



INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (3, 3, 'Labirinto de Ilusões de Gêmeos', 4, NULL, NUL
L, 5);
INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (4, 3, 'Espelho das Ilusões de Gêmeos', NULL, 3, 5, NU
LL);
INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (5, 3, 'Corredor da Realidade Invertida', 4, NULL, 3,
NULL);



INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_m
issao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (4, 1, 3, 5, 'Casa de Câncer', 'A casa protegida pelo
Cavaleiro Máscara da Morte, cheia de almas perdidas.', 20);



INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (4, 4, 'Sala das Almas Perdidas de Câncer', NULL, 5,
6, NULL);
INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (5, 4, 'Sala do Rio Estige', 4, NULL, 6, NULL);
INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_s
ala_sul, id_sala_leste, id_sala_oeste)
VALUES (6, 4, 'Galeria das Máscaras de Câncer', NULL, 4, NUL
L, 5);


