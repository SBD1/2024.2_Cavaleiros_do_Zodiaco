CREATE TABLE Inventario (
    id_player INTEGER PRIMARY KEY,
    dinheiro INTEGER NOT NULL,
    alma_armadura INTEGER
);
 
ALTER TABLE Inventario ADD CONSTRAINT FK_Inventario_1
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);




