CREATE OR REPLACE FUNCTION calcular_dano(
    atacante_ataque INT,
    defensor_defesa INT,
    critico_chance FLOAT,
    atacante_elemento INT,
    defensor_elemento INT
) RETURNS INT AS $$
DECLARE
    dano INT;
    critico BOOLEAN;
    vantagem BOOLEAN;
    fraqueza BOOLEAN;
BEGIN
    -- Verifica se foi crítico
    critico := (random() <= critico_chance);

    -- Verifica vantagem de elemento
    SELECT COUNT(*)
    INTO vantagem
    FROM elemento e
    WHERE e.id_elemento = atacante_elemento
      AND e.forte_contra = defensor_elemento;

   -- Verifica fraqueza de elemento
    SELECT COUNT(*)
    INTO vantagem
    FROM elemento e
    WHERE e.id_elemento = atacante_elemento
      AND e.fraco_contra = defensor_elemento;

    -- Calcula o dano base
    dano := atacante_ataque - defensor_defesa;

    -- Aplica multiplicador para dano crítico
    IF critico THEN
        dano := dano * 1.5; -- Multiplica por 1.5 se for crítico
    END IF;

    -- Aplica multiplicador para vantagem de elementos
    IF vantagem THEN
        dano := dano * 1.25; -- Multiplica por 1.25 para vantagem de elementos
    END IF;

    IF fraqueza THEN
        dano := dano * 0.75; -- Multiplica por 0.75 para desvantagem 
    END IF;

    -- Garante que o dano não seja negativo
    RETURN GREATEST(dano, 0);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE VIEW info_batalha AS
-- Informações do Player
SELECT
    p.id_player AS id,
    'player' AS tipo_personagem,
    p.player_velocidade AS velocidade,
    p.player_hp_atual AS hp_atual,
    p.player_hp_max AS hp_max,
    p.player_magia_atual AS magia_atual,
    p.player_magia_max AS magia_max,
    p.ataque_fisico_total AS ataque_fisico, -- Usa o total já calculado
    p.ataque_magico_total AS ataque_magico  -- Usa o total já calculado
FROM
    player_info_view p

UNION ALL

-- Informações dos Cavaleiros na Party
SELECT
    pcv.id_cavaleiro AS id,
    'cavaleiro' AS tipo_personagem,
    pcv.cavaleiro_velocidade AS velocidade,
    pcv.cavaleiro_hp_atual AS hp_atual,
    pcv.cavaleiro_hp_max AS hp_max,
    pcv.cavaleiro_magia_atual AS magia_atual,
    pcv.cavaleiro_magia_max AS magia_max,
    pcv.cavaleiro_ataque_fisico AS ataque_fisico,
    pcv.cavaleiro_ataque_magico AS ataque_magico
FROM
    party_cavaleiros_view pcv

UNION ALL

-- Informações do Boss
SELECT
    b.id_boss AS id,
    'boss' AS tipo_personagem,
    b.boss_velocidade AS velocidade,
    b.boss_hp_atual AS hp_atual,
    b.boss_hp_max AS hp_max,
    b.boss_magia_atual AS magia_atual,
    b.boss_magia_max AS magia_max,
    b.boss_ataque_fisico AS ataque_fisico,
    b.boss_ataque_magico AS ataque_magico
FROM
    boss_info_view b;


CREATE OR REPLACE FUNCTION boss_ataque_fisico(boss_id INT, player_id INT)
RETURNS VOID AS $$
DECLARE
    alvo RECORD;
    parte_alvo RECORD;
    dano_base INT;
    dano INT;
    critico BOOLEAN;
    vantagem BOOLEAN;
    fraqueza BOOLEAN;
    chance_critico INT;
