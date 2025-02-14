## Data Definition Language (DDL)

### Introdução

O Data Definition Language (DDL) é um subconjunto da linguagem SQL, responsável pela definição e manipulação da estrutura de um banco de dados. Segundo Elmasri e Navathe, no livro "Sistemas de Banco de Dados", o DDL permite criar, modificar e remover elementos da estrutura de um banco, como tabelas, esquemas, visões e restrições de integridade. Esse conjunto de comandos define o formato e a organização dos dados, garantindo coerência e segurança na manipulação das informações.

### Objetivos

Este documento apresenta a implementação e utilização do DDL no sistema, detalhando suas funcionalidades, benefícios e aplicabilidades dentro do contexto do gerenciamento de dados. As migrações DDL garantem a estruturação eficiente do banco, permitindo a criação, modificação e manutenção das tabelas e demais objetos essenciais ao funcionamento do jogo.

### V0_init

Define o papel "user" com permissões no banco de dados e no esquema "public".

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE ROLE "user" WITH SUPERUSER LOGIN PASSWORD 'password';

    GRANT CONNECT ON DATABASE cdz TO "user";

    GRANT USAGE ON SCHEMA public TO "user";
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "user";
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "user";
    GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO "user";

    ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON TABLES TO "user";

    ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON SEQUENCES TO "user";

    ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON FUNCTIONS TO "user";
    ```

</details>

### V1_create_elemento_table

Cria a tabela "Elemento", que armazena informações sobre elementos do jogo, incluindo fraqueza e força contra outros elementos.

<details>
    <sumary>Migrações</sumary>

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

### V2_create_player_table

Define as tabelas "Player" e "Tipo_Personagem", relacionando-as a "Elemento" e criando restrições de chave estrangeira.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TYPE enum_tipo_personagem as ENUM ('p', 'c', 'i', 'b'); -- p = personagem , c = cavaleiro , i = inimigo , b = boss 

    CREATE TABLE Tipo_Personagem (
        id_personagem SERIAL PRIMARY KEY,
        tipo_personagem enum_tipo_personagem NOT NULL
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
        ataque_fisico INTEGER NOT NULL,
        ataque_magico INTEGER NOT NULL
    );

    ALTER TABLE Player ADD CONSTRAINT FK_Player_2
        FOREIGN KEY (id_elemento)
        REFERENCES Elemento (id_elemento);

    ALTER TABLE Player ADD CONSTRAINT FK_Player_3
        FOREIGN KEY (id_player)
        REFERENCES Tipo_Personagem (id_personagem);
    ```

</details>

### V3_create_classe_table

Introduz a tabela "Classe", que categoriza diferentes classes de personagens.

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

### V4_create_habilidade_table

Cria a tabela "Habilidade", relacionando-a com "Classe" e "Elemento".

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Habilidade (
        id_habilidade SERIAL PRIMARY KEY,
        classe_habilidade INTEGER,
        elemento_habilidade INTEGER,
        nome VARCHAR,
        custo INTEGER,
        dano INTEGER,
        descricao VARCHAR,
        frase_uso VARCHAR,
        nivel_necessario INTEGER,
        audio VARCHAR
    );

    ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_2
        FOREIGN KEY (elemento_habilidade)
        REFERENCES Elemento (id_elemento);
    
    ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_3
        FOREIGN KEY (classe_habilidade)
        REFERENCES Classe (id_classe);
    ```

</details>

### V5_create_enum

Define diversos tipos enumerados usados para categorizar itens, status de missão, tipos de NPCs, entre outros.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TYPE enum_tipo_item as ENUM ('c','nc'); /* c = craftavel, nc = nao craftavel */
    CREATE TYPE enum_craftavel as ENUM ('a', 'm'); /* a = armadura, m = material */
    CREATE TYPE enum_nao_craftavel as ENUM ('i', 'c', 'l'); /* i = item_missao, c = consumivel, l = livro */
    CREATE TYPE enum_parte_corpo as ENUM ('c', 't', 'b', 'p'); /* c = cabeça, t = tronco, b = braços, p = pernas */
    CREATE TYPE enum_status_missao as ENUM ('c','i','ni'); /* c = completo, i=iniciado,ni=não iniciado*/
    CREATE TYPE enum_tipo_npc as ENUM ('f','m','q'); /* f = ferreiro , m = mercaador , q = quest */
    ```

</details>

### V6_create_parte_corpo

Cria a tabela "Parte_Corpo" para representar as diferentes partes do corpo que equipam armaduras.

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

### V7_create_item

