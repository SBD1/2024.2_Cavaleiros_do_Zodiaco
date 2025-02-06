CREATE TABLE Cavaleiro (
    id_cavaleiro SERIAL PRIMARY KEY,
    id_classe INTEGER NOT NULL,
    id_elemento INTEGER NOT NULL,
    nome VARCHAR UNIQUE NOT NULL,
    nivel INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL
);
 




ALTER TABLE Cavaleiro ADD CONSTRAINT FK_Cavaleiro_2
    FOREIGN KEY (id_classe)
    REFERENCES Classe (id_classe);
 
ALTER TABLE Cavaleiro ADD CONSTRAINT FK_Cavaleiro_3
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);