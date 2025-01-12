
CREATE TABLE Habilidade_Inimigo (
    id_habilidade INTEGER,
    id_player INTEGER,
    PRIMARY KEY (id_habilidade, id_player)
);
 
ALTER TABLE Habilidade_Inimigo ADD CONSTRAINT FK_Habilidade_Inimigo_2
    FOREIGN KEY (id_habilidade)
    REFERENCES Habilidade (id_habilidade);
 
ALTER TABLE Habilidade_Inimigo ADD CONSTRAINT FK_Habilidade_Inimigo_3
    FOREIGN KEY (id_player)
    REFERENCES Inimigo (id_inimigo);