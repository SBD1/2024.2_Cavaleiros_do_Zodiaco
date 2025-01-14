## DDL

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
|  0.1 | 13/01/2025 | Criação do Documento | Vinícius Rufino |

```sql
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
    xp_acumulado INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    hp_atual INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico_base INTEGER NOT NULL,
    ataque_magico_base INTEGER NOT NULL,
    id_sala_safe INTEGER NOT NULL
);
 
ALTER TABLE Player ADD CONSTRAINT FK_Player_2
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);
    
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
 
ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_2
    FOREIGN KEY (elemento_habilidade)
    REFERENCES Elemento (id_elemento);
 
ALTER TABLE Habilidade ADD CONSTRAINT FK_Habilidade_3
    FOREIGN KEY (classe_habilidade)
    REFERENCES Classe (id_classe);
    
CREATE TYPE tipo_item as ENUM ('a', 'm', 'i', 'c', 'l'); /* a = armadura, m = material, i = item_missao, c = consumivel, l = livro */
CREATE TYPE parte_corpo as ENUM ('c', 't', 'b', 'p'); /* c = cabeça, t = tronco, b = braços, p = pernas */

DROP TYPE parte_corpo;
DROP TYPE tipo_item;

CREATE TYPE enum_tipo_item as ENUM ('a', 'm', 'i', 'c', 'l'); /* a = armadura, m = material, i = item_missao, c = consumivel, l = livro */
CREATE TYPE enum_parte_corpo as ENUM ('c', 't', 'b', 'p'); /* c = cabeça, t = tronco, b = braços, p = pernas */

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
    tipo_item INTEGER NOT NULL
);

CREATE TABLE Armadura (
    id_armadura INTEGER,
    id_parte_corpo enum_parte_corpo,
    nome VARCHAR NOT NULL,
    raridade_armadura VARCHAR NOT NULL,
    defesa_magica INTEGER,
    defesa_fisica INTEGER,
    ataque_magico INTEGER,
    ataque_fisico INTEGER,
    durabilidade_max INTEGER,
    preco_venda INTEGER,
    descricao INTEGER,
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
    
CREATE TABLE Missao (
    id_missao SERIAL PRIMARY KEY,
    id_missao_anterior INTEGER,
    item_necessario INTEGER NOT NULL,
    nome INTEGER UNIQUE NOT NULL,
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
 




ALTER TABLE Cavaleiro ADD CONSTRAINT FK_Cavaleiro_2
    FOREIGN KEY (id_classe)
    REFERENCES Classe (id_classe);
 
ALTER TABLE Cavaleiro ADD CONSTRAINT FK_Cavaleiro_3
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);
    
CREATE TABLE Boss (
    id_boss SERIAL PRIMARY KEY,
    id_sala INTEGER NOT NULL,
    nome INTEGER NOT NULL,
    nivel INTEGER NOT NULL,
    xp_acumulado INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    hp_atual INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico_base INTEGER NOT NULL,
    ataque_magico_base INTEGER NOT NULL,
    dinheiro INTEGER NOT NULL,
    fala_inicio VARCHAR,
    fala_derrotar_player VARCHAR,
    fala_derrotado VARCHAR,
    fala_condicao VARCHAR
);
 
ALTER TABLE Boss ADD CONSTRAINT FK_Boss_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);
    
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
 
ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_2
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);
 
ALTER TABLE Inimigo ADD CONSTRAINT FK_Inimigo_3
    FOREIGN KEY (id_classe)
    REFERENCES Classe (id_classe);
    
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
 
ALTER TABLE Instancia_Inimigo ADD CONSTRAINT FK_Instancia_Inimigo_2
    FOREIGN KEY (id_inimigo)
    REFERENCES Inimigo (id_inimigo);
 
ALTER TABLE Instancia_Inimigo ADD CONSTRAINT FK_Instancia_Inimigo_3
    FOREIGN KEY (id_grupo)
    REFERENCES Grupo_inimigo (id_grupo);

ALTER TABLE Grupo_inimigo ADD CONSTRAINT FK_Grupo_inimigo_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);
    
CREATE TABLE Inventario (
    id_player INTEGER PRIMARY KEY,
    dinheiro INTEGER NOT NULL
);
 
ALTER TABLE Inventario ADD CONSTRAINT FK_Inventario_1
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);
    
CREATE TABLE Armadura_Instancia (
    id_armadura INTEGER,
    id_parte_corpo_armadura enum_parte_corpo,
    id_instancia SERIAL,
    id_inventario INTEGER,
    raridade_armadura INTEGER NOT NULL,
    defesa_magica INTEGER NOT NULL,
    defesa_fisica INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL, 
    durabilidade_max INTEGER NOT NULL,
    preco_venda INTEGER NOT NULL,
    PRIMARY KEY (id_armadura, id_instancia, id_parte_corpo_armadura)
);
 
ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_2
    FOREIGN KEY (id_armadura, id_parte_corpo_armadura)
    REFERENCES Armadura (id_armadura, id_parte_corpo);
 
ALTER TABLE Armadura_Instancia ADD CONSTRAINT FK_Armadura_Instancia_3
    FOREIGN KEY (id_inventario)
    REFERENCES Inventario (id_player);
    
CREATE TABLE Item_a_venda (
    id_item INTEGER PRIMARY KEY,
    preco_compra INTEGER NOT NULL,
    level_minimo INTEGER NOT NULL
);
 
ALTER TABLE Item_a_venda ADD CONSTRAINT FK_Item_a_venda_2
    FOREIGN KEY (id_item)
    REFERENCES Tipo_Item (id_item);
    
CREATE TABLE Party (
    id_player INTEGER PRIMARY KEY,
    id_sala INTEGER
);
 
ALTER TABLE Party ADD CONSTRAINT FK_Party_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);
    
CREATE TABLE Instancia_Cavaleiro (
    id_instancia_cavaleiro SERIAL,
    id_cavaleiro INTEGER NOT NULL,
    id_party INTEGER,
    nivel INTEGER NOT NULL,
    xp_atual INTEGER NOT NULL,
    hp_max INTEGER NOT NULL,
    magia_max INTEGER NOT NULL,
    hp_atual INTEGER NOT NULL,
    magia_atual INTEGER NOT NULL,
    velocidade INTEGER NOT NULL,
    ataque_fisico INTEGER NOT NULL,
    ataque_magico INTEGER NOT NULL,
    PRIMARY KEY (id_cavaleiro, id_instancia_cavaleiro)
);
 
ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_2
    FOREIGN KEY (id_cavaleiro)
    REFERENCES Cavaleiro (id_cavaleiro);
 
ALTER TABLE Instancia_Cavaleiro ADD CONSTRAINT FK_Instancia_Cavaleiro_3
    FOREIGN KEY (id_party)
    REFERENCES Party (id_player);
    
CREATE TABLE Progresso_Player (
    id_player INTEGER ,
    id_boss INTEGER,
    id_cavaleiro INTEGER ,
    status_derrotado BOOLEAN,
    PRIMARY KEY (id_player, id_boss)
);
 
ALTER TABLE Progresso_Player ADD CONSTRAINT FK_Progresso_Player_2
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);
 
ALTER TABLE Progresso_Player ADD CONSTRAINT FK_Progresso_Player_3
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);
 
ALTER TABLE Progresso_Player ADD CONSTRAINT FK_Progresso_Player_4
    FOREIGN KEY (id_cavaleiro)
    REFERENCES Cavaleiro (id_cavaleiro);
    
CREATE TABLE Receita (
    id_item_gerado INTEGER PRIMARY KEY,
    descricao VARCHAR
);
 
ALTER TABLE Receita ADD CONSTRAINT FK_Receita_2
    FOREIGN KEY (id_item_gerado)
    REFERENCES Tipo_Item (id_item);
    
CREATE TYPE enum_status_missao as ENUM ('c','i','ni'); /* c = completo, i=iniciado,ni=não iniciado*/
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
 
ALTER TABLE Material_Receita ADD CONSTRAINT FK_Material_Receita_2
    FOREIGN KEY (id_material)
    REFERENCES Material (id_material);
 
ALTER TABLE Material_Receita ADD CONSTRAINT FK_Material_Receita_3
    FOREIGN KEY (id_receita)
    REFERENCES Receita (id_item_gerado);
    
CREATE TABLE Habilidade_Player (
    id_player INTEGER,
    id_habilidade INTEGER,
    slot INTEGER NOT NULL,
    PRIMARY KEY (id_player, id_habilidade, slot)
);
 
ALTER TABLE Habilidade_Player ADD CONSTRAINT FK_Habilidade_Player_2
    FOREIGN KEY (id_habilidade)
    REFERENCES Habilidade (id_habilidade);
 
ALTER TABLE Habilidade_Player ADD CONSTRAINT FK_Habilidade_Player_3
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);
    
CREATE TABLE Habilidade_Cavaleiro (
    id_cavaleiro INTEGER,
    id_habilidade INTEGER,
    slot INTEGER NOT NULL,
    PRIMARY KEY (id_cavaleiro, id_habilidade, slot)
);
 
ALTER TABLE Habilidade_Cavaleiro ADD CONSTRAINT FK_Habilidade_Cavaleiro_2
    FOREIGN KEY (id_cavaleiro)
    REFERENCES Cavaleiro (id_cavaleiro);
 
ALTER TABLE Habilidade_Cavaleiro ADD CONSTRAINT FK_Habilidade_Cavaleiro_3
    FOREIGN KEY (id_habilidade)
    REFERENCES Habilidade (id_habilidade);
    
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
    
CREATE TABLE Parte_Corpo_Boss (
    id_boss INTEGER,
    parte_corpo enum_parte_corpo,
    defesa_fisica INTEGER NOT NULL,
    defesa_magica INTEGER NOT NULL,
    chance_acerto_base INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL,
    PRIMARY KEY (id_boss, parte_corpo)
);
 
ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_2
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);
 
ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_3
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);
    
CREATE TABLE Parte_Corpo_Cavaleiro (
    id_cavaleiro INTEGER,
    parte_corpo enum_parte_corpo,
    id_instancia_cavaleiro INTEGER NOT NULL,
    defesa_fisica_bonus INTEGER NOT NULL,
    defesa_magico_bonus INTEGER NOT NULL,
    chance_acerto_base INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL,
    PRIMARY KEY (id_cavaleiro, parte_corpo)
);
 
ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_2
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);
 
ALTER TABLE Parte_Corpo_Cavaleiro ADD CONSTRAINT FK_Parte_Corpo_Cavaleiro_3
    FOREIGN KEY (id_instancia_cavaleiro, id_cavaleiro)
    REFERENCES Instancia_Cavaleiro (id_instancia_cavaleiro, id_cavaleiro);
    
CREATE TABLE Parte_Corpo_Player (
    id_player INTEGER,
    parte_corpo enum_parte_corpo,
    armadura_equipada INTEGER,
    instancia_armadura_equipada INTEGER,
    PRIMARY KEY (id_player, parte_corpo)
);
 
ALTER TABLE Parte_Corpo_Player ADD CONSTRAINT FK_Parte_Corpo_Player_2
    FOREIGN KEY (id_player)
    REFERENCES Player (id_player);
 
ALTER TABLE Parte_Corpo_Player ADD CONSTRAINT FK_Parte_Corpo_Player_3
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);
 
ALTER TABLE Parte_Corpo_Player ADD CONSTRAINT FK_Parte_Corpo_Player_4
    FOREIGN KEY (armadura_equipada, instancia_armadura_equipada, parte_corpo)
    REFERENCES Armadura_Instancia (id_armadura, id_instancia, id_parte_corpo_armadura);
    
CREATE TABLE Elemento_Boss (
    id_elemento INTEGER,
    id_boss INTEGER,
    PRIMARY KEY (id_boss, id_elemento)
);
 
ALTER TABLE Elemento_Boss ADD CONSTRAINT FK_Elemento_Boss_1
    FOREIGN KEY (id_elemento)
    REFERENCES Elemento (id_elemento);
 
ALTER TABLE Elemento_Boss ADD CONSTRAINT FK_Elemento_Boss_2
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);
    
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
    
CREATE TABLE Texto (
    id SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    nome_texto VARCHAR NOT NULL
);

INSERT INTO Texto (nome_texto, texto)
VALUES (
'logo', 
'     ______                           __          _                                      __               _____              __    _
-    / ____/  ____ _ _   __  ____ _   / /  ___    (_)   _____  ____    _____         ____/ /  ____        /__  /  ____   ____/ /   (_)  ____ _  _____  ____
-   / /      / __ `/| | / / / __ `/  / /  / _ \  / /   / ___/ / __ \  / ___/        / __  /  / __ \         / /  / __ \ / __  /   / /  / __ `/ / ___/ / __ \
-  / /___   / /_/ / | |/ / / /_/ /  / /  /  __/ / /   / /    / /_/ / (__  )        / /_/ /  / /_/ /        / /__/ /_/ // /_/ /   / /  / /_/ / / /__  / /_/ /
-  \____/   \__,_/  |___/  \__,_/  /_/   \___/ /_/   /_/     \____/ /____/         \__,_/   \____/        /____/\____/ \__,_/   /_/   \__,_/  \___/  \____/'    
);

