CREATE OR REPLACE FUNCTION insert_party_trigger_function()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO Party (id_player, id_sala) VALUES (NEW.id_player, listar_sala_segura());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_party
AFTER INSERT ON Player
FOR EACH ROW
EXECUTE FUNCTION insert_party_trigger_function();

CREATE OR REPLACE FUNCTION instanciar_player_missao_procedure()
RETURNS TRIGGER AS $$
DECLARE
    missao RECORD;
BEGIN

    FOR missao IN SELECT id_missao FROM Missao LOOP
        INSERT INTO Player_missao (id_player, id_missao, status_missao)
        VALUES (NEW.id_player, missao.id_missao, 'ni');
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER instanciar_player_missao
AFTER INSERT ON Player
FOR EACH ROW
EXECUTE FUNCTION instanciar_player_missao_procedure();


 
-- garante que todavez q uma missao nova for add todos os players terão uma instancia dela

CREATE OR REPLACE FUNCTION instanciar_player_missao_new_missao()
RETURNS TRIGGER AS $$
DECLARE
    player RECORD;
BEGIN
    FOR player IN SELECT id_player FROM Player LOOP
        INSERT INTO Player_missao (id_player, id_missao, status_missao)
        VALUES (player.id_player, NEW.id_missao, 'ni');
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instancia_player_missao_new_missoes
AFTER INSERT ON Missao
FOR EACH ROW
EXECUTE FUNCTION instanciar_player_missao_new_missao();


-- criar inventario

CREATE OR REPLACE FUNCTION after_player_insert_function()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO inventario (id_player, dinheiro, alma_armadura)
    VALUES (NEW.id_player, 200, 200);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_player_insert
AFTER INSERT ON player
FOR EACH ROW
EXECUTE FUNCTION after_player_insert_function();

CREATE OR REPLACE FUNCTION verificar_dinheiro()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.dinheiro < 0 THEN
        RAISE EXCEPTION 'O jogador não pode ter dinheiro negativo.';
    END IF;
    RETURN NEW;
END $$;

CREATE TRIGGER trg_verificar_dinheiro
BEFORE UPDATE ON inventario
FOR EACH ROW
EXECUTE FUNCTION verificar_dinheiro();


-- inserir em tipo_item item_missao

CREATE OR REPLACE FUNCTION before_insert_item_missao()
RETURNS TRIGGER AS $$
DECLARE
    new_id_item INTEGER;
BEGIN
    INSERT INTO tipo_item (tipo_item)
    VALUES ('i')
    RETURNING id_item INTO new_id_item;

    NEW.id_item := new_id_item;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER  before_insert_item_missao_trigger
BEFORE INSERT ON item_missao
FOR EACH ROW
EXECUTE FUNCTION  before_insert_item_missao();

-- Trigger para inserir em "livro"
CREATE OR REPLACE FUNCTION before_insert_livro()
RETURNS TRIGGER AS $$
DECLARE
    new_id_item INTEGER;
BEGIN
    INSERT INTO tipo_item (tipo_item)
    VALUES ('l') -- 'l' para livro
    RETURNING id_item INTO new_id_item;

    NEW.id_item := new_id_item;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_livro_trigger
BEFORE INSERT ON livro
FOR EACH ROW
EXECUTE FUNCTION before_insert_livro();


-- Trigger para inserir em "material"
CREATE OR REPLACE FUNCTION before_insert_material()
RETURNS TRIGGER AS $$
DECLARE
    new_id_material INTEGER;
BEGIN
    INSERT INTO tipo_item (tipo_item)
    VALUES ('m') -- 'm' para material
    RETURNING id_item INTO new_id_material;

    NEW.id_material := new_id_material;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_material_trigger
BEFORE INSERT ON material
FOR EACH ROW
EXECUTE FUNCTION before_insert_material();


-- Trigger para inserir em "armadura"
CREATE OR REPLACE FUNCTION before_insert_armadura()
RETURNS TRIGGER AS $$
DECLARE
    new_id_armadura INTEGER;
BEGIN
    INSERT INTO tipo_item (tipo_item)
    VALUES ('a') -- 'a' para armadura
    RETURNING id_item INTO new_id_armadura;

    NEW.id_armadura := new_id_armadura;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_armadura_trigger
BEFORE INSERT ON armadura
FOR EACH ROW
EXECUTE FUNCTION before_insert_armadura();

CREATE OR REPLACE FUNCTION subir_de_nivel()
RETURNS TRIGGER AS $$
DECLARE
    nivel_atual INTEGER;
    xp_atual INTEGER;
BEGIN
    nivel_atual := OLD.nivel;
    xp_atual := OLD.xp_atual;

    IF xp_atual >= (SELECT xp_necessaria FROM xp_necessaria where nivel = nivel_atual + 1) THEN
        NEW.xp_atual := xp_atual - xp_necessaria;
        NEW.nivel := nivel_atual + 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_subir_de_nivel_player
BEFORE UPDATE OF xp_atual ON Player
FOR EACH ROW
WHEN (OLD.xp_atual <> NEW.xp_atual) 
EXECUTE FUNCTION subir_de_nivel();

CREATE TRIGGER trigger_subir_de_nivel_instancia_cavaleiro
BEFORE UPDATE OF xp_atual ON instancia_cavaleiro
FOR EACH ROW
WHEN (OLD.xp_atual <> NEW.xp_atual) 
EXECUTE FUNCTION subir_de_nivel();

CREATE OR REPLACE FUNCTION atualizar_status_missao_ao_drop_item()
RETURNS TRIGGER AS $$
DECLARE
    tipo_do_item TEXT;
    missao_id INTEGER;