Define tabelas relacionadas a itens, incluindo "Armadura", "Material", "Item_Missao", "Consumivel" e "Livro", com suas respectivas chaves estrangeiras.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Tipo_Item (
        id_item SERIAL PRIMARY KEY,
        tipo_item enum_tipo_item NOT NULL
    );

    CREATE TABLE Craftavel (
        id_craftavel INTEGER PRIMARY KEY,
        tipo_craftavel enum_craftavel NOT NULL
    );

    CREATE TABLE Nao_Craftavel (
        id_nao_craftavel INTEGER PRIMARY KEY,
        tipo_nao_craftavel enum_nao_craftavel NOT NULL
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
        REFERENCES Craftavel (id_craftavel);
    
    ALTER TABLE Armadura ADD CONSTRAINT FK_Armadura_3
        FOREIGN KEY (id_parte_corpo)
        REFERENCES Parte_Corpo (id_parte_corpo);

    ALTER TABLE Material ADD CONSTRAINT FK_Material_2
        FOREIGN KEY (id_material)
        REFERENCES Craftavel (id_craftavel);

    ALTER TABLE Item_Missao ADD CONSTRAINT FK_Item_Missao_2
        FOREIGN KEY (id_item)
        REFERENCES Nao_Craftavel (id_nao_craftavel);

    ALTER TABLE Livro ADD CONSTRAINT FK_Livro_2
        FOREIGN KEY (id_item)
        REFERENCES Nao_Craftavel (id_nao_craftavel);
    
    ALTER TABLE Livro ADD CONSTRAINT FK_Livro_3
        FOREIGN KEY (id_habilidade)
        REFERENCES Habilidade (id_habilidade);

    ALTER TABLE Consumivel ADD CONSTRAINT FK_Consumivel_2
        FOREIGN KEY (id_item)
        REFERENCES Nao_Craftavel (id_nao_craftavel);
    ```

</details>

### V8_create_missao

Cria a tabela "Missao" para armazenar informações sobre missões do jogo.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
    
    ALTER TABLE Missao ADD CONSTRAINT FK_Missao_2
        FOREIGN KEY (id_missao_anterior)
        REFERENCES Missao (id_missao);
    
    ALTER TABLE Missao ADD CONSTRAINT FK_Missao_3
        FOREIGN KEY (item_necessario)
        REFERENCES Item_Missao (id_item);
    ```

</details>

### V9_create_mapa

Estabelece tabelas para estruturar o mundo do jogo, incluindo "Saga", "Casa" e "Sala".

<details>
    <sumary>Migrações</sumary>

    ```sql
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
    ```

</details>

### V10_create_npc

Define tabelas para NPCs como "Ferreiro", "Mercador" e "Quest".

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Tipo_npc (
        id_npc SERIAL PRIMARY KEY,
        tipo_npc enum_tipo_npc NOT NULL
    );

    CREATE TABLE Ferreiro (
        id_npc SERIAL PRIMARY KEY,
        id_sala INTEGER NOT NULL,
        id_missao_desbloqueia INTEGER NOT NULL,
        nome VARCHAR NOT NULL,
        descricao VARCHAR,
        dialogo_inicial VARCHAR,
        dialogo_reparar VARCHAR,
        dialogo_upgrade VARCHAR,
        dialogo_desmanchar VARCHAR,
        dialogo_sair VARCHAR,
        CONSTRAINT FK_Ferreiro_1 FOREIGN KEY (id_npc) REFERENCES Tipo_npc (id_npc),
        CONSTRAINT FK_Ferreiro_2 FOREIGN KEY (id_sala) REFERENCES Sala (id_sala),
        CONSTRAINT FK_Ferreiro_3 FOREIGN KEY (id_missao_desbloqueia) REFERENCES Missao (id_missao)
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

    CREATE TABLE Quest (
        id_npc SERIAL PRIMARY KEY,
        id_sala INTEGER NOT NULL,
        nome VARCHAR NOT NULL,
        descricao VARCHAR,
        dialogo_inicial VARCHAR,
        dialogo_recusa VARCHAR,
        dialogo_sair VARCHAR,
        CONSTRAINT FK_Tipo_npc_Quest_1 FOREIGN KEY (id_npc) REFERENCES Tipo_npc (id_npc),
        CONSTRAINT FK_Tipo_npc_Quest_2 FOREIGN KEY (id_sala) REFERENCES Sala (id_sala)
    );
    

    CREATE TABLE Mercador (
        id_npc SERIAL PRIMARY KEY,
        id_sala INTEGER NOT NULL,
        nome VARCHAR NOT NULL,
        descricao VARCHAR,
        dialogo_inicial VARCHAR,
        dialogo_vender VARCHAR,
        dialogo_comprar VARCHAR,
        dialogo_sair VARCHAR,
        CONSTRAINT FK_Mercador_1 FOREIGN KEY (id_npc) REFERENCES Tipo_npc (id_npc),
        CONSTRAINT FK_Mercador_2 FOREIGN KEY (id_sala) REFERENCES Sala (id_sala)
    );
    ```

</details>

### V11_create_cavaleiro

Cria a tabela "Cavaleiro" e suas relações com "Classe" e "Elemento".

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Cavaleiro (
        id_cavaleiro SERIAL PRIMARY KEY,
        id_classe INTEGER NOT NULL,
        id_elemento INTEGER NOT NULL,
        nome VARCHAR UNIQUE NOT NULL,
        nivel INTEGER NOT NULL,
        hp_max INTEGER NOT NULL,
        magia_max INTEGER NOT NULL,
        velocidade INTEGER NOT NULL,
        ataque_fisico INTEGER NOT NULL,
        ataque_magico INTEGER NOT NULL
    );
    


    ALTER TABLE Cavaleiro ADD CONSTRAINT FK_Cavaleiro_1
        FOREIGN KEY (id_cavaleiro)
        REFERENCES Tipo_Personagem (id_personagem);

    ALTER TABLE Cavaleiro ADD CONSTRAINT FK_Cavaleiro_2
        FOREIGN KEY (id_classe)
        REFERENCES Classe (id_classe);
    
    ALTER TABLE Cavaleiro ADD CONSTRAINT FK_Cavaleiro_3
        FOREIGN KEY (id_elemento)
        REFERENCES Elemento (id_elemento);
    ```

</details>

### V12_create_boss

Introduz a tabela "Boss", representando chefes do jogo.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
        ataque_fisico INTEGER,
        ataque_magico INTEGER,
        dinheiro INTEGER,
        fala_inicio VARCHAR,
        fala_derrotar_player VARCHAR,
        fala_derrotado VARCHAR,
        fala_condicao VARCHAR,
        id_elemento INTEGER
    );
    
    ALTER TABLE Boss ADD CONSTRAINT FK_Boss_1
        FOREIGN KEY (id_boss)
        REFERENCES Tipo_Personagem (id_personagem);

    ALTER TABLE Boss ADD CONSTRAINT FK_Boss_2
        FOREIGN KEY (id_sala)
        REFERENCES Sala (id_sala);
    
    ALTER TABLE Boss ADD CONSTRAINT FK_Boss_3
        FOREIGN KEY (id_item_missao)
        REFERENCES Item_Missao (id_item);

    ALTER TABLE Boss ADD CONSTRAINT FK_Boss_4
        FOREIGN KEY (id_elemento)
        REFERENCES Elemento (id_elemento);


    CREATE TABLE Item_boss_dropa (
        id_boss INTEGER,
        id_item INTEGER,
        quantidade INTEGER,
        PRIMARY KEY (id_boss, id_item)
    );
    
    ALTER TABLE Item_boss_dropa ADD CONSTRAINT FK_Item_boss_dropa_2
        FOREIGN KEY (id_boss)
        REFERENCES Boss (id_boss);
    
    ALTER TABLE Item_boss_dropa ADD CONSTRAINT FK_Item_boss_dropa_3
        FOREIGN KEY (id_item)
        REFERENCES Tipo_Item (id_item);
    ```

</details>

### V13_create_inimigo

Define a tabela "Inimigo", com relação a "Classe" e "Elemento".

<details>
    <sumary>Migrações</sumary>

    ```sql
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
        ataque_fisico INTEGER NOT NULL,
        ataque_magico INTEGER NOT NULL,
        dinheiro INTEGER NOT NULL,
        fala_inicio VARCHAR
    );
    
    ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_1
        FOREIGN KEY (id_inimigo)
        REFERENCES Tipo_Personagem (id_personagem);
    
    ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_2
        FOREIGN KEY (id_elemento)
        REFERENCES Elemento (id_elemento);
    
    ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_3
        FOREIGN KEY (id_classe)
        REFERENCES Classe (id_classe);
    ```

</details>

### V14_create_instancia_inimigo

Cria tabelas para grupos e instâncias de inimigos em combate.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
        velocidade INTEGER NOT NULL,
        ataque_fisico INTEGER NOT NULL,
        ataque_magico INTEGER NOT NULL,
        PRIMARY KEY (id_inimigo, id_instancia)
    );
    
    ALTER TABLE Instancia_Inimigo ADD CONSTRAINT FK_Instancia_Inimigo_2
        FOREIGN KEY (id_inimigo)
        REFERENCES Inimigo (id_inimigo);
    
    ALTER TABLE Instancia_Inimigo ADD CONSTRAINT FK_Instancia_Inimigo_3
        FOREIGN KEY (id_grupo)
        REFERENCES Grupo_inimigo (id_grupo);

    ALTER TABLE Grupo_inimigo ADD CONSTRAINT FK_Grupo_inimigo_2
        FOREIGN KEY (id_sala)
        REFERENCES Sala (id_sala);
    ```

