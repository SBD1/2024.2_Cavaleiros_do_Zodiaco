
CREATE TABLE Npc_Ferreiro (
    id_npc_ferreiro INTEGER PRIMARY KEY,
    id_sala INTEGER NOT NULL,
    id_missao_desbloqueia INTEGER NOT NULL,
    nome VARCHAR NOT NULL,
    descricao VARCHAR,
    dialogo_inicial VARCHAR,
    dialogo_reparar VARCHAR,
    dialogo_upgrade VARCHAR
);
 

CREATE TABLE Npc_Quest (
    id_npc_quest INTEGER PRIMARY KEY,
    id_sala INTEGER NOT NULL,
    nome VARCHAR NOT NULL,
    descricao VARCHAR,
    dialogo_inicial VARCHAR,
    dialogo_recusa VARCHAR
);
 

CREATE TABLE Npc_Mercador (
    id_npc_mercador INTEGER PRIMARY KEY,
    id_sala INTEGER NOT NULL,
    nome VARCHAR NOT NULL,
    descricao VARCHAR,
    dialogo_inicial VARCHAR,
    dialogo_vender VARCHAR,
    dialogo_comprar VARCHAR,
    dialogo_sair VARCHAR
);
 


ALTER TABLE Npc_Ferreiro ADD CONSTRAINT FK_Npc_Ferreiro_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);
 
ALTER TABLE Npc_Ferreiro ADD CONSTRAINT FK_Npc_Ferreiro_3
    FOREIGN KEY (id_missao_desbloqueia)
    REFERENCES Missao (id_missao);

ALTER TABLE Npc_Quest ADD CONSTRAINT FK_Npc_Quest_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);

ALTER TABLE Npc_Mercador ADD CONSTRAINT FK_Npc_Mercador_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);