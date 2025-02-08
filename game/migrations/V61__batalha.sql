-- CREATE OR REPLACE FUNCTION player_ataca_inimigo(
--     p_id_player INT,
--     p_id_instancia_inimigo INT,
--     p_parte_corpo enum_parte_corpo
-- ) RETURNS TABLE(mensagem TEXT) AS $$
-- DECLARE
--     v_nome_player TEXT;
--     v_nome_inimigo TEXT;
--     v_ataque_fisico INT;
--     v_defesa_fisica INT;
--     v_hp_atual_antes INT;
--     v_hp_atual_depois INT;
--     v_dano INT;
--     v_parte_corpo_extenso TEXT;
-- BEGIN
--     SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
--     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
--     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
--     WHERE ii.id_instancia = p_id_instancia_inimigo;

--     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM player WHERE id_player = p_id_player;
--     SELECT pci.defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo pci
--     WHERE pci.id_instancia = p_id_instancia_inimigo AND pci.parte_corpo = p_parte_corpo;

--     SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

--     v_parte_corpo_extenso := CASE 
--         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
--         WHEN p_parte_corpo = 't' THEN 'Tronco'
--         WHEN p_parte_corpo = 'b' THEN 'Braços'
--         WHEN p_parte_corpo = 'p' THEN 'Pernas'
--         ELSE 'Desconhecido' 
--     END;

--     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
--         RETURN QUERY SELECT 'Erro: Player ou inimigo não encontrado!'::TEXT;
--     END IF;

--     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

--     UPDATE instancia_inimigo 
--     SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
--     WHERE id_instancia = p_id_instancia_inimigo;

--     SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

--     RETURN QUERY SELECT format(
--         '🗡️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
--         v_nome_player, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
--     );
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION cavaleiro_ataca_inimigo(
--     p_id_instancia_inimigo INT,
--     p_parte_corpo enum_parte_corpo
-- ) RETURNS TABLE(mensagem TEXT) AS $$
-- DECLARE
--     v_nome_cavaleiro TEXT;
--     v_nome_inimigo TEXT;
--     v_ataque_fisico INT;
--     v_defesa_fisica INT;
--     v_hp_atual_antes INT;
--     v_hp_atual_depois INT;
--     v_dano INT;
--     v_parte_corpo_extenso TEXT;
-- BEGIN
--     SELECT c.nome INTO v_nome_cavaleiro FROM instancia_cavaleiro ic 
--     INNER JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro

--     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
--     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
--     WHERE ii.id_instancia = p_id_instancia_inimigo;

--     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM instancia_cavaleiro 

--     SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo 
--     WHERE id_instancia = p_id_instancia_inimigo AND parte_corpo = p_parte_corpo;

--     SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

--     v_parte_corpo_extenso := CASE 
--         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
--         WHEN p_parte_corpo = 't' THEN 'Tronco'
--         WHEN p_parte_corpo = 'b' THEN 'Braços'
--         WHEN p_parte_corpo = 'p' THEN 'Pernas'
--         ELSE 'Desconhecido' 
--     END;

--     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
--         RETURN QUERY SELECT 'Erro: Cavaleiro ou inimigo não encontrado!'::TEXT;
--     END IF;

--     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

--     UPDATE instancia_inimigo 
--     SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
--     WHERE id_instancia = p_id_instancia_inimigo;

--     SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

--     RETURN QUERY SELECT format(
--         '⚔️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
--         v_nome_cavaleiro, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
--     );
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION inimigo_ataca_player(
--     p_id_instancia_inimigo INT,
--     p_id_player INT,
--     p_parte_corpo enum_parte_corpo
-- ) RETURNS TABLE(mensagem TEXT) AS $$
-- DECLARE
--     v_nome_inimigo TEXT;
--     v_nome_player TEXT;
--     v_ataque_fisico INT;
--     v_defesa_fisica INT;
--     v_hp_atual_antes INT;
--     v_hp_atual_depois INT;
--     v_dano INT;
--     v_parte_corpo_extenso TEXT;
-- BEGIN
--     SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
--     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
--     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
--     WHERE ii.id_instancia = p_id_instancia_inimigo;

