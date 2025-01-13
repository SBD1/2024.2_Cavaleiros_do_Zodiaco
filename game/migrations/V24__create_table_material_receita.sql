/* brModelo: */

CREATE TABLE Material_Receita (
    id_receita INTEGER,
    id_material INTEGER,
    quantidade INTEGER NOT NULL,
    PRIMARY KEY (id_receita, id_material)
);
 
ALTER TABLE Material_Receita ADD CONSTRAINT FK_Material_Receita_2
    FOREIGN KEY (id_material)
    REFERENCES Material (id_material);
 
ALTER TABLE Material_Receita ADD CONSTRAINT FK_Material_Receita_3
    FOREIGN KEY (id_receita)
    REFERENCES Receita (id_item_gerado);