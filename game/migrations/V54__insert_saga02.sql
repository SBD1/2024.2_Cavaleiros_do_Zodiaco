INSERT INTO Saga ( id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
VALUES ( NULL, NULL, 'Saga Guerra Galáctica', 'Um torneio lendário onde os Cavaleiros de Atena lutam pelo prêmio supremo: a sagrada Armadura de Ouro de Sagitário. Cada batalha testa força, coragem e o poder do Cosmo, enquanto segredos e rivalidades ameaçam a paz no Santuário. O início de uma jornada épica pela proteção da deusa Atena!', 1);

INSERT INTO Casa ( id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES ( 2, NULL, NULL, 'Grécia', 'O lugar onde o cavaleiro de Pegasus conseguiu sua armadura.', 1);


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

-- id sala 11 boss cassios
INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) 
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Arena Final', 10, NULL, NULL, NULL); 

INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Orelha de Cassios', 'A orelha perdida de Cassios, símbolo de sua derrota após um combate feroz.');

INSERT INTO public.cavaleiro (id_classe, id_elemento, nome, nivel, hp_max, magia_max, velocidade_base, ataque_fisico_base, ataque_magico_base)
VALUES( 2, 3, 'Seiya de Pégaso', 3, 100, 50, 70, 25, 25);

INSERT INTO public.missao (id_missao_anterior, item_necessario, id_cavaleiro_desbloqueado, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (NULL, 5, currval('cavaleiro_id_cavaleiro_seq'), 'Derrote Cassios', 'Cassios, o imponente guerreiro treinado por Shaina, ameaça o equilíbrio do Santuário com sua força bruta.', 'Sua missão é enfrentar Cassios em combate. Cuidado, ele é forte e implacável. Apenas os mais habilidosos sobreviverão.', 'Você derrotou Cassios em um combate épico e adquiriu sua orelha como prova de sua vitória.');

INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao) 
VALUES (11, 5, 'Cassios', 2, 300, 200, 200, 50, 50, 60, 150, 30, 50, 'Você ousa desafiar Cassios, o campeão da força bruta? Prepare-se para ser esmagado!', 'Você é fraco demais para me enfrentar. Nem deveria ter tentado.', 'Impossível! Como um guerreiro tão insignificante conseguiu superar minha força bruta?', 'Se tem coragem para me enfrentar, venha com tudo ou será destruído!');







-- id sala 12 boss shaina de cobra
INSERT INTO Sala (id_sala, id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste) 
VALUES ( nextval('sala_id_sala_seq'::regclass), 2, 'Templo Sagrado', NULL, 6, NULL, NULL);  



INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Veneno de Cobra', 'Um frasco contendo o veneno letal de Shaina, a Amazona de Prata. Um item raro e perigoso.');


INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (1, 6, 'Derrote Shaina', 'Shaina, a Amazona de Prata, tem causado problemas em nosso território. Ela é perigosa e deve ser detido.', 'Sua missão é enfrentar e derrotar Shaina. Lembre-se, ela é rápido e usa seu veneno para enfraquecer seus inimigos.', 'Parabéns! Você derrotou Shaina e adquiriu seu mortal Veneno de Cobra. Sua bravura será lembrada.');


INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao) 
VALUES (12, 6, 'Shaina de Cobra', 1, 150, 100, 100, 100, 100, 100, 100, 100, 30, 'Você ousa desafiar uma Amazona de Prata? Sentirá o poder do veneno da Cobra!', 'Eu avisei... sua força é insignificante contra o meu veneno mortal!', 'Impossível! Como um cavaleiro tão inferior conseguiu me derrotar?!', 'Se deseja sair vivo, mostre que é digno e enfrente-me com coragem!');



-- salas da casa 3 arena galactica
INSERT INTO Casa (id_casa, id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
VALUES (nextval('casa_id_casa_seq'::regclass), 2, 2, NULL, 'Arena da Guerra Galáctica', 'descricao', 3);

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

