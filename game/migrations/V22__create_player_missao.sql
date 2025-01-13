CREATE TABLE Player_Missao (
    id_player INTEGER,
    id_missao INTEGER,
    status_missao enum_status_missao NOT NULL,
    PRIMARY KEY (id_player, id_missao)
);
 
ALTER TABLE Player_Missao ADD CONSTRAINT FK_Player_Missao_2
    FOREIGN KEY (id_missao)
    REFERENCES Missao (id_missao);
 
ALTER TABLE Player_Missao ADD CONSTRAINT FK_Player_Missao_3
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);