INSERT INTO Texto (nome_texto, texto)
VALUES ('introducao', 
'Desde tempos imemoriais, quando o mal ameaçou dominar o mundo, guerreiros sagrados se ergueram para proteger a paz na Terra. Vestindo armaduras forjadas pelas constelações, eles lutaram com coragem e honra em nome da deusa Atena. Esses guerreiros são conhecidos como os lendários Cavaleiros do Zodíaco.

Agora, as forças sombrias despertam mais uma vez, e o equilíbrio do mundo está em perigo. Somente aqueles com um coração puro e a força do Cosmo poderão enfrentar o destino e erguer-se como verdadeiros defensores da justiça.

Prepare-se para vestir sua armadura, elevar seu Cosmo e escrever sua própria lenda. A batalha pelo futuro da humanidade começa agora!'
);

CREATE OR REPLACE FUNCTION public.mudar_sala(id_player_input INTEGER, direcao TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $function$
DECLARE
    nova_sala_id INTEGER;
BEGIN
    -- Verifica a sala conectada na direção especificada
    SELECT CASE LOWER(direcao)
        WHEN 'norte' THEN s.id_sala_norte
        WHEN 'sul'   THEN s.id_sala_sul
        WHEN 'leste' THEN s.id_sala_leste
        WHEN 'oeste' THEN s.id_sala_oeste
        ELSE NULL
    END INTO nova_sala_id
    FROM public.sala s
    JOIN public.party p ON p.id_sala = s.id_sala
    WHERE p.id_player = id_player_input;

    -- Verifica se a sala existe e atualiza a localização da party
    IF nova_sala_id IS NOT NULL THEN
        UPDATE public.party
        SET id_sala = nova_sala_id
        WHERE id_player = id_player_input;
    ELSE
        RAISE NOTICE 'Movimento inválido: Não há sala conectada nessa direção.';
    END IF;
END;
$function$;

```
