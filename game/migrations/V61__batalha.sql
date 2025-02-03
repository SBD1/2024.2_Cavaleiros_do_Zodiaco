CREATE OR REPLACE FUNCTION player_ataca_inimigo(
    p_id_player INT,
    p_id_instancia_inimigo INT,
    p_parte_corpo enum_parte_corpo
) RETURNS TABLE(mensagem TEXT) AS $$
DECLARE
    v_nome_player TEXT;
    v_nome_inimigo TEXT;
    v_ataque_fisico INT;
    v_defesa_fisica INT;
    v_hp_atual_antes INT;
    v_hp_atual_depois INT;
    v_dano INT;
    v_parte_corpo_extenso TEXT;
BEGIN
    SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
    SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
    INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    WHERE ii.id_instancia = p_id_instancia_inimigo;

    SELECT ataque_fisico_base / 8 INTO v_ataque_fisico FROM player WHERE id_player = p_id_player;
    SELECT pci.defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo pci
    WHERE pci.id_instancia = p_id_instancia_inimigo AND pci.parte_corpo = p_parte_corpo;

    SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    v_parte_corpo_extenso := CASE 
        WHEN p_parte_corpo = 'c' THEN 'Cabeça'
        WHEN p_parte_corpo = 't' THEN 'Tronco'
        WHEN p_parte_corpo = 'b' THEN 'Braços'
        WHEN p_parte_corpo = 'p' THEN 'Pernas'
        ELSE 'Desconhecido' 
    END;

    IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
        RETURN QUERY SELECT 'Erro: Player ou inimigo não encontrado!'::TEXT;
    END IF;

    v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

    UPDATE instancia_inimigo 
    SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
    WHERE id_instancia = p_id_instancia_inimigo;

    SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    RETURN QUERY SELECT format(
        '🗡️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
        v_nome_player, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cavaleiro_ataca_inimigo(
    p_id_instancia_cavaleiro INT,
    p_id_instancia_inimigo INT,
    p_parte_corpo enum_parte_corpo
) RETURNS TABLE(mensagem TEXT) AS $$
DECLARE
    v_nome_cavaleiro TEXT;
    v_nome_inimigo TEXT;
    v_ataque_fisico INT;
    v_defesa_fisica INT;
    v_hp_atual_antes INT;
    v_hp_atual_depois INT;
    v_dano INT;
    v_parte_corpo_extenso TEXT;
BEGIN
    SELECT c.nome INTO v_nome_cavaleiro FROM instancia_cavaleiro ic 
    INNER JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro
    WHERE ic.id_instancia_cavaleiro = p_id_instancia_cavaleiro;

    SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
    INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    WHERE ii.id_instancia = p_id_instancia_inimigo;

    SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM instancia_cavaleiro 
    WHERE id_instancia_cavaleiro = p_id_instancia_cavaleiro;

    SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo 
    WHERE id_instancia = p_id_instancia_inimigo AND parte_corpo = p_parte_corpo;

    SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    v_parte_corpo_extenso := CASE 
        WHEN p_parte_corpo = 'c' THEN 'Cabeça'
        WHEN p_parte_corpo = 't' THEN 'Tronco'
        WHEN p_parte_corpo = 'b' THEN 'Braços'
        WHEN p_parte_corpo = 'p' THEN 'Pernas'
        ELSE 'Desconhecido' 
    END;

    IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
        RETURN QUERY SELECT 'Erro: Cavaleiro ou inimigo não encontrado!'::TEXT;
    END IF;

    v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

    UPDATE instancia_inimigo 
    SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
    WHERE id_instancia = p_id_instancia_inimigo;

    SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    RETURN QUERY SELECT format(
        '⚔️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
        v_nome_cavaleiro, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inimigo_ataca_player(
    p_id_instancia_inimigo INT,
    p_id_player INT,
    p_parte_corpo enum_parte_corpo
) RETURNS TABLE(mensagem TEXT) AS $$
DECLARE
    v_nome_inimigo TEXT;
    v_nome_player TEXT;
    v_ataque_fisico INT;
    v_defesa_fisica INT;
    v_hp_atual_antes INT;
    v_hp_atual_depois INT;
    v_dano INT;
    v_parte_corpo_extenso TEXT;
BEGIN
    SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
    SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
    INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    WHERE ii.id_instancia = p_id_instancia_inimigo;

    SELECT ataque_fisico_base / 8 INTO v_ataque_fisico FROM instancia_inimigo ii
    INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    WHERE ii.id_instancia = p_id_instancia_inimigo;


    SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_player 

    WHERE id_player = p_id_player AND parte_corpo = p_parte_corpo;

    SELECT hp_atual INTO v_hp_atual_antes FROM player WHERE id_player = p_id_player;

    v_parte_corpo_extenso := CASE 
        WHEN p_parte_corpo = 'c' THEN 'Cabeça'
        WHEN p_parte_corpo = 't' THEN 'Tronco'
        WHEN p_parte_corpo = 'b' THEN 'Braços'
        WHEN p_parte_corpo = 'p' THEN 'Pernas'
        ELSE 'Desconhecido' 
    END;

    IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
        RETURN QUERY SELECT 'Erro: Inimigo ou player não encontrado!'::TEXT;
    END IF;

    v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

    UPDATE player SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
    WHERE id_player = p_id_player;

    SELECT hp_atual INTO v_hp_atual_depois FROM player WHERE id_player = p_id_player;

    RETURN QUERY SELECT format(
        '🔥 %s atacou %s na %s, causando %s de dano. HP: %s → %s',
        v_nome_inimigo, v_nome_player, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inimigo_ataca_player(
    p_id_instancia_inimigo INT,
    p_id_player INT,
    p_parte_corpo enum_parte_corpo
) RETURNS TABLE(mensagem TEXT) AS $$
DECLARE
    v_nome_inimigo TEXT;
    v_nome_player TEXT;
    v_ataque_fisico INT;
    v_defesa_fisica INT;
    v_hp_atual_antes INT;
    v_hp_atual_depois INT;
    v_dano INT;
    v_parte_corpo_extenso TEXT;
BEGIN
    -- Obtém os nomes do inimigo e do player
    SELECT p.nome INTO v_nome_player FROM player p WHERE p.id_player = p_id_player;
    
    SELECT i.nome INTO v_nome_inimigo 
    FROM instancia_inimigo ii
    INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    WHERE ii.id_instancia = p_id_instancia_inimigo;

    -- Obtém ataque físico do inimigo (dividido por 3 como solicitado)
    SELECT i.ataque_fisico_base / 3 INTO v_ataque_fisico 
    FROM instancia_inimigo ii
    INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    WHERE ii.id_instancia = p_id_instancia_inimigo;

    -- Obtém defesa física correta do player
    SELECT pc.defesa_fisica INTO v_defesa_fisica
    FROM parte_corpo_player pcp
    INNER JOIN player p ON pcp.id_player = p.id_player
    INNER JOIN parte_corpo pc ON pc.id_parte_corpo = pcp.parte_corpo
    WHERE pcp.id_player = p_id_player AND pcp.parte_corpo = p_parte_corpo;

    -- Obtém o HP antes do ataque
    SELECT hp_atual INTO v_hp_atual_antes FROM player WHERE id_player = p_id_player;

    -- Converte parte do corpo para nome completo
    v_parte_corpo_extenso := CASE 
        WHEN p_parte_corpo = 'c' THEN 'Cabeça 🧠'
        WHEN p_parte_corpo = 't' THEN 'Tronco 🏋️'
        WHEN p_parte_corpo = 'b' THEN 'Braços 💪'
        WHEN p_parte_corpo = 'p' THEN 'Pernas 🦵'
        ELSE 'Desconhecido' 
    END;

    -- Validação se encontrou os valores corretos
    IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
        RETURN QUERY SELECT '⚠️ Erro: Inimigo ou player não encontrado!'::TEXT;
    END IF;

    -- Calcula o dano real a ser aplicado
    v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

    -- Atualiza o HP do player garantindo que não fique negativo
    UPDATE player 
    SET hp_atual = GREATEST(hp_atual - v_dano, 0)
    WHERE id_player = p_id_player;

    -- Obtém o novo HP do player após o ataque
    SELECT hp_atual INTO v_hp_atual_depois FROM player WHERE id_player = p_id_player;

    -- Retorna a mensagem de ataque formatada corretamente
    RETURN QUERY SELECT format(
        '🔥 %s atacou %s na %s, causando %s de dano. HP: %s → %s',
        v_nome_inimigo, v_nome_player, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
    );
END;
$$ LANGUAGE plpgsql;
