CREATE TABLE Missao (
    id_missao SERIAL PRIMARY KEY,
    id_missao_anterior INTEGER,
    item_necessario INTEGER NOT NULL,
    nome INTEGER UNIQUE NOT NULL,
    dialogo_inicial VARCHAR,
    dialogo_durante VARCHAR,
    dialogo_completa VARCHAR
);
 
ALTER TABLE Missao ADD CONSTRAINT FK_Missao_2
    FOREIGN KEY (id_missao_anterior)
    REFERENCES Missao (id_missao);
 
ALTER TABLE Missao ADD CONSTRAINT FK_Missao_3
    FOREIGN KEY (item_necessario)
    REFERENCES Item_Missao (id_item);