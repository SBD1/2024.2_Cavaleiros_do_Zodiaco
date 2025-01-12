CREATE TABLE Player (
    id_player INTEGER PRIMARY KEY,
    id_elemento INTEGER,
    nome VARCHAR UNIQUE,
    nivel INTEGER,
    xp_acumulado INTEGER,
    hp_max INTEGER,
    magia_max INTEGER,
    hp_atual INTEGER,
    magia_atual INTEGER,
    velocidade INTEGER,
    ataque_fisico_base INTEGER,
    ataque_magico_base INTEGER,
    id_sala_safe INTEGER
);
 
ALTER TABLE Player ADD CONSTRAINT FK_Player_2
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);