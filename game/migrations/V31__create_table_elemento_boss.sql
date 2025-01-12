
CREATE TABLE Elemento_Boss (
    id_elemento INTEGER,
    id_boss INTEGER,
    PRIMARY KEY (id_boss, id_elemento)
);
 
ALTER TABLE Elemento_Boss ADD CONSTRAINT FK_Elemento_Boss_1
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);
 
ALTER TABLE Elemento_Boss ADD CONSTRAINT FK_Elemento_Boss_2
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);