BEGIN
    -- 🔹 1. Buscar um alvo com fraqueza ao elemento do Boss (Player ou Cavaleiro)
    SELECT id_player AS id, 'player' AS tipo, player_nome AS nome, player_hp_atual AS hp, elemento_nome AS elemento
    INTO alvo
    FROM player_info_view
    WHERE id_player = player_id
    AND id_fraqueza = (SELECT id_vantagem FROM boss_info_view WHERE id_boss = boss_id)
    AND player_hp_atual > 0
    LIMIT 1;

    -- 🔹 2. Se não encontrou um alvo fraco, buscar um Cavaleiro do mesmo Player
    IF alvo.id IS NULL THEN
        SELECT id_cavaleiro AS id, 'cavaleiro' AS tipo, cavaleiro_nome AS nome, cavaleiro_hp_atual AS hp, cavaleiro_elemento AS elemento
        INTO alvo
        FROM party_cavaleiros_view
        WHERE id_player = player_id
        AND id_fraqueza = (SELECT id_vantagem FROM boss_info_view WHERE id_boss = boss_id)
        AND cavaleiro_hp_atual > 0
        LIMIT 1;
    END IF;

    -- 🔹 3. Se ainda não encontrou, escolher aleatoriamente entre Player e Cavaleiro
    IF alvo.id IS NULL THEN
        SELECT id, tipo, nome, hp, elemento INTO alvo FROM (
            SELECT id_player AS id, 'player' AS tipo, player_nome AS nome, player_hp_atual AS hp, elemento_nome AS elemento
            FROM player_info_view
            WHERE id_player = player_id AND player_hp_atual > 0
            UNION ALL
            SELECT id_cavaleiro AS id, 'cavaleiro' AS tipo, cavaleiro_nome AS nome, cavaleiro_hp_atual AS hp, cavaleiro_elemento AS elemento
            FROM party_cavaleiros_view
            WHERE id_player = player_id AND cavaleiro_hp_atual > 0
        ) AS alvos_possiveis
        ORDER BY random()
        LIMIT 1;
    END IF;

    -- 🔹 4. Escolher uma parte do corpo do alvo
    IF alvo.tipo = 'player' THEN
        SELECT parte_corpo_nome, parte_corpo_defesa_fisica_total AS defesa_fisica, parte_corpo_defesa_magica_total AS defesa_magica, parte_corpo_chance_acerto_critico AS chance_critico
        INTO parte_alvo
        FROM player_parte_corpo_info_view
        WHERE id_player = alvo.id
        ORDER BY random()
        LIMIT 1;
    ELSE
        SELECT cavaleiro_parte_corpo, cavaleiro_defesa_fisica AS defesa_fisica, cavaleiro_defesa_magica AS defesa_magica, cavaleiro_chance_acerto_critico AS chance_critico
        INTO parte_alvo
        FROM cavaleiro_parte_corpo_info_view
        WHERE id_cavaleiro = alvo.id
        ORDER BY random()
        LIMIT 1;
    END IF;

    -- 🔹 5. Definir dano base como ataque físico do Boss
    SELECT boss_ataque_fisico INTO dano_base FROM boss_info_view WHERE id_boss = boss_id;

    -- 🔹 6. Aplicar modificadores de dano
    dano := dano_base - parte_alvo.defesa_fisica;
    IF dano < 0 THEN dano := 1; END IF;

    critico := (random() * 100) < parte_alvo.chance_critico;
    IF critico THEN dano := dano * 1.5; END IF;

    -- 🔹 8. Log do ataque
    RAISE NOTICE 'Boss atacou % em % causando % de dano!', alvo.nome, parte_alvo.parte_corpo_nome, dano;
    
    -- 🔹 7. Aplicar dano ao alvo correto
    IF alvo.tipo = 'player' THEN
        UPDATE player SET hp_atual = hp_atual - dano WHERE id_player = alvo.id;
    ELSE
        UPDATE instancia_cavaleiro SET hp_atual = hp_atual - dano WHERE id_cavaleiro = alvo.id;
    END IF;

  
    

