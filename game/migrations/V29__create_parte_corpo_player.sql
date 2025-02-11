-- 29
CREATE TABLE Parte_Corpo_Player (
    id_player INTEGER,
    parte_corpo enum_parte_corpo,
    defesa_fisica INTEGER,
    defesa_magica INTEGER,
    chance_acerto INTEGER,
    chance_acerto_critico INTEGER,
    PRIMARY KEY (id_player, parte_corpo)
);
 
ALTER TABLE Parte_Corpo_Player ADD CONSTRAINT FK_Parte_Corpo_Player_2
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);
 
ALTER TABLE Parte_Corpo_Player ADD CONSTRAINT FK_Parte_Corpo_Player_3
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);