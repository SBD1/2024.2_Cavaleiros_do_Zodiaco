CREATE TABLE Instancia_Cavaleiro (
    id_cavaleiro INTEGER,
    id_player INTEGER,
    id_party INTEGER,
    nivel INTEGER,
    tipo_armadura INTEGER,
    xp_atual INTEGER,
    hp_max INTEGER,
    magia_max INTEGER,
    hp_atual INTEGER,
    magia_atual INTEGER,
    velocidade INTEGER,
    ataque_fisico INTEGER,
    ataque_magico INTEGER,
    PRIMARY KEY (id_cavaleiro, id_player)
);
 
ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_2
    FOREIGN KEY (id_cavaleiro)
    REFERENCES Cavaleiro (id_cavaleiro);
 
ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_3
    FOREIGN KEY (id_party)
    REFERENCES Party (id_player);
 
ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_4
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);