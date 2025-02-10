CREATE OR REPLACE FUNCTION aprender_habilidade(player_id INT, cavaleiro_id INT, habilidade_id INT)
RETURNS TEXT AS $$
DECLARE
    classe_habilidade INT;
    elemento_habilidade INT;
    classe_cavaleiro INT;
    elemento_personagem INT;
    slots_ocupados INT;
BEGIN
    -- Verifica se a habilidade existe
    SELECT h.classe_habilidade, h.elemento_habilidade INTO classe_habilidade, elemento_habilidade
    FROM habilidade h
    WHERE h.id_habilidade = habilidade_id;
    
    IF NOT FOUND THEN
        RETURN 'Habilidade não encontrada.';
    END IF;
    
    -- Verifica se está aprendendo para o player ou cavaleiro
    IF cavaleiro_id IS NULL THEN
        -- Player pode aprender qualquer habilidade do seu elemento
        SELECT id_elemento INTO elemento_personagem FROM player_info_view WHERE id_player = player_id;
        
        IF elemento_habilidade != elemento_personagem THEN
            RETURN 'O Player não pode aprender essa habilidade (elemento incompatível).';
        END IF;

        -- Verifica se já tem 4 habilidades
        SELECT COUNT(*) INTO slots_ocupados FROM habilidade_player WHERE id_player = player_id;
        
        IF slots_ocupados >= 4 THEN
            RAISE EXCEPTION 'O Player já tem 4 habilidades. Substitua uma para aprender.';
        END IF;
        
        -- Adiciona a nova habilidade
        INSERT INTO habilidade_player (id_player, id_habilidade, slot)
        VALUES (player_id, habilidade_id, slots_ocupados + 1);
        
        RETURN 'Habilidade aprendida com sucesso pelo Player.';
    
    ELSE
        -- Cavaleiro só pode aprender habilidades da sua classe e elemento
        SELECT elemento_id, classe_id INTO elemento_personagem, classe_cavaleiro
        FROM instancia_cavaleiro_view WHERE id_cavaleiro = cavaleiro_id;

        IF classe_habilidade != classe_cavaleiro OR elemento_habilidade != elemento_personagem THEN
            RAISE EXCEPTION 'O Cavaleiro não pode aprender essa habilidade (classe ou elemento incompatível).';
        END IF;
        
        -- Verifica se já tem 4 habilidades
        SELECT COUNT(*) INTO slots_ocupados FROM habilidade_cavaleiro WHERE id_cavaleiro = cavaleiro_id;
        
        IF slots_ocupados >= 4 THEN
            RAISE EXCEPTION 'O Cavaleiro já tem 4 habilidades. Substitua uma para aprender.';
        END IF;
        
        -- Adiciona a nova habilidade
        INSERT INTO habilidade_cavaleiro (id_cavaleiro, id_habilidade, slot)
        VALUES (cavaleiro_id, habilidade_id, slots_ocupados + 1);
        
        RETURN 'Habilidade aprendida com sucesso pelo Cavaleiro.';
    END IF;
END $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reduzir_item_armazenado()
RETURNS TRIGGER AS $$
DECLARE
    id_livro INT;
    player_id INT;
BEGIN
    -- Obtém o ID do livro relacionado à habilidade aprendida
    SELECT id_item INTO id_livro 
    FROM livro 
    WHERE id_habilidade = NEW.id_habilidade;

    -- Obtém o ID do player (caso seja um cavaleiro, pegamos do cavaleiro correspondente)
    IF TG_TABLE_NAME = 'habilidade_player' THEN
        player_id := NEW.id_player;
    ELSIF TG_TABLE_NAME = 'habilidade_cavaleiro' THEN
        SELECT id_player INTO player_id
        FROM instancia_cavaleiro
        WHERE id_cavaleiro = NEW.id_cavaleiro;
    END IF;

    -- Atualiza a quantidade do item no inventário do jogador
    UPDATE item_armazenado
    SET quantidade = quantidade - 1
    WHERE id_inventario = player_id
    AND id_item = id_livro;

    -- Remove o item do inventário se a quantidade for 0
    DELETE FROM item_armazenado
    WHERE id_inventario= player_id
    AND id_item = id_livro
    AND quantidade <= 0;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_reduzir_item_habilidade_player
AFTER INSERT ON habilidade_player
FOR EACH ROW
EXECUTE FUNCTION reduzir_item_armazenado();


CREATE TRIGGER trigger_reduzir_item_habilidade_cavaleiro
AFTER INSERT ON habilidade_cavaleiro
FOR EACH ROW
EXECUTE FUNCTION reduzir_item_armazenado();