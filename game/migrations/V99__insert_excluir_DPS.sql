INSERT INTO public.item_missao
(nome, descricao)
VALUES('Veneno de Cobra', 'Veneno da Boss Shinra');

INSERT INTO public.missao
(id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa)
VALUES(NULL, 5, 'Derrote Shinra', 'Shinra está causando problemas', 'Sua missão é derrotar Shinrra', 'Você derrotou shinra e adquiriu seu veneno de cobra');

INSERT INTO public.boss
( id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao)
VALUES ( 12, 5, 'Shinra de cobra', 1, 150, 100, 100, 100, 100, 100, 100, 100, 30, 'Toma veneno', 'fras2', 'frase3', 'frase4');
