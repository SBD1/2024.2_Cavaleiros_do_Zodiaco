CREATE TABLE Item_a_venda (
    id_item INTEGER PRIMARY KEY,
    preco_compra INTEGER NOT NULL,
    nivel_minimo INTEGER NOT NULL
);
 
ALTER TABLE Item_a_venda ADD CONSTRAINT FK_Item_a_venda_2
    FOREIGN KEY (id_item)
    REFERENCES Tipo_Item (id_item);