BEGIN
    -- Verificar o tipo do item usando a tabela Tipo_item
    SELECT tipo_item INTO tipo_do_item 
    FROM tipo_item
    WHERE id_item = NEW.id_item;

    -- Verificar se o tipo do item é "i" (item missao)
    IF tipo_do_item = 'i' THEN
        -- Verifica se o item é necessário para alguma missão
        SELECT id_missao INTO missao_id
        FROM missao
        WHERE item_necessario = NEW.id_item;

        -- Se o item for necessário para uma missão, atualiza o status da missão do jogador
        IF missao_id IS NOT NULL THEN
            UPDATE player_missao
            SET status_missao = 'c'
            WHERE id_player = NEW.id_inventario
              AND id_missao = missao_id
              AND status_missao = 'i'; -- Apenas atualiza se não estiver concluída
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_status_missao
AFTER INSERT ON item_armazenado
FOR EACH ROW
EXECUTE FUNCTION atualizar_status_missao_ao_drop_item();


CREATE OR REPLACE FUNCTION remover_item_se_zero()
RETURNS TRIGGER AS $$
BEGIN
    
    IF NEW.quantidade = 0 THEN
        DELETE FROM item_armazenado
        WHERE id_inventario = NEW.id_inventario
          AND id_item = NEW.id_item;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_remover_item_se_zero
AFTER UPDATE OF quantidade
ON item_armazenado
FOR EACH ROW
WHEN (NEW.quantidade = 0) 
EXECUTE FUNCTION remover_item_se_zero();


CREATE OR REPLACE FUNCTION reviver_inimigos_sala()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualiza todos os inimigos mortos (hp_atual = 0) na sala para hp_max
    UPDATE instancia_inimigo ii
    SET hp_atual = i.hp_max
    FROM inimigo i
    WHERE ii.id_inimigo = i.id_inimigo
    AND ii.id_grupo IN (
        SELECT gi.id_grupo
        FROM grupo_inimigo gi
        WHERE gi.id_sala = NEW.id_sala
    )
    AND ii.hp_atual = 0; -- Só revive os que estão mortos

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_reviver_inimigos
AFTER UPDATE OF id_sala ON party
FOR EACH ROW
EXECUTE FUNCTION reviver_inimigos_sala();


CREATE OR REPLACE FUNCTION instanciar_cavaleiro()
RETURNS TRIGGER AS $$
DECLARE
    p_id_cavaleiro INTEGER;
    p_id_player INTEGER := NEW.id_player;
    p_id_party INTEGER := NEW.ID_player; -- Defina a lógica correta para a party, se necessário
    p_id_classe INTEGER;
    p_id_elemento INTEGER;
    p_nome TEXT;
    p_nivel INTEGER;
    p_hp_max INTEGER;
    p_magia_max INTEGER;
    p_velocidade INTEGER;
    p_ataque_fisico INTEGER;
    p_ataque_magico INTEGER;
BEGIN
    -- Obtém o cavaleiro desbloqueado pela missão concluída
    SELECT m.id_cavaleiro_desbloqueado
    INTO p_id_cavaleiro
    FROM missao m
    WHERE m.id_missao = NEW.id_missao;
    
    -- Se não houver cavaleiro a ser desbloqueado, não faz nada
    IF p_id_cavaleiro IS NULL THEN
        RETURN NEW;
    END IF;

    -- Obtém as informações do cavaleiro
    SELECT c.id_classe, c.id_elemento, c.nome, c.nivel, c.hp_max, c.magia_max, 
           c.velocidade, c.ataque_fisico, c.ataque_magico
    INTO p_id_classe, p_id_elemento, p_nome, p_nivel, p_hp_max, p_magia_max, 
         p_velocidade, p_ataque_fisico, p_ataque_magico
    FROM cavaleiro c
    WHERE c.id_cavaleiro = p_id_cavaleiro;

    -- Verifica se o jogador já tem este cavaleiro para evitar duplicatas
    IF NOT EXISTS (
        SELECT 1 FROM instancia_cavaleiro 
        WHERE id_player = p_id_player AND id_cavaleiro = p_id_cavaleiro
    ) THEN
        -- Insere o cavaleiro na instância do jogador
        INSERT INTO instancia_cavaleiro (
            id_cavaleiro, id_player, id_party, nivel, tipo_armadura, xp_atual, 
            hp_max, magia_max, hp_atual, magia_atual, velocidade, 
            ataque_fisico, ataque_magico
        ) VALUES (
            p_id_cavaleiro, p_id_player, p_id_party, p_nivel, 0, 0, 
            p_hp_max, p_magia_max, p_hp_max, p_magia_max, p_velocidade, 
            p_ataque_fisico, p_ataque_magico
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_liberar_cavaleiro
AFTER UPDATE ON player_missao
FOR EACH ROW
WHEN (NEW.status_missao = 'c' AND old.status_missao != 'c')
EXECUTE FUNCTION instanciar_cavaleiro();

CREATE OR REPLACE FUNCTION mover_sala_segura_pos_morte()
RETURNS TRIGGER AS $$
BEGIN

    UPDATE inventario
    SET dinheiro = dinheiro / 2
    WHERE inventario.id_player = OLD.id_player;

    RAISE NOTICE '% foi derrotado, Saori Kido o resgata mas com um custo...', OLD.id_player;


    UPDATE party
    SET id_sala = (SELECT id_sala FROM public.sala_segura LIMIT 1)  -- Usar parênteses no SELECT
    WHERE party.id_player = OLD.id_player;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_player_morreu
BEFORE UPDATE ON player
FOR EACH ROW
WHEN (NEW.hp_atual <= 0) 
EXECUTE FUNCTION mover_sala_segura_pos_morte();