END $$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION player_ataque_fisico(player_id INT, boss_id INT, parte_alvo_escolhida enum_parte_corpo)
RETURNS VOID AS $$
DECLARE
    parte_alvo RECORD;
    dano_base INT;
    dano INT;
    critico BOOLEAN;
    vantagem BOOLEAN;
    fraqueza BOOLEAN;
    chance_critico INT;
    p_nome TEXT;
BEGIN
    -- 🔹 1. Buscar a parte do corpo do Boss que o Player escolheu atacar
    SELECT parte_corpo, boss_defesa_fisica AS defesa_fisica, boss_defesa_magica AS defesa_magica, boss_chance_acerto_critico AS chance_critico, boss_parte_corpo as nome_parte_corpo
    INTO parte_alvo
    FROM boss_parte_corpo_info_view
    WHERE id_boss = boss_id
    AND parte_corpo = parte_alvo_escolhida
    LIMIT 1;

    -- 🔹 2. Verificar se a parte do corpo escolhida é válida
    IF parte_alvo.parte_corpo IS NULL THEN
        RAISE NOTICE 'Parte do corpo inválida! O ataque falhou.';
        RETURN;
    END IF;

    -- 🔹 3. Definir dano base como ataque físico do Player
    SELECT ataque_fisico_total, player_nome INTO dano_base, p_nome FROM player_info_view WHERE id_player = player_id;

    -- 🔹 4. Aplicar modificadores de dano baseados na defesa do Boss
    dano := dano_base - parte_alvo.defesa_fisica;
    IF dano < 0 THEN dano := 1; END IF;  -- Evita dano negativo

    -- 🔹 5. Calcular chance de acerto crítico
    critico := (random() * 100) < parte_alvo.chance_critico;
    IF critico THEN dano := dano * 1.5; END IF;

    -- 🔹 6. Verificar vantagem e fraqueza elementais
    vantagem := (SELECT id_elemento FROM player_info_view WHERE id_player = player_id) = (SELECT id_fraqueza FROM boss_info_view WHERE id_boss = boss_id);
    fraqueza := (SELECT id_elemento FROM player_info_view WHERE id_player = player_id) = (SELECT id_vantagem FROM boss_info_view WHERE id_boss = boss_id);

    -- 🔹 7. Aplicar multiplicadores de dano
    IF vantagem THEN
        dano := dano * 1.25;  -- Aumenta 25% se o Player tiver vantagem elemental
    END IF;

    IF fraqueza THEN
        dano := dano * 0.75;  -- Reduz 25% se o Player tiver fraqueza elemental
    END IF;

    -- 🔹 8. Exibir mensagem do ataque
    RAISE NOTICE '% atacou o Boss na % causando % de dano!', p_nome, parte_alvo.parte_corpo, dano;

    -- 🔹 9. Aplicar dano ao Boss
    UPDATE boss
    SET hp_atual = hp_atual - dano
    WHERE id_boss = boss_id;

    -- 🔹 10. Verificar se o Boss morreu
    IF (SELECT hp_atual FROM boss WHERE id_boss = boss_id) <= 0 THEN
        RAISE NOTICE 'O Boss foi derrotado!';
    END IF;

END $$ LANGUAGE plpgsql;









-- -- CREATE OR REPLACE FUNCTION player_ataca_inimigo(
-- --     p_id_player INT,
-- --     p_id_instancia_inimigo INT,
-- --     p_parte_corpo enum_parte_corpo
-- -- ) RETURNS TABLE(mensagem TEXT) AS $$
-- -- DECLARE
-- --     v_nome_player TEXT;
-- --     v_nome_inimigo TEXT;
-- --     v_ataque_fisico INT;
-- --     v_defesa_fisica INT;
-- --     v_hp_atual_antes INT;
-- --     v_hp_atual_depois INT;
-- --     v_dano INT;
-- --     v_parte_corpo_extenso TEXT;
-- -- BEGIN
-- --     SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
-- --     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
-- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
-- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

-- --     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM player WHERE id_player = p_id_player;
-- --     SELECT pci.defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo pci
-- --     WHERE pci.id_instancia = p_id_instancia_inimigo AND pci.parte_corpo = p_parte_corpo;

