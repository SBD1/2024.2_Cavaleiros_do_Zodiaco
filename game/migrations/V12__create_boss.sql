/* brModelo: */

CREATE TABLE Boss (
    id_boss SERIAL PRIMARY KEY,
    id_sala INTEGER,
    id_item_missao INTEGER,
    nome VARCHAR,
    nivel INTEGER,
    xp_acumulado INTEGER,
    hp_max INTEGER,
    hp_atual INTEGER,
    magia_max INTEGER,
    magia_atual INTEGER,
    velocidade INTEGER,
    ataque_fisico INTEGER,
    ataque_magico INTEGER,
    dinheiro INTEGER,
    fala_inicio VARCHAR,
    fala_derrotar_player VARCHAR,
    fala_derrotado VARCHAR,
    fala_condicao VARCHAR
);
 
ALTER TABLE Boss ADD CONSTRAINT FK_Boss_1
    FOREIGN KEY (id_boss)
    REFERENCES Tipo_Personagem (id_personagem);

ALTER TABLE Boss ADD CONSTRAINT FK_Boss_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);
 
ALTER TABLE Boss ADD CONSTRAINT FK_Boss_3
    FOREIGN KEY (id_item_missao)
    REFERENCES Item_Missao (id_item);