</details>

### V15_create_inventario

Estabelece a tabela "Inventario" para armazenar recursos dos jogadores.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Inventario (
        id_player INTEGER PRIMARY KEY,
        dinheiro INTEGER NOT NULL,
        alma_armadura INTEGER NOT NULL
    );
    
    ALTER TABLE Inventario ADD CONSTRAINT FK_Inventario_1
        FOREIGN KEY (id_player)
        REFERENCES Player (id_player);
    ```

</details>

### V16_create_armadura

Define tabelas para instâncias e armaduras equipadas.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
        PRIMARY KEY (id_armadura, id_instancia, id_parte_corpo_armadura)
    );
    
    ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_2
        FOREIGN KEY (id_armadura, id_parte_corpo_armadura)
        REFERENCES Armadura (id_armadura, id_parte_corpo);
    
    ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_3
        FOREIGN KEY (id_inventario)
        REFERENCES Inventario (id_player);


    CREATE TABLE Armadura_Equipada (
        id_player INTEGER,
        id_armadura INTEGER,
        id_armadura_instanciada INTEGER,
        id_parte_corpo_armadura enum_parte_corpo,
        PRIMARY KEY (id_player, id_armadura, id_armadura_instanciada, id_parte_corpo_armadura)
    );
    
    ALTER TABLE Armadura_Equipada ADD CONSTRAINT FK_Armadura_Equipada_2
        FOREIGN KEY (id_armadura, id_armadura_instanciada, id_parte_corpo_armadura)
        REFERENCES Armadura_Instancia (id_armadura, id_instancia, id_parte_corpo_armadura);
    
    ALTER TABLE Armadura_Equipada ADD CONSTRAINT FK_Armadura_Equipada_3
        FOREIGN KEY (id_player)
        REFERENCES Player (id_player);
    ```

</details>

### V17_create_item_a_venda

Cria a tabela "Item_a_venda" para representar itens disponíveis para compra.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Item_a_venda (
        id_item INTEGER PRIMARY KEY,
        preco_compra INTEGER NOT NULL,
        nivel_minimo INTEGER NOT NULL
    );
    
    ALTER TABLE Item_a_venda ADD CONSTRAINT FK_Item_a_venda_2
        FOREIGN KEY (id_item)
        REFERENCES Tipo_Item (id_item);
    ```

</details>

### V18_create_party_table

Define a tabela "Party" para representar grupos de jogadores.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Party (
        id_player INTEGER PRIMARY KEY,
        id_sala INTEGER
    );
    
    ALTER TABLE Party ADD CONSTRAINT FK_Party_2
        FOREIGN KEY (id_sala)
        REFERENCES Sala (id_sala);
    ```

</details>

### V19_create_table_instancia_cavaleiro

Estrutura instâncias de cavaleiros na party.

<details>
    <sumary>Migrações</sumary>

    ```sql
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
    
    ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_2
        FOREIGN KEY (id_cavaleiro)
        REFERENCES Cavaleiro (id_cavaleiro);
    
    ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_3
        FOREIGN KEY (id_party)
        REFERENCES Party (id_player);
    
    ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_4
        FOREIGN KEY (id_player)
        REFERENCES Player (id_player);
    ```

</details>

### V20_create_receita_table

