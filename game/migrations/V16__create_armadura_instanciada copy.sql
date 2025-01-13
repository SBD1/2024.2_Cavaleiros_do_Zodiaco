CREATE TABLE Armadura_Instancia (
    id_armadura INTEGER,
    id_parte_corpo_armadura enum_parte_corpo,
    id_instancia SERIAL,
    id_inventario INTEGER,
    raridade_armadura INTEGER NOT NULL,
    defesa_magica INTEGER NOT NULL,
    defesa_fisica INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL, 
    durabilidade_max INTEGER NOT NULL,
    preco_venda INTEGER NOT NULL,
    PRIMARY KEY (id_armadura, id_instancia, id_parte_corpo_armadura)
);
 
ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_2
    FOREIGN KEY (id_armadura, id_parte_corpo_armadura)
    REFERENCES Armadura (id_armadura, id_parte_corpo);
 
ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_3
    FOREIGN KEY (id_inventario)
    REFERENCES Inventario (id_player);