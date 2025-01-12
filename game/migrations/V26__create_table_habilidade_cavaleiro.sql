
CREATE TABLE Habilidade_Cavaleiro (
    id_cavaleiro INTEGER,
    id_habilidade INTEGER,
    slot INTEGER NOT NULL,
    PRIMARY KEY (id_cavaleiro, id_habilidade, slot)
);
 
ALTER TABLE Habilidade_Cavaleiro ADD CONSTRAINT FK_Habilidade_Cavaleiro_2
    FOREIGN KEY (id_cavaleiro)
    REFERENCES Cavaleiro (id_cavaleiro);
 
ALTER TABLE Habilidade_Cavaleiro ADD CONSTRAINT FK_Habilidade_Cavaleiro_3
    FOREIGN KEY (id_habilidade)
    REFERENCES Habilidade (id_habilidade);