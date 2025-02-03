
CREATE TABLE Npc_Ferreiro (
    id_npc_ferreiro SERIAL PRIMARY KEY,
    id_sala INTEGER NOT NULL,
    id_missao_desbloqueia INTEGER NOT NULL,
    nome VARCHAR NOT NULL,
    descricao VARCHAR,
    dialogo_inicial VARCHAR,
    dialogo_reparar VARCHAR,
    dialogo_upgrade VARCHAR,
    dialogo_desmanchar VARCHAR,
    dialogo_sair VARCHAR
);


CREATE TABLE Custos_ferreiro (
    id SERIAL PRIMARY KEY,
    tipo_acao VARCHAR,
    raridade VARCHAR,
    durabilidade_min INT DEFAULT NULL,
    durabilidade_max INT DEFAULT NULL,
    custo_alma INT
);

INSERT INTO public.custos_ferreiro (tipo_acao, raridade, durabilidade_min, durabilidade_max, custo_alma) VALUES 
('restaurar', 'Bronze', 75, 100, 5),
('restaurar', 'Bronze', 50, 74, 10),
('restaurar', 'Bronze', 25, 49, 15),
('restaurar', 'Bronze', 0, 24, 20),

('restaurar', 'Prata', 75, 100, 10),
('restaurar', 'Prata', 50, 74, 20),
('restaurar', 'Prata', 25, 49, 30),
('restaurar', 'Prata', 0, 24, 40),

('restaurar', 'Ouro', 75, 100, 25),
('restaurar', 'Ouro', 50, 74, 40),
('restaurar', 'Ouro', 25, 49, 60),
('restaurar', 'Ouro', 0, 24, 80);

INSERT INTO public.custos_ferreiro (tipo_acao, raridade, custo_alma) VALUES 
('melhorar', 'Bronze', 20),
('melhorar', 'Prata', 50);

INSERT INTO public.custos_ferreiro (tipo_acao, raridade, custo_alma) VALUES 
('desmanchar', 'Bronze', 1),
('desmanchar', 'Prata', 5),
('desmanchar', 'Ouro', 15);

CREATE TABLE material_necessario_ferreiro (
    id_material INTEGER,
    id_custo_ferreiro INTEGER,
    quantidade INTEGER,
    PRIMARY KEY (id_material, id_custo_ferreiro)
);
 
ALTER TABLE material_necessario_ferreiro ADD CONSTRAINT FK_material_necessario_ferreiro_2
    FOREIGN KEY (id_material)
    REFERENCES Material (id_material);
 
ALTER TABLE material_necessario_ferreiro ADD CONSTRAINT FK_material_necessario_ferreiro_3
    FOREIGN KEY (id_custo_ferreiro)
    REFERENCES Custos_ferreiro (id);

CREATE TABLE Npc_Quest (
    id_npc_quest SERIAL PRIMARY KEY,
    id_sala INTEGER NOT NULL,
    nome VARCHAR NOT NULL,
    descricao VARCHAR,
    dialogo_inicial VARCHAR,
    dialogo_recusa VARCHAR
);
 

CREATE TABLE Npc_Mercador (
    id_npc_mercador SERIAL PRIMARY KEY,
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