Cria a tabela "Receita" para definir combinações de materiais na criação de itens.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Receita (
        id_item_gerado INTEGER PRIMARY KEY,
        descricao VARCHAR,
        nivel_minimo INTEGER,
        alma_armadura INTEGER
    );
    
    ALTER TABLE Receita ADD CONSTRAINT FK_Receita_2
        FOREIGN KEY (id_item_gerado)
        REFERENCES Tipo_Item (id_item);
    ```

</details>

### V21_create_player_missao

Relaciona jogadores e missões através da tabela "Player_Missao".

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Player_Missao (
        id_player INTEGER,
        id_missao INTEGER,
        status_missao enum_status_missao NOT NULL,
        PRIMARY KEY (id_player, id_missao)
    );
    
    ALTER TABLE Player_Missao ADD CONSTRAINT FK_Player_Missao_2
        FOREIGN KEY (id_missao)
        REFERENCES Missao (id_missao);
    
    ALTER TABLE Player_Missao ADD CONSTRAINT FK_Player_Missao_3
        FOREIGN KEY (id_player)
        REFERENCES Player (id_player);
    ```

</details>

### V22_create_xp_necessaria

Define os valores de XP necessários para subir de nível.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Xp_Necessaria (
        nivel INTEGER PRIMARY KEY,
        xp_necessaria INTEGER NOT NULL
    );

    INSERT INTO public.xp_necessaria
    (nivel, xp_necessaria)
    VALUES
        (2, 5),
        (3, 10),
        (4, 15),
        (5, 20),
        (6, 25),
        (7, 30),
        (8, 40),
        (9, 50),
        (10, 80),
        (11, 100),
        (12,9999);
    ```

</details>

### V23_create_table_material_receita

Relaciona materiais e receitas de criação de itens.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Material_Receita (
        id_receita INTEGER,
        id_material INTEGER,
        quantidade INTEGER NOT NULL,
        PRIMARY KEY (id_receita, id_material)
    );
    
    ALTER TABLE Material_Receita ADD CONSTRAINT FK_Material_Receita_2
        FOREIGN KEY (id_material)
        REFERENCES Material (id_material);
    
    ALTER TABLE Material_Receita ADD CONSTRAINT FK_Material_Receita_3
        FOREIGN KEY (id_receita)
        REFERENCES Receita (id_item_gerado);

    ```

</details>

### V24_create_table_habilidade

Liga jogadores a habilidades adquiridas.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Habilidade_Player (
        id_player INTEGER,
        id_habilidade INTEGER,
        slot INTEGER NOT NULL,
        PRIMARY KEY (id_player, id_habilidade, slot),
        CONSTRAINT unique_habilidade_por_player UNIQUE (id_player, id_habilidade)
    );
    
    ALTER TABLE Habilidade_Player ADD CONSTRAINT FK_Habilidade_Player_2
        FOREIGN KEY (id_habilidade)
        REFERENCES Habilidade (id_habilidade);
    
    ALTER TABLE Habilidade_Player ADD CONSTRAINT FK_Habilidade_Player_3
        FOREIGN KEY (id_player)
        REFERENCES Player (id_player);
    ```

</details>

### V25_create_table_habilidade_cavaleiro

Relaciona cavaleiros e suas habilidades.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Habilidade_Cavaleiro (
        id_cavaleiro INTEGER,
        id_habilidade INTEGER,
        slot INTEGER NOT NULL,
        PRIMARY KEY (id_cavaleiro, id_habilidade, slot),
        CONSTRAINT unique_habilidade_por_cavaleiro UNIQUE (id_cavaleiro, id_habilidade)
    );
    
    ALTER TABLE Habilidade_Cavaleiro ADD CONSTRAINT FK_Habilidade_Cavaleiro_2
        FOREIGN KEY (id_cavaleiro)
        REFERENCES Cavaleiro (id_cavaleiro);
    
    ALTER TABLE Habilidade_Cavaleiro ADD CONSTRAINT FK_Habilidade_Cavaleiro_3
        FOREIGN KEY (id_habilidade)
        REFERENCES Habilidade (id_habilidade);
    ```

</details>

### V26_create_table_habilidade_boss

Armazena habilidades de chefes.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Habilidade_Boss (
        id_boss INTEGER,
        id_habilidade INTEGER,
        PRIMARY KEY (id_boss, id_habilidade)
    );
    
    ALTER TABLE Habilidade_Boss ADD CONSTRAINT FK_Habilidade_Boss_2
        FOREIGN KEY (id_boss)
        REFERENCES Boss (id_boss);
    
    ALTER TABLE Habilidade_Boss ADD CONSTRAINT FK_Habilidade_Boss_3
        FOREIGN KEY (id_habilidade)
        REFERENCES Habilidade (id_habilidade);
    ```

</details>

### V27_create_parte_corpo_boss

Define atributos específicos das partes do corpo dos chefes.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Parte_Corpo_Boss (
        id_boss INTEGER,
        parte_corpo enum_parte_corpo,
        defesa_fisica INTEGER NOT NULL,
        defesa_magica INTEGER NOT NULL,
        chance_acerto INTEGER NOT NULL,
        chance_acerto_critico INTEGER NOT NULL,
        PRIMARY KEY (id_boss, parte_corpo)
    );
    
    ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_2
        FOREIGN KEY (id_boss)
        REFERENCES Boss (id_boss);
    
    ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_3
        FOREIGN KEY (parte_corpo)
        REFERENCES Parte_Corpo (id_parte_corpo);

    CREATE TABLE public.parte_corpo_inimigo (
        id_instancia INT NOT NULL,
        id_inimigo INT NOT NULL,
        parte_corpo public."enum_parte_corpo" NOT NULL,
        defesa_fisica INT NOT NULL,
        defesa_magica INT NOT NULL,
        chance_acerto INT NOT NULL,
        chance_acerto_critico INT NOT NULL,
        PRIMARY KEY (id_instancia, id_inimigo, parte_corpo), -- Agora a chave primária é correta
        FOREIGN KEY (id_instancia, id_inimigo) REFERENCES public.instancia_inimigo(id_instancia, id_inimigo),
        FOREIGN KEY (parte_corpo) REFERENCES public.parte_corpo(id_parte_corpo)
    );
    ```