-- --     SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

-- --     v_parte_corpo_extenso := CASE 
-- --         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
-- --         WHEN p_parte_corpo = 't' THEN 'Tronco'
-- --         WHEN p_parte_corpo = 'b' THEN 'Braços'
-- --         WHEN p_parte_corpo = 'p' THEN 'Pernas'
-- --         ELSE 'Desconhecido' 
-- --     END;

-- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
-- --         RETURN QUERY SELECT 'Erro: Player ou inimigo não encontrado!'::TEXT;
-- --     END IF;

-- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

-- --     UPDATE instancia_inimigo 
-- --     SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
-- --     WHERE id_instancia = p_id_instancia_inimigo;

-- --     SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

-- --     RETURN QUERY SELECT format(
-- --         '🗡️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
-- --         v_nome_player, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
-- --     );
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE OR REPLACE FUNCTION cavaleiro_ataca_inimigo(
-- --     p_id_instancia_inimigo INT,
-- --     p_parte_corpo enum_parte_corpo
-- -- ) RETURNS TABLE(mensagem TEXT) AS $$
-- -- DECLARE
-- --     v_nome_cavaleiro TEXT;
-- --     v_nome_inimigo TEXT;
-- --     v_ataque_fisico INT;
-- --     v_defesa_fisica INT;
-- --     v_hp_atual_antes INT;
-- --     v_hp_atual_depois INT;
-- --     v_dano INT;
-- --     v_parte_corpo_extenso TEXT;public.player
-- -- BEGIN
-- --     SELECT c.nome INTO v_nome_cavaleiro FROM instancia_cavaleiro ic 
-- --     INNER JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro

-- --     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
-- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
-- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

-- --     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM instancia_cavaleiro 

-- --     SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo 
-- --     WHERE id_instancia = p_id_instancia_inimigo AND parte_corpo = p_parte_corpo;

-- --     SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

-- --     v_parte_corpo_extenso := CASE 
-- --         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
-- --         WHEN p_parte_corpo = 't' THEN 'Tronco'
-- --         WHEN p_parte_corpo = 'b' THEN 'Braços'
-- --         WHEN p_parte_corpo = 'p' THEN 'Pernas'
-- --         ELSE 'Desconhecido' 
-- --     END;

-- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
-- --         RETURN QUERY SELECT 'Erro: Cavaleiro ou inimigo não encontrado!'::TEXT;
-- --     END IF;

-- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

-- --     UPDATE instancia_inimigo 
-- --     SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
-- --     WHERE id_instancia = p_id_instancia_inimigo;

-- --     SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

-- --     RETURN QUERY SELECT format(
-- --         '⚔️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
-- --         v_nome_cavaleiro, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
-- --     );
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE OR REPLACE FUNCTION inimigo_ataca_player(
-- --     p_id_instancia_inimigo INT,
-- --     p_id_player INT,
-- --     p_parte_corpo enum_parte_corpo
-- -- ) RETURNS TABLE(mensagem TEXT) AS $$
-- -- DECLARE
-- --     v_nome_inimigo TEXT;
-- --     v_nome_player TEXT;
-- --     v_ataque_fisico INT;
-- --     v_defesa_fisica INT;
-- --     v_hp_atual_antes INT;
-- --     v_hp_atual_depois INT;
-- --     v_dano INT;
-- --     v_parte_corpo_extenso TEXT;
-- -- BEGIN
-- --     SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
-- --     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
-- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
-- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

-- --     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM instancia_inimigo ii
-- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
-- --     WHERE ii.id_instancia = p_id_instancia_inimigo;


-- --     SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_player 

-- --     WHERE id_player = p_id_player AND parte_corpo = p_parte_corpo;

-- --     SELECT hp_atual INTO v_hp_atual_antes FROM player WHERE id_player = p_id_player;

