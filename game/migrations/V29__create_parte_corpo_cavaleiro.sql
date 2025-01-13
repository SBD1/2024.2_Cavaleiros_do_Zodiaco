/* brModelo: */

CREATE TABLE Parte_Corpo_Cavaleiro (
    id_cavaleiro INTEGER,
    parte_corpo enum_parte_corpo,
    id_instancia_cavaleiro INTEGER NOT NULL,
    defesa_fisica_bonus INTEGER NOT NULL,
    defesa_magico_bonus INTEGER NOT NULL,
    chance_acerto_base INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL,
    PRIMARY KEY (id_cavaleiro, parte_corpo)
);
 
ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_2
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);
 
ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_3
    FOREIGN KEY (id_instancia_cavaleiro, id_cavaleiro)
    REFERENCES Instancia_Cavaleiro (id_instancia_cavaleiro, id_cavaleiro);