</details>

### V28_create_parte_do_corpo_cavaleiro

Estrutura a divisão de partes do corpo para cavaleiros.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Parte_Corpo_Cavaleiro (
        id_cavaleiro INTEGER,
        parte_corpo enum_parte_corpo,
        id_player INTEGER,
        defesa_fisica INTEGER,
        defesa_magica INTEGER,
        chance_acerto INTEGER,
        chance_acerto_critico INTEGER,
        PRIMARY KEY (id_cavaleiro, parte_corpo, id_player)
    );
    
    ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_2
        FOREIGN KEY (parte_corpo)
        REFERENCES Parte_Corpo (id_parte_corpo);
    
    ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_3
        FOREIGN KEY (id_cavaleiro, id_player)
        REFERENCES Instancia_Cavaleiro (id_cavaleiro, id_player);
    ```

</details>

### V29_create_parte_corpo_player

Define atributos das partes do corpo dos jogadores.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Parte_Corpo_Player (
        id_player INTEGER,
        parte_corpo enum_parte_corpo,
        defesa_fisica INTEGER,
        defesa_magica INTEGER,
        chance_acerto INTEGER,
        chance_acerto_critico INTEGER,
        PRIMARY KEY (id_player, parte_corpo)
    );
    
    ALTER TABLE Parte_Corpo_Player ADD CONSTRAINT FK_Parte_Corpo_Player_2
        FOREIGN KEY (id_player)
        REFERENCES Player (id_player);
    
    ALTER TABLE Parte_Corpo_Player ADD CONSTRAINT FK_Parte_Corpo_Player_3
        FOREIGN KEY (parte_corpo)
        REFERENCES Parte_Corpo (id_parte_corpo);
    ```

</details>

### V30_parte_corpo

Cria funções para automação na criação de partes do corpo.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION gerar_partes_corpo_boss()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.parte_corpo_boss (id_boss, parte_corpo, defesa_fisica, defesa_magica, chance_acerto, chance_acerto_critico)
        SELECT 
            NEW.id_boss,                     
            pc.id_parte_corpo,               
            pc.defesa_fisica * 2,           
            pc.defesa_magica * 2,           
            pc.chance_acerto * 2,            
            pc.chance_acerto_critico * 2     
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER trigger_gerar_partes_corpo_boss
    AFTER INSERT ON public.boss
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_boss();

    CREATE OR REPLACE FUNCTION gerar_partes_corpo_cavaleiro()
    RETURNS TRIGGER AS $$
    BEGIN
    
        INSERT INTO public.parte_corpo_cavaleiro (
            id_cavaleiro, 
            parte_corpo,  
            id_player, 
            defesa_fisica, 
            defesa_magica, 
            chance_acerto, 
            chance_acerto_critico
        )
        SELECT 
            NEW.id_cavaleiro,        
            pc.id_parte_corpo,        
            NEW.id_player,            
            pc.defesa_fisica,          
            pc.defesa_magica,         
            pc.chance_acerto,          
            pc.chance_acerto_critico   
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_gerar_partes_corpo_cavaleiro
    AFTER INSERT ON public.instancia_cavaleiro
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_cavaleiro();

    CREATE OR REPLACE FUNCTION gerar_partes_corpo_player()
    RETURNS TRIGGER AS $$
    BEGIN
        
        INSERT INTO public.parte_corpo_player (
            id_player, 
            parte_corpo, 
            defesa_fisica, 
            defesa_magica, 
            chance_acerto, 
            chance_acerto_critico
        )
        SELECT 
            NEW.id_player,   
            pc.id_parte_corpo, 
            pc.defesa_fisica,          
            pc.defesa_magica,         
            pc.chance_acerto,          
            pc.chance_acerto_critico 
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_gerar_partes_corpo_player
    AFTER INSERT ON public.player
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_player();



    CREATE OR REPLACE FUNCTION gerar_partes_corpo_inimigo()
    RETURNS TRIGGER AS $$
    BEGIN
    
        INSERT INTO public.parte_corpo_inimigo (
            id_instancia, 
            id_inimigo,
            parte_corpo, 
            defesa_fisica, 
            defesa_magica, 
            chance_acerto, 
            chance_acerto_critico
        )
        SELECT 
            NEW.id_instancia,      
            NEW.id_inimigo,        
            pc.id_parte_corpo,     
            pc.defesa_fisica,      
            pc.defesa_magica,     
            pc.chance_acerto,      
            pc.chance_acerto_critico  
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER trigger_gerar_partes_corpo_inimigo
    AFTER INSERT ON public.instancia_inimigo
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_inimigo();
    ```

</details>

### V32_create_habilidade_inimigo

Relaciona inimigos e habilidades.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Habilidade_Inimigo (
        id_habilidade INTEGER,
        id_player INTEGER,
        PRIMARY KEY (id_habilidade, id_player)
    );
    
    ALTER TABLE Habilidade_Inimigo ADD CONSTRAINT FK_Habilidade_Inimigo_2
        FOREIGN KEY (id_habilidade)
        REFERENCES Habilidade (id_habilidade);
    
    ALTER TABLE Habilidade_Inimigo ADD CONSTRAINT FK_Habilidade_Inimigo_3
        FOREIGN KEY (id_player)
        REFERENCES Inimigo (id_inimigo);
    ```

</details>

### V33_create_table_item_armazenado

