## Introdução
Este projeto utiliza um banco de dados relacional para gerenciar informações dos NPCs (personagens não jogáveis), missões e salas dentro do jogo. A estrutura foi desenvolvida utilizando comandos SQL, com o uso de DDL (Data Definition Language) para criar e alterar tabelas e DML (Data Manipulation Language) para manipulação dos dados.

O objetivo desta documentação é detalhar como o banco foi estruturado e apresentar exemplos práticos de DDL e DML.

---

## Estrutura do Banco de Dados

### Principais Tabelas

1. **Npc_Ferreiro**:
   - Gerencia informações sobre ferreiros no jogo.
   - Contém colunas como:
     - `id_npc_ferreiro`: Identificador único.
     - `id_sala`: Relaciona a sala onde o ferreiro está localizado.
     - Campos descritivos como `nome`, `descricao` e diálogos (ex.: `dialogo_inicial`).

2. **Npc_Quest**:
   - Armazena informações sobre NPCs que oferecem missões.
   - Principais colunas:
     - `id_npc_quest`: Identificador único.
     - `id_sala`: Relaciona a sala onde o NPC está localizado.
     - `nome` e `descricao` do NPC.

3. **Npc_Mercador**:
   - Contém dados sobre mercadores no jogo.
   - Principais colunas:
     - `id_npc_mercador`: Identificador único.
     - `id_sala`: Relaciona a sala onde o mercador está.
     - Campos como `dialogo_comprar`, `dialogo_vender` e `dialogo_sair`.

### Diagrama de Relacionamento
**Figura 1 - DER**

<iframe 
    frameborder="0" 
    width="100%" 
    height="600px"
    src="https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=DER%202.0.drawio#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1hnu9QFhT-UIqXl9tar8-YFjfSFKe8fRg%26export%3Ddownload">
</iframe>

---

## Comandos DDL (Data Definition Language)

### Criação de Tabelas
Abaixo está um exemplo de como a tabela `Npc_Ferreiro` foi criada:

```sql
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
```
#### Alteração de tabelas 

```sql
-- Adiciona uma chave estrangeira que conecta Npc_Ferreiro à tabela Sala
ALTER TABLE Npc_Ferreiro ADD CONSTRAINT FK_Npc_Ferreiro_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);

-- Adiciona uma chave estrangeira que conecta Npc_Ferreiro à tabela Missao
ALTER TABLE Npc_Ferreiro ADD CONSTRAINT FK_Npc_Ferreiro_3
    FOREIGN KEY (id_missao_desbloqueia)
    REFERENCES Missao (id_missao);
```

# Comandos DML (Data Mnaipulation Language)
## Inseção de dados
Abaixo, um exemplo de inserção de dados na tabela Npc_Ferreiro:

```sql
INSERT INTO Npc_Ferreiro (id_npc_ferreiro, id_sala, id_missao_desbloqueia, nome, descricao)
VALUES (1, 2, 3, 'Ferreiro João', 'Especialista em armas pesadas');
```

## Consulta, Arualização e Exclusao de dados
Abaixo seguem exemplos dessas três operações.

```sql
SELECT * FROM Npc_Ferreiro;
SELECT * FROM Npc_Ferreiro;
UPDATE Npc_Ferreiro
SET descricao = 'Especialista em armaduras'
WHERE id_npc_ferreiro = 1;
DELETE FROM Npc_Ferreiro
WHERE id_npc_ferreiro = 1;
```
