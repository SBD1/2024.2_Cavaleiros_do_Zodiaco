INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Orelha de Cassios', 'A orelha perdida de Cassios, símbolo de sua derrota após um combate feroz.');

INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (NULL, 5, 'Derrote Cassios', 'Cassios, o imponente guerreiro treinado por Shaina, ameaça o equilíbrio do Santuário com sua força bruta.', 'Sua missão é enfrentar Cassios em combate. Cuidado, ele é forte e implacável. Apenas os mais habilidosos sobreviverão.', 'Você derrotou Cassios em um combate épico e adquiriu sua orelha como prova de sua vitória.');


INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Veneno de Cobra', 'Um frasco contendo o veneno letal de Shinra, a Amazona de Prata. Um item raro e perigoso.');


INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (1, 6, 'Derrote Shinra', 'Shinra, a Amazona de Prata, tem causado problemas em nosso território. Ela é perigosa e deve ser detido.', 'Sua missão é enfrentar e derrotar Shinra. Lembre-se, ela é rápido e usa seu veneno para enfraquecer seus inimigos.', 'Parabéns! Você derrotou Shinra e adquiriu seu mortal Veneno de Cobra. Sua bravura será lembrada.');


INSERT INTO public.boss
( id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao)
VALUES ( 12, 5, 'Shinra de cobra', 1, 150, 100, 100, 100, 100, 100, 100, 100, 30, 'Toma veneno', 'fras2', 'frase3', 'frase4');


