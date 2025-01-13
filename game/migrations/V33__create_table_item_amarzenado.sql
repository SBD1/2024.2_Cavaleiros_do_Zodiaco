
CREATE TABLE Item_Armazenado (
    id_inventario INTEGER,
    id_item INTEGER,
    quantidade INTEGER NOT NULL,
    PRIMARY KEY (id_inventario, id_item)
);
 
ALTER TABLE Item_Armazenado ADD CONSTRAINT FK_Item_Armazenado_2
    FOREIGN KEY (id_inventario)
    REFERENCES Inventario (id_player);
 
ALTER TABLE Item_Armazenado ADD CONSTRAINT FK_Item_Armazenado_3
    FOREIGN KEY (id_item)
    REFERENCES Tipo_Item (id_item);