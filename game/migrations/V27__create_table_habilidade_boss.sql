
CREATE TABLE Habilidade_Boss (
    id_boss INTEGER,
    id_habilidade INTEGER,
    PRIMARY KEY (id_boss, id_habilidade)
);
 
ALTER TABLE Habilidade_Boss ADD CONSTRAINT FK_Habilidade_Boss_2
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);
 
ALTER TABLE Habilidade_Boss ADD CONSTRAINT FK_Habilidade_Boss_3
    FOREIGN KEY (id_habilidade)
    REFERENCES Habilidade (id_habilidade);