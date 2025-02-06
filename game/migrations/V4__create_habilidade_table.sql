CREATE TABLE Habilidade (
    id_habilidade SERIAL PRIMARY KEY,
    classe_habilidade INTEGER,
    elemento_habilidade INTEGER,
    nome VARCHAR,
    custo INTEGER,
    dano INTEGER,
    descricao VARCHAR,
    frase_uso VARCHAR,
    nivel_necessario INTEGER
);
 
ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_2
    FOREIGN KEY (elemento_habilidade)
    REFERENCES Elemento (id_elemento);
 
ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_3
    FOREIGN KEY (classe_habilidade)
    REFERENCES Classe (id_classe);