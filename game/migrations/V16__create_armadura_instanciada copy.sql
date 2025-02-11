CREATE TABLE Armadura_Instancia (
    id_armadura INTEGER,
    id_parte_corpo_armadura enum_parte_corpo,
    id_instancia SERIAL,
    id_inventario INTEGER,
    raridade_armadura VARCHAR NOT NULL,
    defesa_magica INTEGER NOT NULL,
    defesa_fisica INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL, 
    durabilidade_atual INTEGER NOT NULL,
    PRIMARY KEY (id_armadura, id_instancia, id_parte_corpo_armadura)
);
 
ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_2
    FOREIGN KEY (id_armadura, id_parte_corpo_armadura)
    REFERENCES Armadura (id_armadura, id_parte_corpo);
 
ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_3
    FOREIGN KEY (id_inventario)
    REFERENCES Inventario (id_player);


CREATE TABLE Armadura_Equipada (
    id_player INTEGER,
    id_armadura INTEGER,
    id_armadura_instanciada INTEGER,
    id_parte_corpo_armadura enum_parte_corpo,
    PRIMARY KEY (id_player, id_armadura, id_armadura_instanciada, id_parte_corpo_armadura)
);
 
ALTER TABLE Armadura_Equipada ADD CONSTRAINT FK_Armadura_Equipada_2
    FOREIGN KEY (id_armadura, id_armadura_instanciada, id_parte_corpo_armadura)
    REFERENCES Armadura_Instancia (id_armadura, id_instancia, id_parte_corpo_armadura);
 
ALTER TABLE Armadura_Equipada ADD CONSTRAINT FK_Armadura_Equipada_3
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);