Armazena itens no inventário dos jogadores.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Item_Armazenado (
        id_inventario INTEGER,
        id_item INTEGER,
        quantidade INTEGER NOT NULL,
        PRIMARY KEY (id_inventario, id_item)
    );
    
    ALTER TABLE Item_Armazenado ADD CONSTRAINT FK_Item_Armazenado_2
        FOREIGN KEY (id_inventario)
        REFERENCES Inventario (id_player);
    
    ALTER TABLE Item_Armazenado ADD CONSTRAINT FK_Item_Armazenado_3
        FOREIGN KEY (id_item)
        REFERENCES Tipo_Item (id_item);
    ```

</details>

### V34_create_item_elemento_dropa_table

Define itens que podem ser dropados por grupos de inimigos.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Item_grupo_inimigo_dropa (
        id_item INTEGER,
        id_grupo_inimigo INTEGER,
        quantidade INTEGER NOT NULL,
        PRIMARY KEY (id_item, id_grupo_inimigo)
    );
    
    ALTER TABLE Item_grupo_inimigo_dropa ADD CONSTRAINT FK_Item_grupo_inimigo_dropa_2
        FOREIGN KEY (id_item)
        REFERENCES Tipo_Item (id_item);
    
    ALTER TABLE Item_grupo_inimigo_dropa ADD CONSTRAINT FK_Item_grupo_inimigo_dropa_3
        FOREIGN KEY (id_grupo_inimigo)
        REFERENCES Grupo_inimigo (id_grupo);
    ```

</details>

### V38_create_table_textos

Estrutura a tabela "Texto" para armazenar textos do jogo.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE Texto (
        id SERIAL PRIMARY KEY,
        texto TEXT NOT NULL,
        nome_texto VARCHAR NOT NULL
    );
    ```

</details>

### V40_setup_initial

Cria funções para controle da movimentação dos jogadores entre salas.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION setar_sala_inicial(id_player_input INT)
    RETURNS VOID AS $$
    DECLARE
        sala_inicial_id INT;
        existe_na_party BOOLEAN;
    BEGIN
        -- Recupera o menor id_sala da tabela sala
        SELECT id_sala FROM public.sala_inicial;

        -- Verifica se existe uma sala
        IF sala_inicial_id IS NOT NULL THEN


            -- Verifica se o player já está na party
            SELECT EXISTS(
                SELECT 1 FROM public.party WHERE id_player = id_player_input
            ) INTO existe_na_party;

            -- Se já existir, apenas atualiza a sala
            IF existe_na_party THEN
                UPDATE public.party
                SET id_sala = sala_inicial_id
                WHERE id_player = id_player_input;
            ELSE
                -- Caso contrário, insere um novo registro na party
                INSERT INTO public.party (id_player, id_sala)
                VALUES (id_player_input, sala_inicial_id);
            END IF;
        ELSE
            RAISE EXCEPTION 'Nenhuma sala encontrada na tabela sala.';
        END IF;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION setar_nova_sala(id_player_input INT, id_sala_input INT)
    RETURNS VOID AS $$
    BEGIN
        -- Verifica se a sala existe
        IF EXISTS (SELECT 1 FROM public.sala WHERE id_sala = id_sala_input) THEN
            -- Atualiza o id_sala na tabela party para o jogador
            UPDATE public.party
            SET id_sala = id_sala_input
            WHERE id_player = id_player_input;

            -- Verifica se o jogador já está na tabela party, caso contrário, insere
            IF NOT FOUND THEN
                INSERT INTO public.party (id_player, id_sala)
                VALUES (id_player_input, id_sala_input);
            END IF;
        ELSE
            RAISE EXCEPTION 'Sala com id_sala % não encontrada.', id_sala_input;
        END IF;
    END;
    $$ LANGUAGE plpgsql;



    CREATE OR REPLACE FUNCTION get_salas_conectadas(id_player_input INT)
    RETURNS TABLE(id_sala INT, nome VARCHAR, direcao VARCHAR) AS $$
    BEGIN
        RETURN QUERY
        WITH salas_conectadas AS (
            SELECT s.id_sala_norte AS id_sala, CAST('Norte' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_norte IS NOT NULL
            UNION ALL
            SELECT s.id_sala_sul AS id_sala, CAST('Sul' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_sul IS NOT NULL
            UNION ALL
            SELECT s.id_sala_leste AS id_sala, CAST('Leste' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_leste IS NOT NULL
            UNION ALL
            SELECT s.id_sala_oeste AS id_sala, CAST('Oeste' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_oeste IS NOT NULL
        )
        SELECT sc.id_sala, s.nome, sc.direcao
        FROM salas_conectadas sc
        JOIN public.sala s ON sc.id_sala = s.id_sala;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION public.get_player_info(player_id integer)
    RETURNS text
    LANGUAGE plpgsql
    AS $function$
    BEGIN
        RETURN (
            SELECT STRING_AGG(
                FORMAT(
                    'Nome: %s %sNível: %s%sXP Acumulado: %s%sHP Máximo: %s%sMagia Máxima: %s%sHP Atual: %s%sMagia Atual: %s%sVelocidade: %s%sAtaque Físico : %s%sAtaque Mágico : %s%sElemento: %s',
                    p.nome, E'\n',
                    p.nivel, E'\n',
                    p.atual, E'\n',
                    p.hp_max, E'\n',
                    p.magia_max, E'\n',
                    p.hp_atual, E'\n',
                    p.magia_atual, E'\n',
                    p.velocidade, E'\n',
                    p.ataque_fisico, E'\n',
                    p.ataque_magico, E'\n',
                    e.nome
                ),
                E'\n'  -- Delimitador entre os registros (caso haja mais de um)
            )
            FROM player p
            INNER JOIN elemento e ON e.id_elemento = p.id_elemento
            WHERE p.id_player = player_id
        );
    END;
    $function$;


    CREATE OR REPLACE FUNCTION listar_jogadores_formatados()
    RETURNS TEXT AS $$
    BEGIN
        RETURN (
            SELECT STRING_AGG(
                FORMAT(
                    'Nome: %s Nível: %s Elemento: %s ',
                    p.nome,
                    p.nivel,
                    e.nome
                ),
                E'\n'  -- Delimitador entre as entradas
            )
            FROM 
                player p
            INNER JOIN 
                elemento e ON e.id_elemento = p.id_elemento
        );
    END;
    $$ LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION get_sala_atual(id_player_input INT)
    RETURNS TABLE(id_sala INT, nome_sala TEXT) AS $$
    BEGIN
        RETURN QUERY
        SELECT s.id_sala, s.nome::TEXT
        FROM sala s
        INNER JOIN party p ON s.id_sala = p.id_sala
        WHERE p.id_player = id_player_input;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION get_nome_sala(id_sala_input INT)
    RETURNS VARCHAR AS $$
    BEGIN
        RETURN (
            SELECT s.nome
            FROM sala s
            WHERE s.id_sala = id_sala_input
            LIMIT 1
        );
    END;
    $$ LANGUAGE plpgsql;
    ```

