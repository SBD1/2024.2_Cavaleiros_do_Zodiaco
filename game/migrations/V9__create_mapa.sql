CREATE TABLE Saga (
    id_saga SERIAL PRIMARY KEY,
    id_missao_requisito INTEGER,
    nome VARCHAR UNIQUE NOT NULL,
    descricao VARCHAR,
    nivel_recomendado INTEGER NOT NULL
);
 
CREATE TABLE Casa (
    id_casa SERIAL PRIMARY KEY,
    id_saga INTEGER NOT NULL,
    id_missao_requisito INTEGER,
    nome VARCHAR NOT NULL,
    descricao VARCHAR,
    nivel_recomendado INTEGER NOT NULL
);

CREATE TABLE Sala (
    id_sala SERIAL PRIMARY KEY,
    id_casa INTEGER NOT NULL,
    nome VARCHAR NOT NULL,
    id_sala_norte INTEGER,
    id_sala_sul INTEGER,
    id_sala_leste INTEGER,
    id_sala_oeste INTEGER
);
 

CREATE TABLE Sala_Segura (
    id_sala INTEGER PRIMARY KEY
);
 



ALTER TABLE Saga ADD CONSTRAINT FK_Saga_2
    FOREIGN KEY (id_missao_requisito)
    REFERENCES Missao (id_missao);
 

ALTER TABLE Casa ADD CONSTRAINT FK_Casa_2
    FOREIGN KEY (id_saga)
    REFERENCES Saga (id_saga);
 
ALTER TABLE Casa ADD CONSTRAINT FK_Casa_3
    FOREIGN KEY (id_missao_requisito)
    REFERENCES Missao (id_missao);
 

ALTER TABLE Sala ADD CONSTRAINT FK_Sala_2
    FOREIGN KEY (id_casa)
    REFERENCES Casa (id_casa);

ALTER TABLE Sala_Segura ADD CONSTRAINT FK_Sala_Segura_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);