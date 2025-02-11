## DDL

## Introdução

No Módulo 2, exploramos as principais linguagens utilizadas para definir, manipular e consultar dados em um banco de dados relacional. Essas linguagens são essenciais para a criação, manutenção e extração de informações de forma eficiente. Abaixo, destacamos os três principais conceitos abordados:

### Data Definition Language (DDL)

A Linguagem de Definição de Dados (DDL) é responsável pela estrutura do banco de dados. Comandos DDL permitem criar, modificar e excluir objetos como tabelas, índices, views e esquemas.

### Criação da Tabela Elemento

Define os elementos do jogo (Fogo, Água, Terra etc.), usados para determinar vantagens e desvantagens no combate.

<details>
    <sumary>Clique aqui para ver as migrações</sumary>

    ```sql
    CREATE TABLE IF NOT EXISTS Elemento (
        id_elemento SERIAL PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        descricao VARCHAR,
        fraco_contra INTEGER,
        forte_contra INTEGER
    );
    ```

</details>

### Criação da Tabela Player

Armazena os dados dos jogadores, incluindo atributos como nível, HP e MP.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Player (
        id_player SERIAL PRIMARY KEY,
        id_elemento INTEGER,
        nome VARCHAR UNIQUE NOT NULL,
        nivel INTEGER NOT NULL,
        xp_atual INTEGER NOT NULL,
        hp_max INTEGER NOT NULL,
        magia_max INTEGER NOT NULL,
        hp_atual INTEGER NOT NULL,
        magia_atual INTEGER NOT NULL,
        velocidade INTEGER NOT NULL,
        ataque_fisico_base INTEGER NOT NULL,
        ataque_magico_base INTEGER NOT NULL
    );
    ```
</details>

### Definição da Chave Estrangeira para Player

Relaciona cada jogador a um elemento.

<details>
    <sumary>Migrações</sumary>

    ```sql
    ALTER TABLE Player ADD CONSTRAINT FK_Player_2
        FOREIGN KEY (id_elemento)
        REFERENCES Elemento (id_elemento);
    ```
</details>

### Criação da Tabela Classe

Define as classes dos personagens, como Tank, DPS e Healer.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Classe (
        id_classe SERIAL PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        descricao VARCHAR
    );
    ```
</details>

### Criação da Tabela Habilidade

Armazena as habilidades dos personagens, associando-as a classes e elementos.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Habilidade (
        id_habilidade SERIAL PRIMARY KEY,
        classe_habilidade INTEGER,
        elemento_habilidade INTEGER,
        nome VARCHAR,
        custo INTEGER,
        descricao VARCHAR,
        frase_uso VARCHAR,
        nivel_necessario INTEGER
    );
    ```
</details>

### Definição de Chaves Estrangueiras para Habilidade

Relaciona habilidades a classes e elementos.

<details>
    <sumary>Migrações</sumary>

    ```sql
    ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_2
        FOREIGN KEY (elemento_habilidade)
        REFERENCES Elemento (id_elemento);
    
    ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_3
        FOREIGN KEY (classe_habilidade)
        REFERENCES Classe (id_classe);
    ```
</details>

### Criação de Tipos ENUM

Define tipos de dados para itens, partes do corpo e status de missões.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TYPE enum_tipo_item AS ENUM ('a', 'm', 'i', 'c', 'l'); 
    /* a = armadura, m = material, i = item_missao, c = consumivel, l = livro */

    CREATE TYPE enum_parte_corpo AS ENUM ('c', 't', 'b', 'p'); 
    /* c = cabeça, t = tronco, b = braços, p = pernas */

    CREATE TYPE enum_status_missao AS ENUM ('c','i','ni'); 
    /* c = completo, i = iniciado, ni = não iniciado */
    ```
</details>

### Criação da Tabela Parte_Corpo

Define as partes do corpo que podem ser equipadas com armaduras.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Parte_Corpo (
        id_parte_corpo enum_parte_corpo PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        defesa_magica INTEGER NOT NULL,
        defesa_fisica INTEGER NOT NULL,
        chance_acerto INTEGER NOT NULL,
        chance_acerto_critico INTEGER NOT NULL
    );
    ```
</details>

### Criação da Tabela Tipo_Item

Define os tipos de itens existentes no jogo.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Tipo_Item (
        id_item SERIAL PRIMARY KEY,
        tipo_item enum_tipo_item NOT NULL
    );
    ```
</details>

### Criação da Tabela Armadura

Armazena informações sobre armaduras, associadas a partes do corpo.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
    ```
</details>

### Definição de Chaves Estrangeiras para Armadura

Relaciona armaduras a tipos de itens e partes do corpo.

<details>
    <sumary>Migrações</sumary>

    ```sql
    ALTER TABLE Armadura ADD CONSTRAINT FK_Armadura_2
        FOREIGN KEY (id_armadura)
        REFERENCES Tipo_Item (id_item);
    
    ALTER TABLE Armadura ADD CONSTRAINT FK_Armadura_3
        FOREIGN KEY (id_parte_corpo)
        REFERENCES Parte_Corpo (id_parte_corpo);
    ```
</details>

### Criação da Tabela Material

Armazena materiais utilizados para criar e aprimorar armaduras.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Material (
        id_material INTEGER PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        preco_venda INTEGER NOT NULL,
        descricao VARCHAR
    );
    ```
</details>

### Definição de Chave Estrangeira para Material

Relaciona materiais a tipos de itens.

<details>
    <sumary>Migrações</sumary>

    ```sql
    ALTER TABLE Material ADD CONSTRAINT FK_Material_2
        FOREIGN KEY (id_material)
        REFERENCES Tipo_Item (id_item);

    ```
</details>

### Criação da Tabela Item_Missao

Define itens específicos necessários para missões.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Item_Missao (
        id_item INTEGER PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        descricao VARCHAR
    );
    ```
</details>

### Definição de Chave Estrangeira para Item_Missao

Relaciona itens de missão a tipos de itens.

<details>
    <sumary>Migrações</sumary>

    ```sql
    ALTER TABLE Item_Missao ADD CONSTRAINT FK_Item_Missao_2
        FOREIGN KEY (id_item)
        REFERENCES Tipo_Item (id_item);
    ```
</details>

### Criação da Tabela Consumível

Define poções e outros itens consumíveis.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
    ```
</details>

### Criação da Tabela Livro

Armazena livros que ensinam habilidades para os jogadores.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Livro (
        id_item INTEGER PRIMARY KEY,
        id_habilidade INTEGER,
        nome VARCHAR UNIQUE NOT NULL,
        descricao VARCHAR,
        preco_venda INTEGER NOT NULL
    );
    ```
</details>

### Definição de Chave Estrangeira para Livro

Relaciona livros a tipos de itens.

<details>
    <sumary>Migrações</sumary>

    ```sql
    ALTER TABLE Livro ADD CONSTRAINT FK_Livro_2
        FOREIGN KEY (id_item)
        REFERENCES Tipo_Item (id_item);
    ```
</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
|  0.1 | 13/01/2025 | Criação do Documento | Vinícius Rufino |
|  1.0 | 22/01/2025 | Add o Set Up inicial | Lucas Ramon |
|  1.1 | 22/01/2025 | Atualização do DDL | Lucas Ramon |
|  2.0 | 02/02/2025 | Atualização do Documento | Vinícius Rufino |
|  2.1 | 03/02/2025 | Atualização do DDL | Vinícius Rufino |
|  2.2 | 10/02/2025 | Atualização do DDL e Adição da Toggle List | Vinícius Rufino |