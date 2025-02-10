## DDL

## Introdução

No Módulo 2, exploramos as principais linguagens utilizadas para definir, manipular e consultar dados em um banco de dados relacional. Essas linguagens são essenciais para a criação, manutenção e extração de informações de forma eficiente. Abaixo, destacamos os três principais conceitos abordados:

### Data Definition Language (DDL)

A Linguagem de Definição de Dados (DDL) é responsável pela estrutura do banco de dados. Comandos DDL permitem criar, modificar e excluir objetos como tabelas, índices, views e esquemas.

<details>
    <sumary>Clique aqui para ver as migrações</sumary>

    ```sql
    CREATE ROLE "user" WITH SUPERUSER LOGIN PASSWORD 'password';

    CREATE TABLE IF NOT EXISTS Elemento (
        id_elemento SERIAL PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        descricao VARCHAR,
        fraco_contra INTEGER,
        forte_contra INTEGER
    );

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
    CREATE TABLE Classe (
        id_classe SERIAL PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        descricao VARCHAR
    );

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
    CREATE TYPE enum_tipo_item as ENUM ('a', 'm', 'i', 'c', 'l');
    CREATE TYPE enum_parte_corpo as ENUM ('c', 't', 'b', 'p');
    CREATE TYPE enum_status_missao as ENUM ('c','i','ni');

    CREATE TABLE Parte_Corpo (
        id_parte_corpo enum_parte_corpo PRIMARY KEY,
        nome VARCHAR UNIQUE NOT NULL,
        defesa_magica INTEGER NOT NULL,
        defesa_fisica INTEGER NOT NULL,
        chance_acerto INTEGER NOT NULL,
        chance_acerto_critico INTEGER NOT NULL
    );

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

    CREATE TABLE Missao (
        id_missao SERIAL PRIMARY KEY,
        id_missao_anterior INTEGER,
        item_necessario INTEGER NOT NULL,
        id_cavaleiro_desbloqueado INTEGER,
        nome VARCHAR UNIQUE NOT NULL,
        dialogo_inicial VARCHAR,
        dialogo_durante VARCHAR,
        dialogo_completa VARCHAR
    );

    CREATE TABLE Saga (
        id_saga SERIAL PRIMARY KEY,
        id_missao_requisito INTEGER,
        id_missao_proxima_saga INTEGER,
        nome VARCHAR UNIQUE NOT NULL,
        descricao VARCHAR,
        nivel_recomendado INTEGER NOT NULL
    );

    CREATE TABLE Casa (
        id_casa SERIAL PRIMARY KEY,
        id_saga INTEGER NOT NULL,
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

    CREATE TABLE Sala_Segura (
        id_sala INTEGER PRIMARY KEY
    );

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

    CREATE TABLE material_necessario_ferreiro (
        id_material INTEGER,
        id_custo_ferreiro INTEGER,
        quantidade INTEGER,
        PRIMARY KEY (id_material, id_custo_ferreiro)
    );

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

    CREATE TABLE Cavaleiro (
        id_cavaleiro SERIAL PRIMARY KEY,
        id_classe INTEGER NOT NULL,
        id_elemento INTEGER NOT NULL,
        nome VARCHAR UNIQUE NOT NULL,
        nivel INTEGER NOT NULL,
        hp_max INTEGER NOT NULL,
        magia_max INTEGER NOT NULL,
        velocidade_base INTEGER NOT NULL,
        ataque_fisico_base INTEGER NOT NULL,
        ataque_magico_base INTEGER NOT NULL
    );

    CREATE TABLE Boss (
        id_boss SERIAL PRIMARY KEY,
        id_sala INTEGER,
        id_item_missao INTEGER,
        nome VARCHAR,
        nivel INTEGER,
        xp_acumulado INTEGER,
        hp_max INTEGER,
        hp_atual INTEGER,
        magia_max INTEGER,
        magia_atual INTEGER,
        velocidade INTEGER,
        ataque_fisico_base INTEGER,
        ataque_magico_base INTEGER,
        dinheiro INTEGER,
        fala_inicio VARCHAR,
        fala_derrotar_player VARCHAR,
        fala_derrotado VARCHAR,
        fala_condicao VARCHAR
    );

    CREATE TABLE Inimigo (
        id_inimigo SERIAL PRIMARY KEY,
        id_classe INTEGER NOT NULL,
        id_elemento INTEGER NOT NULL,
        nome VARCHAR NOT NULL,
        nivel INTEGER NOT NULL,
        xp_acumulado INTEGER NOT NULL,
        hp_max INTEGER NOT NULL,
        magia_max INTEGER NOT NULL,
        velocidade INTEGER NOT NULL,
        ataque_fisico_base INTEGER NOT NULL,
        ataque_magico_base INTEGER NOT NULL,
        dinheiro INTEGER NOT NULL,
        fala_inicio VARCHAR
    );

    CREATE TABLE Grupo_inimigo (
        id_grupo SERIAL PRIMARY KEY,
        id_sala INTEGER
    );

    CREATE TABLE Instancia_Inimigo (
        id_instancia SERIAL,
        id_inimigo INTEGER,
        id_grupo INTEGER,
        hp_atual INTEGER NOT NULL,
        magia_atual INTEGER NOT NULL,
        defesa_fisica_bonus INTEGER,
        defesa_magica_bonus INTEGER,
        PRIMARY KEY (id_inimigo, id_instancia)
    );

    CREATE TABLE Inventario (
        id_player INTEGER PRIMARY KEY,
        dinheiro INTEGER NOT NULL,
        alma_armadura INTEGER
    );

    CREATE TABLE Armadura_Instancia (
        id_armadura INTEGER,
        id_parte_corpo_armadura enum_parte_corpo,
        id_instancia SERIAL,
        id_inventario INTEGER,
        raridade_armadura VARCHAR NOT NULL,
        defesa_magica INTEGER NOT NULL,
        defesa_fisica INTEGER NOT NULL,
        ataque_magico INTEGER NOT NULL,
        ataque_fisico INTEGER NOT NULL, 
        durabilidade_atual INTEGER NOT NULL,
        preco_venda INTEGER NOT NULL,
        PRIMARY KEY (id_armadura, id_instancia, id_parte_corpo_armadura)
    );

    CREATE TABLE Item_a_venda (
        id_item INTEGER PRIMARY KEY,
        preco_compra INTEGER NOT NULL,
        nivel_minimo INTEGER NOT NULL
    );

    CREATE TABLE Party (
        id_player INTEGER PRIMARY KEY,
        id_sala INTEGER
    );

    CREATE TABLE Instancia_Cavaleiro (
        id_cavaleiro INTEGER,
        id_player INTEGER,
        id_party INTEGER,
        nivel INTEGER,
        tipo_armadura INTEGER,
        xp_atual INTEGER,
        hp_max INTEGER,
        magia_max INTEGER,
        hp_atual INTEGER,
        magia_atual INTEGER,
        velocidade INTEGER,
        ataque_fisico INTEGER,
        ataque_magico INTEGER,
        PRIMARY KEY (id_cavaleiro, id_player)
    );

    CREATE TABLE Receita (
        id_item_gerado INTEGER PRIMARY KEY,
        descricao VARCHAR
    );

    CREATE TABLE Player_Missao (
        id_player INTEGER,
        id_missao INTEGER,
        status_missao enum_status_missao NOT NULL,
        PRIMARY KEY (id_player, id_missao)
    );

    CREATE TABLE Xp_Necessaria (
        nivel INTEGER PRIMARY KEY,
        xp_necessaria INTEGER NOT NULL
    );

    CREATE TABLE Material_Receita (
        id_receita INTEGER,
        id_material INTEGER,
        quantidade INTEGER NOT NULL,
        PRIMARY KEY (id_receita, id_material)
    );

    CREATE TABLE Habilidade_Player (
        id_player INTEGER,
        id_habilidade INTEGER,
        slot INTEGER NOT NULL,
        PRIMARY KEY (id_player, id_habilidade, slot)
    );

    CREATE TABLE Habilidade_Cavaleiro (
        id_cavaleiro INTEGER,
        id_habilidade INTEGER,
        slot INTEGER NOT NULL,
        PRIMARY KEY (id_cavaleiro, id_habilidade, slot)
    );

    CREATE TABLE Habilidade_Boss (
        id_boss INTEGER,
        id_habilidade INTEGER,
        PRIMARY KEY (id_boss, id_habilidade)
    );

    CREATE TABLE Parte_Corpo_Boss (
        id_boss INTEGER,
        parte_corpo enum_parte_corpo,
        defesa_fisica INTEGER NOT NULL,
        defesa_magica INTEGER NOT NULL,
        chance_acerto_base INTEGER NOT NULL,
        chance_acerto_critico INTEGER NOT NULL,
        PRIMARY KEY (id_boss, parte_corpo)
    );

    CREATE TABLE Parte_Corpo_Cavaleiro (
        id_cavaleiro INTEGER,
        parte_corpo enum_parte_corpo,
        id_player INTEGER,
        defesa_fisica_bonus INTEGER,
        defesa_magico_bonus INTEGER,
        chance_acerto_base INTEGER,
        chance_acerto_critico INTEGER,
        PRIMARY KEY (id_cavaleiro, parte_corpo, id_player)
    );

    CREATE TABLE Parte_Corpo_Player (
        id_player INTEGER,
        parte_corpo enum_parte_corpo,
        armadura_equipada INTEGER,
        instancia_armadura_equipada INTEGER,
        PRIMARY KEY (id_player, parte_corpo)
    );

    CREATE TABLE Elemento_Boss (
        id_elemento INTEGER,
        id_boss INTEGER,
        PRIMARY KEY (id_boss, id_elemento)
    );

    CREATE TABLE Habilidade_Inimigo (
        id_habilidade INTEGER,
        id_player INTEGER,
        PRIMARY KEY (id_habilidade, id_player)
    );

    CREATE TABLE Item_Armazenado (
        id_inventario INTEGER,
        id_item INTEGER,
        quantidade INTEGER NOT NULL,
        PRIMARY KEY (id_inventario, id_item)
    );

    CREATE TABLE Item_grupo_inimigo_dropa (
        id_item INTEGER,
        id_grupo_inimigo INTEGER,
        quantidade INTEGER NOT NULL,
        PRIMARY KEY (id_item, id_grupo_inimigo)
    );

    CREATE TABLE Texto (
        id SERIAL PRIMARY KEY,
        texto TEXT NOT NULL,
        nome_texto VARCHAR NOT NULL
    );

    CREATE TABLE audios (
        id SERIAL PRIMARY KEY,        
        nome TEXT NOT NULL,           
        nome_arquivo TEXT NOT NULL,   
        descricao TEXT               
    );

    CREATE TABLE public.parte_corpo_inimigo (
        id_instancia INT NOT NULL,
        id_inimigo INT NOT NULL,
        parte_corpo public."enum_parte_corpo" NOT NULL,
        defesa_fisica INT NOT NULL,
        defesa_magica INT NOT NULL,
        chance_acerto_base INT NOT NULL,
        chance_acerto_critico INT NOT NULL,
        PRIMARY KEY (id_instancia, id_inimigo, parte_corpo)
    );
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
|  2.2 | 03/02/2025 | Atualização do DDL e Adição da Toggle List | Vinícius Rufino |