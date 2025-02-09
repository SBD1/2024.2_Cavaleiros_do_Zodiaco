/* brModelo: */

CREATE TABLE Receita (
    id_item_gerado INTEGER PRIMARY KEY,
    descricao VARCHAR,
    nivel_minimo INTEGER,
    alma_armadura INTEGER
);
 
ALTER TABLE Receita ADD CONSTRAINT FK_Receita_2
    FOREIGN KEY (id_item_gerado)
    REFERENCES Tipo_Item (id_item);