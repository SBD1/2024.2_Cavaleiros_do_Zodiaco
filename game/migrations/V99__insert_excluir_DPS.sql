INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Orelha de Cassios', 'A orelha perdida de Cassios, símbolo de sua derrota após um combate feroz.');

INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (NULL, 5, 'Derrote Cassios', 'Cassios, o imponente guerreiro treinado por Shaina, ameaça o equilíbrio do Santuário com sua força bruta.', 'Sua missão é enfrentar Cassios em combate. Cuidado, ele é forte e implacável. Apenas os mais habilidosos sobreviverão.', 'Você derrotou Cassios em um combate épico e adquiriu sua orelha como prova de sua vitória.');

INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao) 
VALUES (11, 5, 'Cassios', 2, 300, 200, 200, 50, 50, 60, 150, 30, 50, 'Você ousa desafiar Cassios, o campeão da força bruta? Prepare-se para ser esmagado!', 'Você é fraco demais para me enfrentar. Nem deveria ter tentado.', 'Impossível! Como um guerreiro tão insignificante conseguiu superar minha força bruta?', 'Se tem coragem para me enfrentar, venha com tudo ou será destruído!');


INSERT INTO public.item_missao (nome, descricao) 
VALUES ('Veneno de Cobra', 'Um frasco contendo o veneno letal de Shaina, a Amazona de Prata. Um item raro e perigoso.');


INSERT INTO public.missao (id_missao_anterior, item_necessario, nome, dialogo_inicial, dialogo_durante, dialogo_completa) 
VALUES (1, 6, 'Derrote Shaina', 'Shaina, a Amazona de Prata, tem causado problemas em nosso território. Ela é perigosa e deve ser detido.', 'Sua missão é enfrentar e derrotar Shaina. Lembre-se, ela é rápido e usa seu veneno para enfraquecer seus inimigos.', 'Parabéns! Você derrotou Shaina e adquiriu seu mortal Veneno de Cobra. Sua bravura será lembrada.');


INSERT INTO public.boss (id_sala, id_item_missao, nome, nivel, xp_acumulado, hp_max, hp_atual, magia_max, magia_atual, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio, fala_derrotar_player, fala_derrotado, fala_condicao) 
VALUES (12, 6, 'Shaina de Cobra', 1, 150, 100, 100, 100, 100, 100, 100, 100, 30, 'Você ousa desafiar uma Amazona de Prata? Sentirá o poder do veneno da Cobra!', 'Eu avisei... sua força é insignificante contra o meu veneno mortal!', 'Impossível! Como um cavaleiro tão inferior conseguiu me derrotar?!', 'Se deseja sair vivo, mostre que é digno e enfrente-me com coragem!');



