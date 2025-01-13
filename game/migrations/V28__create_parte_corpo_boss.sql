/* brModelo: */

CREATE TABLE Parte_Corpo_Boss (
    id_boss INTEGER,
    parte_corpo enum_parte_corpo,
    defesa_fisica INTEGER NOT NULL,
    defesa_magica INTEGER NOT NULL,
    chance_acerto_base INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL,
    PRIMARY KEY (id_boss, parte_corpo)
);
 
ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_2
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);
 
ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_3
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);