-- --     v_parte_corpo_extenso := CASE 
-- --         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
-- --         WHEN p_parte_corpo = 't' THEN 'Tronco'
-- --         WHEN p_parte_corpo = 'b' THEN 'Braços'
-- --         WHEN p_parte_corpo = 'p' THEN 'Pernas'
-- --         ELSE 'Desconhecido' 
-- --     END;

-- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
-- --         RETURN QUERY SELECT 'Erro: Inimigo ou player não encontrado!'::TEXT;
-- --     END IF;

-- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

-- --     UPDATE player SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
-- --     WHERE id_player = p_id_player;

-- --     SELECT hp_atual INTO v_hp_atual_depois FROM player WHERE id_player = p_id_player;

-- --     RETURN QUERY SELECT format(
-- --         '🔥 %s atacou %s na %s, causando %s de dano. HP: %s → %s',
-- --         v_nome_inimigo, v_nome_player, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
-- --     );
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- TA COMENTADO POIS IA TER Q MEXER NA LOGICA INTEIRA 

-- -- CREATE OR REPLACE FUNCTION inimigo_ataca_cavaleiro(
-- --     p_id_instancia_inimigo INT,
-- --     p_parte_corpo enum_parte_corpo
-- -- ) RETURNS TABLE(mensagem TEXT) AS $$
-- -- DECLARE
-- --     v_ataque_fisico INT;
-- --     v_defesa_fisica INT;
-- --     v_hp_atual INT;
-- --     v_dano INT;
-- -- BEGIN
-- --     -- Obtém o ataque físico do inimigo
-- --     SELECT i.ataque_fisico INTO v_ataque_fisico
-- --     FROM instancia_inimigo ii
-- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
-- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

-- --     -- Obtém a defesa da parte do corpo do cavaleiro
-- --     SELECT pcc.defesa_fisica INTO v_defesa_fisica
-- --     FROM parte_corpo_cavaleiro pcc
-- --     INNER JOIN instancia_cavaleiro ic 
-- --         ON ic.id_instancia_cavaleiro = pcc.id_instancia_cavaleiro
-- --     WHERE pcc.id_instancia_cavaleiro = p_id_instancia_cavaleiro
-- --         AND pcc.parte_corpo = p_parte_corpo;

-- --     -- Se ataque ou defesa não forem encontrados, retorna erro
-- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
-- --         RETURN QUERY SELECT 'Erro: Inimigo ou cavaleiro não encontrado!'::TEXT;
-- --     END IF;

-- --     -- Calcula o dano causado
-- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0); -- Garante que o dano não seja negativo

-- --     -- Atualiza o HP do cavaleiro
-- --     UPDATE instancia_cavaleiro
-- --     SET hp_atual = GREATEST(hp_atual - v_dano, 0) -- Garante que o HP não seja negativo
-- --     WHERE id_instancia_cavaleiro = p_id_instancia_cavaleiro;

-- --     -- Obtém o novo HP do cavaleiro
-- --     SELECT hp_atual INTO v_hp_atual
-- --     FROM instancia_cavaleiro
-- --     WHERE id_instancia_cavaleiro = p_id_instancia_cavaleiro;

