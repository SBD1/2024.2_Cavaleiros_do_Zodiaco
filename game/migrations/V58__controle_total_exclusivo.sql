-- CREATE OR REPLACE FUNCTION enforce_tipo_item_exclusivo()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     v_id_item INT;
--     total_subclasses INT;
-- BEGIN
--     CASE TG_TABLE_NAME
--         WHEN 'material' THEN v_id_item := NEW.id_material;
--         WHEN 'armadura' THEN v_id_item := NEW.id_armadura;
--         WHEN 'item_missao' THEN v_id_item := NEW.id_item;
--         WHEN 'consumivel' THEN v_id_item := NEW.id_item;
--         WHEN 'livro' THEN v_id_item := NEW.id_item;
--         ELSE 
--             RAISE EXCEPTION 'Trigger chamada em uma tabela desconhecida!';
--     END CASE;

--     SELECT COUNT(*) INTO total_subclasses FROM (
--         SELECT id_material FROM material WHERE id_material = v_id_item
--         UNION ALL
--         SELECT id_armadura FROM armadura WHERE id_armadura = v_id_item
--         UNION ALL
--         SELECT id_item FROM item_missao WHERE id_item = v_id_item
--         UNION ALL
--         SELECT id_item FROM consumivel WHERE id_item = v_id_item
--         UNION ALL
--         SELECT id_item FROM livro WHERE id_item = v_id_item
--     ) AS sub_tabelas;

--     IF total_subclasses > 1 THEN
--         RAISE EXCEPTION 'O item deve pertencer a apenas uma subclasse!';
--     END IF;

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER check_tipo_item_exclusivo_material
-- BEFORE INSERT OR UPDATE ON material
-- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

-- CREATE TRIGGER check_tipo_item_exclusivo_armadura
-- BEFORE INSERT OR UPDATE ON armadura
-- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

-- CREATE TRIGGER check_tipo_item_exclusivo_item_missao
-- BEFORE INSERT OR UPDATE ON item_missao
-- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

-- CREATE TRIGGER check_tipo_item_exclusivo_consumivel
-- BEFORE INSERT OR UPDATE ON consumivel
-- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

-- CREATE TRIGGER check_tipo_item_exclusivo_livro
-- BEFORE INSERT OR UPDATE ON livro
-- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

-- CREATE OR REPLACE PROCEDURE inserir_item(
--     IN p_tipo_item enum_tipo_item,
--     IN p_nome VARCHAR,
--     IN p_preco_venda INT DEFAULT NULL,
--     IN p_descricao VARCHAR DEFAULT NULL,
--     IN p_id_parte_corpo enum_parte_corpo DEFAULT NULL,
--     IN p_raridade_armadura VARCHAR DEFAULT NULL,
--     IN p_defesa_magica INT DEFAULT NULL,
--     IN p_defesa_fisica INT DEFAULT NULL,
--     IN p_ataque_magico INT DEFAULT NULL,
--     IN p_ataque_fisico INT DEFAULT NULL,
--     IN p_durabilidade_max INT DEFAULT NULL,
--     IN p_saude_restaurada INT DEFAULT NULL, 
--     IN p_magia_restaurada INT DEFAULT NULL, 
--     IN p_saude_maxima INT DEFAULT NULL, 
--     IN p_magia_maxima INT DEFAULT NULL, 
--     IN p_id_habilidade INT DEFAULT NULL 
-- )
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
--     v_id_item INT;
-- BEGIN
    
--     INSERT INTO tipo_item (tipo_item) VALUES (p_tipo_item) RETURNING id_item INTO v_id_item;

    
--     CASE p_tipo_item
--         WHEN 'm' THEN 
--             INSERT INTO material (id_material, nome, preco_venda, descricao) 
--             VALUES (v_id_item, p_nome, p_preco_venda, p_descricao);
        
--         WHEN 'a' THEN 
--             INSERT INTO armadura (id_armadura, id_parte_corpo, nome, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max, preco_venda, descricao) 
--             VALUES (v_id_item, p_id_parte_corpo, p_nome, p_raridade_armadura, p_defesa_magica, p_defesa_fisica, p_ataque_magico, p_ataque_fisico, p_durabilidade_max, p_preco_venda, p_descricao);
        
--         WHEN 'i' THEN 
--             INSERT INTO item_missao (id_item, nome, descricao) 
--             VALUES (v_id_item, p_nome, p_descricao);
        
--         WHEN 'c' THEN 
--             INSERT INTO consumivel (id_item, nome, descricao, preco_venda, saude_restaurada, magia_restaurada, saude_maxima, magia_maxima) 
--             VALUES (v_id_item, p_nome, p_descricao, p_preco_venda, p_saude_restaurada, p_magia_restaurada, p_saude_maxima, p_magia_maxima);
        
--         WHEN 'l' THEN 
--             INSERT INTO livro (id_item, id_habilidade, nome, descricao, preco_venda) 
--             VALUES (v_id_item, p_id_habilidade, p_nome, p_descricao, p_preco_venda);
        
--         ELSE 
--             RAISE EXCEPTION 'Tipo de item inválido!';
--     END CASE;

--     RAISE NOTICE 'Item inserido com sucesso! ID: %', v_id_item;
-- END;
-- $$;



