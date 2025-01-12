
CREATE TABLE Item_grupo_inimigo_dropa (
    id_item INTEGER,
    id_grupo_inimigo INTEGER,
    quantidade INTEGER NOT NULL,
    PRIMARY KEY (id_item, id_grupo_inimigo)
);
 
ALTER TABLE Item_grupo_inimigo_dropa ADD CONSTRAINT FK_Item_grupo_inimigo_dropa_2
    FOREIGN KEY (id_item)
    REFERENCES Tipo_Item (id_item);
 
ALTER TABLE Item_grupo_inimigo_dropa ADD CONSTRAINT FK_Item_grupo_inimigo_dropa_3
    FOREIGN KEY (id_grupo_inimigo)
    REFERENCES Grupo_inimigo (id_grupo);