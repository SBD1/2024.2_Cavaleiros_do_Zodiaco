CREATE TYPE enum_tipo_personagem as ENUM ('p', 'c', 'i', 'b'); -- p = personagem , c = cavaleiro , i = inimigo , b = boss 

CREATE TABLE Tipo_Personagem (
    id_personagem SERIAL PRIMARY KEY,
    tipo_personagem enum_tipo_personagem NOT NULL
);


CREATE TABLE Player (
    id_player SERIAL PRIMARY KEY,
    id_elemento INTEGER,
    nome VARCHAR UNIQUE NOT NULL,
    nivel INTEGER NOT NULL,
    xp_atual INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    hp_atual INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL
);

ALTER TABLE Player ADD CONSTRAINT FK_Player_2
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);

ALTER TABLE Player ADD CONSTRAINT FK_Player_3
    FOREIGN KEY (id_player)
    REFERENCES Tipo_Personagem (id_personagem);