CREATE TABLE Santuario (
    id_santuario SERIAL PRIMARY KEY,
    id_missao_requisito INTEGER,
    id_missao_proximo_santuario INTEGER,
    nome VARCHAR UNIQUE NOT NULL,
    descricao VARCHAR,
    nivel_recomendado INTEGER NOT NULL
);
 
CREATE TABLE Casa (
    id_casa SERIAL PRIMARY KEY,
    id_santuario INTEGER NOT NULL,
    id_missao_requisito INTEGER,
    id_missao_proxima_casa INTEGER,
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
 


ALTER TABLE Santuario ADD CONSTRAINT FK_Santuario_2
    FOREIGN KEY (id_missao_requisito)
    REFERENCES Missao (id_missao);
 
ALTER TABLE Santuario ADD CONSTRAINT FK_Santuario_3
    FOREIGN KEY (id_missao_proximo_santuario)
    REFERENCES Missao (id_missao);

ALTER TABLE Casa ADD CONSTRAINT FK_Casa_2
    FOREIGN KEY (id_santuario)
    REFERENCES Santuario (id_santuario);
 
ALTER TABLE Casa ADD CONSTRAINT FK_Casa_3
    FOREIGN KEY (id_missao_requisito)
    REFERENCES Missao (id_missao);
 
ALTER TABLE Casa ADD CONSTRAINT FK_Casa_4
    FOREIGN KEY (id_missao_proxima_casa)
    REFERENCES Missao (id_missao);

ALTER TABLE Sala ADD CONSTRAINT FK_Sala_2
    FOREIGN KEY (id_casa)
    REFERENCES Casa (id_casa);