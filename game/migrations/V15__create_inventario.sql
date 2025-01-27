CREATE TABLE Inventario (
    id_player INTEGER PRIMARY KEY,
    dinheiro INTEGER NOT NULL
);
 
ALTER TABLE Inventario ADD CONSTRAINT FK_Inventario_1
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);


CREATE OR REPLACE FUNCTION after_player_insert_function()
RETURNS TRIGGER AS $$
BEGIN
    -- Insere um registro na tabela inventario para o novo player
    INSERT INTO inventario (id_player, dinheiro)
    VALUES (NEW.id_player, 200);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_player_insert
AFTER INSERT ON player
FOR EACH ROW
EXECUTE FUNCTION after_player_insert_function();