</details>

### V45_create_listar_jogadores_formatados

Define uma função para listar informações de jogadores formatadas.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION listar_jogadores_formatados_v2()
    RETURNS TABLE (
        id_player INTEGER,
        nome TEXT,
        nivel INTEGER,
        elemento TEXT,
        hp_max INTEGER,
        magia_max INTEGER,
        hp_atual INTEGER,
        magia_atual INTEGER,
        ataque_fisico INTEGER,
        ataque_magico INTEGER,
        dinheiro INTEGER
    ) AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            p.id_player,  -- Adicionando o ID do jogador
            p.nome::TEXT AS nome,  -- Nome do jogador (de player)
            p.nivel,
            e.nome::TEXT AS elemento,  -- Nome do elemento (de elemento)
            p.hp_max,
            p.magia_max, 
            p.hp_atual, 
            p.magia_atual, 
            p.ataque_fisico, 
            p.ataque_magico,
            i.dinheiro
        FROM player p
        INNER JOIN elemento e ON e.id_elemento = p.id_elemento
        INNER JOIN inventario i on i.id_player = p.id_player
        ORDER BY p.id_player;
    END;
    $$ LANGUAGE plpgsql;
    ```

</details>

### V47_create_table_audios

Cria a tabela "audios" para armazenar arquivos de áudio.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE TABLE audios (
        id SERIAL PRIMARY KEY,        
        nome TEXT NOT NULL,           
        nome_arquivo TEXT NOT NULL,   
        descricao TEXT               
    );
    ```

</details>

### V63_habilidade

