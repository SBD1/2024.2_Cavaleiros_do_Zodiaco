CREATE TABLE Classe (
    id_classe SERIAL PRIMARY KEY,
    nome VARCHAR UNIQUE NOT NULL,
    descricao VARCHAR
);