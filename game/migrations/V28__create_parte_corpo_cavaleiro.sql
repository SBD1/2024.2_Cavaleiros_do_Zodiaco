CREATE TABLE Parte_Corpo_Cavaleiro (
    id_cavaleiro INTEGER,
    parte_corpo enum_parte_corpo,
    id_player INTEGER,
    defesa_fisica INTEGER,
    defesa_magico_bonus INTEGER,
    chance_acerto INTEGER,
    chance_acerto_critico INTEGER,
    PRIMARY KEY (id_cavaleiro, parte_corpo, id_player)
);
 
ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_2
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);
 
ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_3
    FOREIGN KEY (id_cavaleiro, id_player)
    REFERENCES Instancia_Cavaleiro (id_cavaleiro, id_player);