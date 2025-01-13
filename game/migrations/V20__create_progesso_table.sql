-- SQLBook: Code
/* brModelo: */

CREATE TABLE Progresso_Player (
    id_player INTEGER ,
    id_boss INTEGER,
    id_cavaleiro INTEGER ,
    status_derrotado BOOLEAN,
    PRIMARY KEY (id_player, id_boss)
);
 
ALTER TABLE Progresso_Player ADD CONSTRAINT FK_Progresso_Player_2
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);
 
ALTER TABLE Progresso_Player ADD CONSTRAINT FK_Progresso_Player_3
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);
 
ALTER TABLE Progresso_Player ADD CONSTRAINT FK_Progresso_Player_4
    FOREIGN KEY (id_cavaleiro)
    REFERENCES Cavaleiro (id_cavaleiro);