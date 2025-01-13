CREATE TABLE IF NOT EXISTS Elemento (
    id_elemento SERIAL PRIMARY KEY,
    nome VARCHAR UNIQUE NOT NULL,
    descricao VARCHAR,
    fraco_contra INTEGER,
    forte_contra INTEGER
);