-- --     -- Retorna a mensagem do ataque
-- --     RETURN QUERY SELECT format(
-- --         '💀 Inimigo %s atacou o Cavaleiro %s na parte %s, causando %s de dano. HP Atual do Cavaleiro: %s',
-- --         p_id_instancia_inimigo, p_id_instancia_cavaleiro, p_parte_corpo, v_dano, v_hp_atual
-- --     );
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- create or replace view info_batalha as		 
-- select 
-- 	c.nome,
-- 	c.id_elemento,
-- 	c.nivel,
-- 	c.hp_max ,
-- 	ic.hp_atual,
-- 	c.magia_max ,
-- 	ic.magia_atual,
-- 	ic.velocidade,
-- 	ic.ataque_fisico ,
-- 	ic.ataque_magico ,
-- 	pcc.defesa_magica ,
-- 	pcc.defesa_fisica ,
-- 	pcc.parte_corpo ,
-- 	p.id_player, -- 
-- 	'c' as tipo_personagem,
-- 	ic.id_cavaleiro as id
-- 	from 
-- 	party p
-- inner join instancia_cavaleiro ic on
-- 	ic.id_player = p.id_player
-- inner join cavaleiro c on
-- 	c.id_cavaleiro = ic.id_cavaleiro
-- inner join parte_corpo_cavaleiro pcc 
-- on
-- 	pcc.id_cavaleiro = ic.id_cavaleiro
-- union all
-- select
-- 	   inim.nome,
-- 	   inim.id_elemento,
-- 	   inim.nivel ,
-- 	   inim.hp_max,
-- 	   ii.hp_atual ,
-- 	   inim.magia_max,
-- 	   ii.magia_atual,
-- 	   ii.velocidade,
-- 	   ii.ataque_fisico,
-- 	   ii.ataque_magico,
-- 	   ii.defesa_magica ,
-- 	   ii.defesa_fisica ,
-- 	   pci.parte_corpo ,
-- 	   p.id_player, -- id_player que ta batalhando
-- 	   'i' as tipo_personagem,
-- 	   ii.id_instancia as id
-- from
-- 	grupo_inimigo gi
-- inner join instancia_inimigo ii 
-- 		 on
-- 	ii.id_grupo = gi.id_grupo
-- inner join inimigo inim
-- 		 on
-- 	ii.id_inimigo = inim.id_inimigo
-- inner join party p 
-- 		 on
-- 	p.id_sala = gi.id_sala
-- inner join parte_corpo_inimigo pci 
-- 		 on
-- 	pci.id_inimigo = ii.id_inimigo
-- 	and pci.id_instancia = ii.id_instancia
-- union all
-- select
-- 	p.nome,
-- 	p.id_elemento,
-- 	p.nivel,
-- 	p.hp_max,
-- 	p.hp_atual,
-- 	p.magia_max,
-- 	p.magia_atual,
-- 	p.velocidade,
-- 	p.ataque_fisico + aev.ataque_fisico as ataque_fisico_armadura,
-- 	p.ataque_magico + aev.ataque_magico as ataque_magico_armadura,
-- 	pcp.defesa_magica + aev.defesa_magica as defesa_magica,
-- 	aev.defesa_fisica + pcp.defesa_fisica as defesa_fisica,
-- 	aev.durabilidade_atual,
-- 	pcp.parte_corpo,
-- 	p.id_player, 
-- 	'p' as tipo_personagem,
-- 	p.id_player as id -- repeti essa coluna pois preciso que union traga colunas iguais
-- from
-- 	player p
-- inner join armadura_equipada ae 
-- on
-- 	ae.id_player = p.id_player
-- inner join armadura_equipada_view aev
-- on
-- 	aev.id_inventario = p.id_player
-- inner join parte_corpo_player pcp 
-- on
-- 	pcp.id_player = p.id_player
-- 	and pcp.parte_corpo = aev.id_parte_corpo_armadura;

-- CREATE OR REPLACE VIEW fila AS
-- WITH min_speed AS (
--   SELECT MIN(velocidade) AS min_vel FROM info_batalha
-- ),
-- ataques AS (
--   SELECT 
--     i.id,
--     i.tipo_personagem,
--     i.velocidade,
--     (i.velocidade / m.min_vel)::int AS num_attacks
--   FROM info_batalha i
--   CROSS JOIN min_speed m
-- ),
-- rounds AS (
--   SELECT 
--     a.id,
--     a.tipo_personagem,
--     a.velocidade,
--     gs AS round_num
--   FROM ataques a
--   CROSS JOIN LATERAL generate_series(1, a.num_attacks) AS gs(round_num)
-- )
-- SELECT id, tipo_personagem
-- FROM rounds
-- ORDER BY round_num, velocidade DESC;

-- -- como 
-- -- como usar a view fila, voce filtro pelo id_player como where id_player = 'id do player que tá batalhando"


-- -- select * from info_batalha where player_id = 1