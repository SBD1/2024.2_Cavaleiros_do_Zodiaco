CREATE OR REPLACE FUNCTION before_insert_consumivel()
RETURNS TRIGGER AS $$
DECLARE
    new_id_item INTEGER;
BEGIN
    -- Insere um registro em tipo_item e captura o ID gerado automaticamente
    INSERT INTO tipo_item (tipo_item)
    VALUES ('c')
    RETURNING id_item INTO new_id_item;

    -- Atribui o ID gerado ao campo id_item do registro a ser inserido na tabela consumivel
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

INSERT INTO item_a_venda( id_item, preco_compra, nivel_minimo)
VALUES (1,10,1), (2,50,5), (3,10,1), (4,50,5);