--     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM instancia_inimigo ii
--     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
--     WHERE ii.id_instancia = p_id_instancia_inimigo;


--     SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_player 

--     WHERE id_player = p_id_player AND parte_corpo = p_parte_corpo;

--     SELECT hp_atual INTO v_hp_atual_antes FROM player WHERE id_player = p_id_player;

--     v_parte_corpo_extenso := CASE 
--         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
--         WHEN p_parte_corpo = 't' THEN 'Tronco'
--         WHEN p_parte_corpo = 'b' THEN 'Braços'
--         WHEN p_parte_corpo = 'p' THEN 'Pernas'
--         ELSE 'Desconhecido' 
--     END;

--     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
--         RETURN QUERY SELECT 'Erro: Inimigo ou player não encontrado!'::TEXT;
--     END IF;

--     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

--     UPDATE player SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
--     WHERE id_player = p_id_player;

--     SELECT hp_atual INTO v_hp_atual_depois FROM player WHERE id_player = p_id_player;

--     RETURN QUERY SELECT format(
--         '🔥 %s atacou %s na %s, causando %s de dano. HP: %s → %s',
--         v_nome_inimigo, v_nome_player, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
--     );
-- END;
-- $$ LANGUAGE plpgsql;

-- TA COMENTADO POIS IA TER Q MEXER NA LOGICA INTEIRA 

-- CREATE OR REPLACE FUNCTION inimigo_ataca_cavaleiro(
--     p_id_instancia_inimigo INT,
--     p_parte_corpo enum_parte_corpo
-- ) RETURNS TABLE(mensagem TEXT) AS $$
-- DECLARE
--     v_ataque_fisico INT;
--     v_defesa_fisica INT;
--     v_hp_atual INT;
--     v_dano INT;
-- BEGIN
--     -- Obtém o ataque físico do inimigo
--     SELECT i.ataque_fisico INTO v_ataque_fisico
--     FROM instancia_inimigo ii
--     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
--     WHERE ii.id_instancia = p_id_instancia_inimigo;

--     -- Obtém a defesa da parte do corpo do cavaleiro
--     SELECT pcc.defesa_fisica INTO v_defesa_fisica
--     FROM parte_corpo_cavaleiro pcc
--     INNER JOIN instancia_cavaleiro ic 
--         ON ic.id_instancia_cavaleiro = pcc.id_instancia_cavaleiro
--     WHERE pcc.id_instancia_cavaleiro = p_id_instancia_cavaleiro
--         AND pcc.parte_corpo = p_parte_corpo;

--     -- Se ataque ou defesa não forem encontrados, retorna erro
--     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
--         RETURN QUERY SELECT 'Erro: Inimigo ou cavaleiro não encontrado!'::TEXT;
--     END IF;

--     -- Calcula o dano causado
--     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0); -- Garante que o dano não seja negativo

--     -- Atualiza o HP do cavaleiro
--     UPDATE instancia_cavaleiro
--     SET hp_atual = GREATEST(hp_atual - v_dano, 0) -- Garante que o HP não seja negativo
--     WHERE id_instancia_cavaleiro = p_id_instancia_cavaleiro;

--     -- Obtém o novo HP do cavaleiro
--     SELECT hp_atual INTO v_hp_atual
--     FROM instancia_cavaleiro
--     WHERE id_instancia_cavaleiro = p_id_instancia_cavaleiro;

--     -- Retorna a mensagem do ataque
--     RETURN QUERY SELECT format(
--         '💀 Inimigo %s atacou o Cavaleiro %s na parte %s, causando %s de dano. HP Atual do Cavaleiro: %s',
--         p_id_instancia_inimigo, p_id_instancia_cavaleiro, p_parte_corpo, v_dano, v_hp_atual
--     );
-- END;
-- $$ LANGUAGE plpgsql;

