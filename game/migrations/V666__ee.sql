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

