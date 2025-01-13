CREATE TABLE Parte_Corpo (
    id_parte_corpo enum_parte_corpo PRIMARY KEY,
    nome VARCHAR UNIQUE NOT NULL,
    defesa_magica INTEGER NOT NULL,
    defesa_fisica INTEGER NOT NULL,
    chance_acerto INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL
);