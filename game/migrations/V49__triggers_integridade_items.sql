CREATE OR REPLACE FUNCTION before_insert_generic()
RETURNS TRIGGER AS $$
DECLARE
    new_id_item INTEGER;
    table_name TEXT := TG_TABLE_NAME; -- Obtém o nome da tabela
BEGIN

    IF table_name = 'livro' THEN
        INSERT INTO tipo_item (tipo_item)
        VALUES ('nc')  
        RETURNING id_item INTO new_id_item;

        INSERT INTO Nao_Craftavel (id_nao_craftavel, tipo_nao_craftavel)
        VALUES (new_id_item, 'l');
        NEW.id_item := new_id_item;
        
    ELSIF table_name = 'item_missao' THEN
        INSERT INTO tipo_item (tipo_item)
        VALUES ('nc')  
        RETURNING id_item INTO new_id_item;

        INSERT INTO Nao_Craftavel (id_nao_craftavel, tipo_nao_craftavel)
        VALUES (new_id_item, 'i');
        NEW.id_item := new_id_item;

    ELSIF table_name = 'consumivel' THEN
        INSERT INTO tipo_item (tipo_item)
        VALUES ('nc')  
        RETURNING id_item INTO new_id_item;

        INSERT INTO Nao_Craftavel (id_nao_craftavel, tipo_nao_craftavel)
        VALUES (new_id_item, 'c');
        NEW.id_item := new_id_item;
        
    ELSIF table_name = 'armadura' THEN
        INSERT INTO tipo_item (tipo_item)
        VALUES ('c')  
        RETURNING id_item INTO new_id_item;

        INSERT INTO Craftavel (id_craftavel, tipo_craftavel)
        VALUES (new_id_item, 'a');
        NEW.id_armadura := new_id_item;

    ELSIF table_name = 'material' THEN
        INSERT INTO tipo_item (tipo_item)
        VALUES ('c')  
        RETURNING id_item INTO new_id_item;

        INSERT INTO Craftavel (id_craftavel, tipo_craftavel)
        VALUES (new_id_item, 'm');
        NEW.id_material := new_id_item;
        
    END IF;

    

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER before_insert_consumivel_trigger
BEFORE INSERT ON consumivel
FOR EACH ROW
EXECUTE FUNCTION before_insert_generic();

CREATE TRIGGER before_insert_livro_trigger
BEFORE INSERT ON livro
FOR EACH ROW
EXECUTE FUNCTION before_insert_generic();

CREATE TRIGGER before_insert_item_missao_trigger
BEFORE INSERT ON item_missao
FOR EACH ROW
EXECUTE FUNCTION before_insert_generic();

CREATE TRIGGER before_insert_material_trigger
BEFORE INSERT ON material
FOR EACH ROW
EXECUTE FUNCTION before_insert_generic();

CREATE TRIGGER before_insert_armadura_trigger
BEFORE INSERT ON armadura
FOR EACH ROW
EXECUTE FUNCTION before_insert_generic();


INSERT INTO Consumivel (
    nome, 
    descricao, 
    preco_venda, 
    saude_restaurada, 
    magia_restaurada, 
    saude_maxima, 
    magia_maxima
)
VALUES
-- Poção que recupera vida
('Poção de Vida', 'Recupera 50 pontos de vida.', 100, 50, 0, 0, 0),

-- Poção que aumenta a saúde máxima
('Elixir da Vida', 'Aumenta a saúde máxima em 20 pontos.', 300, 0, 0, 20, 0),

-- Poção que recupera magia
('Poção de Magia', 'Recupera 40 pontos de magia.', 120, 0, 40, 0, 0),

-- Poção que aumenta a magia máxima
('Elixir da Magia', 'Aumenta a magia máxima em 15 pontos.', 350, 0, 0, 0, 15);

INSERT INTO item_a_venda( id_item, preco_compra, nivel_minimo)
VALUES (1,10,1), (2,50,5), (3,10,1), (4,50,5);