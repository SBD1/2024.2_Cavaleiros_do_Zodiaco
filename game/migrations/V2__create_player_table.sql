CREATE TABLE Player (
    id_player SERIAL PRIMARY KEY,
    id_elemento INTEGER,
    nome VARCHAR UNIQUE NOT NULL,
    nivel INTEGER NOT NULL,
    xp_acumulado INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    hp_atual INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico_base INTEGER NOT NULL,
    ataque_magico_base INTEGER NOT NULL,
    id_sala_safe INTEGER NOT NULL
);
 
ALTER TABLE Player ADD CONSTRAINT FK_Player_2
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);