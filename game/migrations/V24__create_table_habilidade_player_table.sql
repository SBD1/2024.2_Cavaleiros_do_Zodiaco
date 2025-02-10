
CREATE TABLE Habilidade_Player (
    id_player INTEGER,
    id_habilidade INTEGER,
    slot INTEGER NOT NULL,
    PRIMARY KEY (id_player, id_habilidade, slot),
    CONSTRAINT unique_habilidade_por_player UNIQUE (id_player, id_habilidade)
);
 
ALTER TABLE Habilidade_Player ADD CONSTRAINT FK_Habilidade_Player_2
    FOREIGN KEY (id_habilidade)
    REFERENCES Habilidade (id_habilidade);
 
ALTER TABLE Habilidade_Player ADD CONSTRAINT FK_Habilidade_Player_3
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);