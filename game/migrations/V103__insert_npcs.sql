-- trocar o id da missao pra desbloquear MU
INSERT INTO public.npc_ferreiro( id_sala, id_missao_desbloqueia, nome, descricao, dialogo_inicial, dialogo_reparar, dialogo_upgrade)
VALUES(3, 1, 'Mu de Áries', 'O principal reparador de armaduras no universo de Cavaleiros do Zodíaco, Mu é a escolha perfeita para ser o ferreiro.', 'Bem-vindo, Cavaleiro. As armaduras são a essência de sua força. O que você busca hoje?', 'Esta armadura sofreu bastante em combate... Deixe-me restaurá-la ao seu estado original. Um Cavaleiro deve proteger seu espírito.', 'Com as ferramentas certas e seu cosmos, posso reforçar sua armadura. Prepare-se para suportar um poder ainda maior!');
    
INSERT INTO public.npc_mercador( id_sala, nome, descricao, dialogo_inicial, dialogo_vender, dialogo_comprar, dialogo_sair)
VALUES(1, 'Jabu de Unicórnio', 'Jabu é um Cavaleiro prático e secundário, sempre disposto a ajudar. Ele se encaixa perfeitamente como um mercador de itens básicos e úteis.', 'Ah, Cavaleiro, chegou na hora certa! Estou com itens que podem ser exatamente o que você procura, e se tiver algo para vender, vamos negociar – nada escapa do meu faro para bons negócios!', 'Então, Cavaleiro, o que você tem para me oferecer? Estou sempre em busca de algo útil... mas espero que seja algo que valha o meu tempo.', 'Você está comprando algo? Vamos negociar o preço.', 'Volte sempre que precisar de algo. Até mais, Cavaleiro!');

INSERT INTO public.npc_quest( id_sala, nome, descricao, dialogo_inicial, dialogo_recusa)
VALUES(2, 'Saori Kido', 'A deusa Athena, protetora da Terra, é uma guia espiritual e estratégica para os Cavaleiros do Zodíaco, sempre fornecendo missões importantes.', 'Cavaleiro, sua coragem e lealdade são indispensáveis. A batalha que se aproxima será decisiva. Posso contar com você?', 'Eu entendo que você não está pronto no momento. Mas lembre-se, o mundo depende de nós. Volte quando estiver preparado.');

CREATE OR REPLACE FUNCTION verificar_npc_na_sala(id_jogador INTEGER)
RETURNS TEXT AS $$
DECLARE
    id_sala_atual INTEGER;
    tipo_npc TEXT;
BEGIN
    SELECT id_sala
    INTO id_sala_atual
    FROM Party pa join Player pl
    ON pl.id_player = pa.id_player
    WHERE pl.id_player = id_jogador;

    SELECT CASE
        WHEN EXISTS (SELECT 1 FROM npc_ferreiro WHERE id_sala = id_sala_atual) THEN 'Ferreiro'
        WHEN EXISTS (SELECT 1 FROM npc_quest WHERE id_sala = id_sala_atual) THEN 'Missao'
        WHEN EXISTS (SELECT 1 FROM npc_mercador WHERE id_sala = id_sala_atual) THEN 'Mercador'
        ELSE NULL
    END
    INTO tipo_npc;

    RETURN tipo_npc;
END;
$$ LANGUAGE plpgsql;
