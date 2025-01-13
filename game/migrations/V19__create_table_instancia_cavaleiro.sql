/* brModelo: */

CREATE TABLE Instancia_Cavaleiro (
    id_instancia_cavaleiro SERIAL,
    id_cavaleiro INTEGER NOT NULL,
    id_party INTEGER,
    nivel INTEGER NOT NULL,
    xp_atual INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    hp_atual INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL,
    PRIMARY KEY (id_cavaleiro, id_instancia_cavaleiro)
);
 
ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_2
    FOREIGN KEY (id_cavaleiro)
    REFERENCES Cavaleiro (id_cavaleiro);
 
ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_3
    FOREIGN KEY (id_party)
    REFERENCES Party (id_player);