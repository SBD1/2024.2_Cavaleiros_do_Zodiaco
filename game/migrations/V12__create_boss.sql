CREATE TABLE Boss (
    id_boss SERIAL PRIMARY KEY,
    id_sala INTEGER NOT NULL,
    nome INTEGER NOT NULL,
    nivel INTEGER NOT NULL,
    xp_acumulado INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    hp_atual INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico_base INTEGER NOT NULL,
    ataque_magico_base INTEGER NOT NULL,
    dinheiro INTEGER NOT NULL,
    fala_inicio VARCHAR,
    fala_derrotar_player VARCHAR,
    fala_derrotado VARCHAR,
    fala_condicao VARCHAR
);
 
ALTER TABLE Boss ADD CONSTRAINT FK_Boss_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);