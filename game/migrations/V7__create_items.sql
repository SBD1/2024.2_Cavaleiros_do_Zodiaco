CREATE TABLE Tipo_Item (
    id_item SERIAL PRIMARY KEY,
    tipo_item enum_tipo_item NOT NULL
);

CREATE TABLE Armadura (
    id_armadura INTEGER,
    id_parte_corpo enum_parte_corpo,
    nome VARCHAR NOT NULL,
    descricao VARCHAR,
    raridade_armadura VARCHAR NOT NULL,
    defesa_magica INTEGER,
    defesa_fisica INTEGER,
    ataque_magico INTEGER,
    ataque_fisico INTEGER,
    durabilidade_max INTEGER,
    preco_venda INTEGER,
    PRIMARY KEY (id_armadura, id_parte_corpo)
);
 
CREATE TABLE Material (
    id_material INTEGER PRIMARY KEY,
    nome VARCHAR UNIQUE NOT NULL,
    preco_venda INTEGER NOT NULL,
    descricao VARCHAR
);
 
CREATE TABLE Item_Missao (
    id_item INTEGER PRIMARY KEY,
    nome VARCHAR UNIQUE NOT NULL,
    descricao VARCHAR
);
 
CREATE TABLE Consumivel (
    id_item INTEGER PRIMARY KEY,
    nome VARCHAR UNIQUE NOT NULL,
    descricao VARCHAR,
    preco_venda INTEGER NOT NULL,
    saude_restaurada INTEGER,
    magia_restaurada INTEGER,
    saude_maxima INTEGER,
    magia_maxima INTEGER
);

CREATE TABLE Livro (
    id_item INTEGER PRIMARY KEY,
    id_habilidade INTEGER,
    nome VARCHAR UNIQUE NOT NULL,
    descricao VARCHAR,
    preco_venda INTEGER NOT NULL
);

ALTER TABLE Armadura ADD CONSTRAINT FK_Armadura_2
    FOREIGN KEY (id_armadura)
    REFERENCES Tipo_Item (id_item);
 
ALTER TABLE Armadura ADD CONSTRAINT FK_Armadura_3
    FOREIGN KEY (id_parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);

ALTER TABLE Material ADD CONSTRAINT FK_Material_2
    FOREIGN KEY (id_material)
    REFERENCES Tipo_Item (id_item);

ALTER TABLE Item_Missao ADD CONSTRAINT FK_Item_Missao_2
    FOREIGN KEY (id_item)
    REFERENCES Tipo_Item (id_item);

ALTER TABLE Livro ADD CONSTRAINT FK_Livro_2
    FOREIGN KEY (id_item)
    REFERENCES Tipo_Item (id_item);
 
ALTER TABLE Livro ADD CONSTRAINT FK_Livro_3
    FOREIGN KEY (id_habilidade)
    REFERENCES Habilidade (id_habilidade);

ALTER TABLE Consumivel ADD CONSTRAINT FK_Consumivel_2
    FOREIGN KEY (id_item)
    REFERENCES Tipo_Item (id_item);