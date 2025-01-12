CREATE TABLE IF NOT EXISTS Elemento (
    id_elemento INTEGER PRIMARY KEY,
    nome VARCHAR UNIQUE,
    descricao VARCHAR,
    fraco_contra INTEGER,
    forte_contra INTEGER
);