create or replace view info_batalha as		 
select 
	c.nome,
	c.id_elemento,
	c.nivel,
	c.hp_max ,
	ic.hp_atual,
	c.magia_max ,
	ic.magia_atual,
	ic.velocidade,
	ic.ataque_fisico ,
	ic.ataque_magico ,
	pcc.defesa_magica ,
	pcc.defesa_fisica ,
	pcc.parte_corpo ,
	p.id_player, -- 
	'c' as tipo_personagem,
	ic.id_cavaleiro as id
	from 
	party p
inner join instancia_cavaleiro ic on
	ic.id_player = p.id_player
inner join cavaleiro c on
	c.id_cavaleiro = ic.id_cavaleiro
inner join parte_corpo_cavaleiro pcc 
on
	pcc.id_cavaleiro = ic.id_cavaleiro
union all
select
	   inim.nome,
	   inim.id_elemento,
	   inim.nivel ,
	   inim.hp_max,
	   ii.hp_atual ,
	   inim.magia_max,
	   ii.magia_atual,
	   ii.velocidade,
	   ii.ataque_fisico,
	   ii.ataque_magico,
	   ii.defesa_magica ,
	   ii.defesa_fisica ,
	   pci.parte_corpo ,
	   p.id_player, -- id_player que ta batalhando
	   'i' as tipo_personagem,
	   ii.id_instancia as id
from
	grupo_inimigo gi
inner join instancia_inimigo ii 
		 on
	ii.id_grupo = gi.id_grupo
inner join inimigo inim
		 on
	ii.id_inimigo = inim.id_inimigo
inner join party p 
		 on
	p.id_sala = gi.id_sala
inner join parte_corpo_inimigo pci 
		 on
	pci.id_inimigo = ii.id_inimigo
	and pci.id_instancia = ii.id_instancia
union all
select
	p.nome,
	p.id_elemento,
	p.nivel,
	p.hp_max,
	p.hp_atual,
	p.magia_max,
	p.magia_atual,
	p.velocidade,
	p.ataque_fisico + aev.ataque_fisico as ataque_fisico_armadura,
	p.ataque_magico + aev.ataque_magico as ataque_magico_armadura,
	pcp.defesa_magica + aev.defesa_magica as defesa_magica,
	aev.defesa_fisica + pcp.defesa_fisica as defesa_fisica,
	aev.durabilidade_atual,
	pcp.parte_corpo,
	p.id_player, 
	'p' as tipo_personagem,
	p.id_player as id -- repeti essa coluna pois preciso que union traga colunas iguais
from
	player p
inner join armadura_equipada ae 
on
	ae.id_player = p.id_player
inner join armadura_equipada_view aev
on
	aev.id_inventario = p.id_player
inner join parte_corpo_player pcp 
on
	pcp.id_player = p.id_player
	and pcp.parte_corpo = aev.id_parte_corpo_armadura;

CREATE OR REPLACE VIEW fila AS
WITH min_speed AS (
  SELECT MIN(velocidade) AS min_vel FROM info_batalha
),
ataques AS (
  SELECT 
    i.id,
    i.tipo_personagem,
    i.velocidade,
    (i.velocidade / m.min_vel)::int AS num_attacks
  FROM info_batalha i
  CROSS JOIN min_speed m
),
rounds AS (
  SELECT 
    a.id,
    a.tipo_personagem,
    a.velocidade,
    gs AS round_num
  FROM ataques a
  CROSS JOIN LATERAL generate_series(1, a.num_attacks) AS gs(round_num)
)
SELECT id, tipo_personagem
FROM rounds
ORDER BY round_num, velocidade DESC;

-- como 
-- como usar a view fila, voce filtro pelo id_player como where id_player = 'id do player que tá batalhando"


-- select * from info_batalha where player_id = 1