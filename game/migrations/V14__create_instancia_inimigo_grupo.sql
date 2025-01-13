CREATE TABLE Grupo_inimigo (
    id_grupo SERIAL PRIMARY KEY,
    id_sala INTEGER
);
 

CREATE TABLE Instancia_Inimigo (
    id_instancia SERIAL,
    id_inimigo INTEGER,
    id_grupo INTEGER,
    hp_atual INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    defesa_fisica_bonus INTEGER,
    defesa_magica_bonus INTEGER,
    PRIMARY KEY (id_inimigo, id_instancia)
);
 
ALTER TABLE Instancia_Inimigo ADD CONSTRAINT FK_Instancia_Inimigo_2
    FOREIGN KEY (id_inimigo)
    REFERENCES Inimigo (id_inimigo);
 
ALTER TABLE Instancia_Inimigo ADD CONSTRAINT FK_Instancia_Inimigo_3
    FOREIGN KEY (id_grupo)
    REFERENCES Grupo_inimigo (id_grupo);

ALTER TABLE Grupo_inimigo ADD CONSTRAINT FK_Grupo_inimigo_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);