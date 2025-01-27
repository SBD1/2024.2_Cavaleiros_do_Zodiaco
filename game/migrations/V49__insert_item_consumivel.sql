CREATE OR REPLACE FUNCTION before_insert_consumivel()
RETURNS TRIGGER AS $$
DECLARE
    new_id_item INTEGER;
BEGIN
    -- Obter o maior valor atual de id_item em tipo_item e incrementá-lo
    SELECT COALESCE(MAX(id_item), 0) + 1 INTO new_id_item FROM tipo_item;

    -- Inserir na tabela tipo_item com o novo id_item
    INSERT INTO tipo_item (id_item, tipo_item)
    VALUES (new_id_item, 'c');

    -- Atribuir o novo id_item ao registro a ser inserido na tabela consumivel
    NEW.id_item := new_id_item;

    -- Retorna o registro atualizado
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_consumivel_trigger
BEFORE INSERT ON consumivel
FOR EACH ROW
EXECUTE FUNCTION before_insert_consumivel();

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