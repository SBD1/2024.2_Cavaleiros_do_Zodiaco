CREATE TABLE Inimigo (
    id_inimigo SERIAL PRIMARY KEY,
    id_classe INTEGER NOT NULL,
    id_elemento INTEGER NOT NULL,
    nome VARCHAR NOT NULL,
    nivel INTEGER NOT NULL,
    xp_acumulado INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL,
    dinheiro INTEGER NOT NULL,
    fala_inicio VARCHAR
);
 
ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_1
    FOREIGN KEY (id_inimigo)
    REFERENCES Tipo_Personagem (id_personagem);
 
ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_2
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);
 
ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_3
    FOREIGN KEY (id_classe)
    REFERENCES Classe (id_classe);