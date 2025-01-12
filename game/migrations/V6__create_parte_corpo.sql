CREATE TABLE Parte_Corpo (
    parte_corpo ENUM PRIMARY KEY,
    nome VARCHAR NOT NULL,
    defesa_magica INTEGER NOT NULL,
    defesa_fisica INTEGER NOT NULL,
    chance_acerto INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL
);