Define funções para aprendizado de habilidades.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION aprender_habilidade(player_id INT, cavaleiro_id INT, habilidade_id INT)
    RETURNS TEXT AS $$
    DECLARE
        classe_habilidade INT;
        elemento_habilidade INT;
        classe_cavaleiro INT;
        elemento_personagem INT;
        slots_ocupados INT;
    BEGIN
        -- Verifica se a habilidade existe
        SELECT h.classe_habilidade, h.elemento_habilidade INTO classe_habilidade, elemento_habilidade
        FROM habilidade h
        WHERE h.id_habilidade = habilidade_id;
        
        IF NOT FOUND THEN
            RETURN 'Habilidade não encontrada.';
        END IF;
        
        -- Verifica se está aprendendo para o player ou cavaleiro
        IF cavaleiro_id IS NULL THEN
            -- Player pode aprender qualquer habilidade do seu elemento
            SELECT id_elemento INTO elemento_personagem FROM player_info_view WHERE id_player = player_id;
            
            IF elemento_habilidade != elemento_personagem THEN
                RETURN 'O Player não pode aprender essa habilidade (elemento incompatível).';
            END IF;

            -- Verifica se já tem 4 habilidades
            SELECT COUNT(*) INTO slots_ocupados FROM habilidade_player WHERE id_player = player_id;
            
            IF slots_ocupados >= 4 THEN
                RAISE EXCEPTION 'O Player já tem 4 habilidades. Substitua uma para aprender.';
            END IF;
            
            -- Adiciona a nova habilidade
            INSERT INTO habilidade_player (id_player, id_habilidade, slot)
            VALUES (player_id, habilidade_id, slots_ocupados + 1);
            
            RETURN 'Habilidade aprendida com sucesso pelo Player.';
        
        ELSE
            -- Cavaleiro só pode aprender habilidades da sua classe e elemento
            SELECT elemento_id, classe_id INTO elemento_personagem, classe_cavaleiro
            FROM instancia_cavaleiro_view WHERE id_cavaleiro = cavaleiro_id;

            IF classe_habilidade != classe_cavaleiro OR elemento_habilidade != elemento_personagem THEN
                RAISE EXCEPTION 'O Cavaleiro não pode aprender essa habilidade (classe ou elemento incompatível).';
            END IF;
            
            -- Verifica se já tem 4 habilidades
            SELECT COUNT(*) INTO slots_ocupados FROM habilidade_cavaleiro WHERE id_cavaleiro = cavaleiro_id;
            
            IF slots_ocupados >= 4 THEN
                RAISE EXCEPTION 'O Cavaleiro já tem 4 habilidades. Substitua uma para aprender.';
            END IF;
            
            -- Adiciona a nova habilidade
            INSERT INTO habilidade_cavaleiro (id_cavaleiro, id_habilidade, slot)
            VALUES (cavaleiro_id, habilidade_id, slots_ocupados + 1);
            
            RETURN 'Habilidade aprendida com sucesso pelo Cavaleiro.';
        END IF;
    END $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION reduzir_item_armazenado()
    RETURNS TRIGGER AS $$
    DECLARE
        id_livro INT;
        player_id INT;
    BEGIN
        -- Obtém o ID do livro relacionado à habilidade aprendida
        SELECT id_item INTO id_livro 
        FROM livro 
        WHERE id_habilidade = NEW.id_habilidade;

        -- Obtém o ID do player (caso seja um cavaleiro, pegamos do cavaleiro correspondente)
        IF TG_TABLE_NAME = 'habilidade_player' THEN
            player_id := NEW.id_player;
        ELSIF TG_TABLE_NAME = 'habilidade_cavaleiro' THEN
            SELECT id_player INTO player_id
            FROM instancia_cavaleiro
            WHERE id_cavaleiro = NEW.id_cavaleiro;
        END IF;

        -- Atualiza a quantidade do item no inventário do jogador
        UPDATE item_armazenado
        SET quantidade = quantidade - 1
        WHERE id_inventario = player_id
        AND id_item = id_livro;

        -- Remove o item do inventário se a quantidade for 0
        DELETE FROM item_armazenado
        WHERE id_inventario= player_id
        AND id_item = id_livro
        AND quantidade <= 0;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;



    CREATE TRIGGER trigger_reduzir_item_habilidade_player
    AFTER INSERT ON habilidade_player
    FOR EACH ROW
    EXECUTE FUNCTION reduzir_item_armazenado();


    CREATE TRIGGER trigger_reduzir_item_habilidade_cavaleiro
    AFTER INSERT ON habilidade_cavaleiro
    FOR EACH ROW
    EXECUTE FUNCTION reduzir_item_armazenado();
    ```

</details>

### V103_insert_npcs

Insere NPCs no jogo, incluindo ferreiros, mercadores e personagens de missões.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO public.ferreiro (id_sala, id_missao_desbloqueia, nome, descricao, dialogo_inicial, dialogo_reparar, dialogo_upgrade, dialogo_desmanchar, dialogo_sair) 
    VALUES (3, 1, 'Mu de Áries', 'O principal reparador de armaduras no universo de Cavaleiros do Zodíaco, Mu é a escolha perfeita para ser o ferreiro.', 'Bem-vindo, Cavaleiro. As armaduras são a essência de sua força. O que você busca hoje?', 'Vejo que sua armadura sofreu em batalhas árduas... Deixe-me restaurá-la ao seu esplendor original. Um Cavaleiro deve sempre proteger sua essência.', 'Com a sinergia entre seu cosmo e minha maestria, posso aprimorar sua armadura. Prepare-se para enfrentar desafios ainda maiores!', 'Cada armadura carrega a energia de seu antigo dono... Se desejar, posso extrair essa essência para transformá-la em uma Alma de Armadura. Mas lembre-se, uma vez feito, não há volta.', 'Seu caminho é longo, Cavaleiro. Que sua armadura sempre o proteja. Volte sempre que precisar.');

    INSERT INTO public.mercador( id_sala, nome, descricao, dialogo_inicial, dialogo_vender, dialogo_comprar, dialogo_sair)
    VALUES(1, 'Jabu de Unicórnio', 'Jabu é um Cavaleiro prático e secundário, sempre disposto a ajudar. Ele se encaixa perfeitamente como um mercador de itens básicos e úteis.', 'Ah, Cavaleiro, chegou na hora certa! Estou com itens que podem ser exatamente o que você procura, e se tiver algo para vender, vamos negociar – nada escapa do meu faro para bons negócios!', 'Então, Cavaleiro, o que você tem para me oferecer? Estou sempre em busca de algo útil... mas espero que seja algo que valha o meu tempo.', 'Você está comprando algo? Vamos negociar o preço.', 'Volte sempre que precisar de algo. Até mais, Cavaleiro!');

    INSERT INTO public.quest( id_sala, nome, descricao, dialogo_inicial, dialogo_recusa)
    VALUES(2, 'Saori Kido', 'A deusa Athena, protetora da Terra, é uma guia espiritual e estratégica para os Cavaleiros do Zodíaco, sempre fornecendo missões importantes.', 'Cavaleiro, sua coragem e lealdade são indispensáveis. A batalha que se aproxima será decisiva. Posso contar com você?', 'Eu entendo que você não está pronto no momento. Mas lembre-se, o mundo depende de nós. Volte quando estiver preparado.');

    CREATE OR REPLACE FUNCTION verificar_npc_na_sala(id_jogador INTEGER)
    RETURNS TEXT AS $$
    DECLARE
        id_sala_atual INTEGER;
        tipo_npc TEXT;
    BEGIN
        SELECT id_sala
        INTO id_sala_atual
        FROM Party pa join Player pl
        ON pl.id_player = pa.id_player
        WHERE pl.id_player = id_jogador;

        SELECT CASE
            WHEN EXISTS (SELECT 1 FROM ferreiro WHERE id_sala = id_sala_atual) THEN 'Ferreiro'
            WHEN EXISTS (SELECT 1 FROM quest WHERE id_sala = id_sala_atual) THEN 'Missao'
            WHEN EXISTS (SELECT 1 FROM mercador WHERE id_sala = id_sala_atual) THEN 'Mercador'
            ELSE NULL
        END
        INTO tipo_npc;

        RETURN tipo_npc;
    END;
    $$ LANGUAGE plpgsql;
    ```

</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
|  0.1 | 13/01/2025 | Criação do Documento | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  1.0 | 22/01/2025 | Add o Set Up inicial | Lucas Ramon |
|  1.1 | 22/01/2025 | Atualização do DDL | Lucas Ramon |
|  2.0 | 02/02/2025 | Atualização do Documento | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  2.1 | 03/02/2025 | Atualização do DDL | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  2.2 | 10/02/2025 | Atualização do DDL e Adição da Toggle List | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  3.0 | 13/02/2025 | Atualização e refatoração do documento para versão final | [Vinícius Rufino](https://github.com/RufinoVfR) |