#### **Personagem**

## Personagem

| Tabela       | Personagem                                                                                                     |
|--------------|--------------------------------------------------------------------------------------------------------------|
| Descrição    | Armazena informações sobre os personagens                                                                     |
| Observações  | Nenhuma                                                                                                       |

### Campos

| Nome          | Descrição                        | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|---------------|----------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_personagem | Identificador único do personagem | Int          | Somente valores únicos e inteiros |         | PK / Identity                                                       |
| nome          | Nome do personagem               | Varchar      | Texto              | 255     | Not Null                                                            |

---

#### **Player**

## Player

| Tabela       | Player                                                                                                        |
|--------------|-------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa um jogador no sistema                                                                             |
| Observações  | FK referenciando Personagem                                                                                  |

### Campos

| Nome          | Descrição                        | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|---------------|----------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_personagem | Identificador único do personagem | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |

---

#### **NPC Quest**

## NPC Quest

| Tabela       | NPC Quest                                                                                                    |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Contém diálogos dos NPCs relacionados a quests                                                              |
| Observações  | FK referenciando Personagem                                                                                 |

### Campos

| Nome            | Descrição                              | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|-----------------|---------------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_personagem   | Identificador único do NPC             | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |
| dialogo_inicial | Diálogo inicial                        | Text         | Texto              |         | Not Null                                                            |
| dialogo_recusa  | Diálogo em caso de recusa da quest     | Text         | Texto              |         | Not Null                                                            |

---

#### **NPC Mercado**

## NPC Mercado

| Tabela       | NPC Mercado                                                                                                  |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Contém diálogos de NPCs relacionados a mercados                                                             |
| Observações  | FK referenciando Personagem                                                                                 |

### Campos

| Nome            | Descrição                              | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|-----------------|---------------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_personagem   | Identificador único do NPC             | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |
| dialogo_inicial | Diálogo inicial                        | Text         | Texto              |         | Not Null                                                            |
| dialogo_vender  | Diálogo ao vender item                 | Text         | Texto              |         | Not Null                                                            |
| dialogo_comprar | Diálogo ao comprar item                | Text         | Texto              |         | Not Null                                                            |
| dialogo_sair    | Diálogo ao sair                        | Text         | Texto              |         | Not Null                                                            |

---

#### **Party**

## Party

| Tabela       | Party                                                                                                        |
|--------------|-------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa a relação entre jogadores e salas                                                                |
| Observações  | FK referenciando Player e Sala                                                                              |

### Campos

| Nome      | Descrição                  | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|-----------|---------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_player | Identificador único do player | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |
| id_sala   | Identificador único da sala | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |

---

#### **Inventário**

## Inventário

| Tabela       | Inventário                                                                                                   |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Armazena informações sobre o inventário dos jogadores                                                       |
| Observações  | FK referenciando Player                                                                                     |

### Campos

| Nome      | Descrição                         | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|-----------|-----------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_player | Identificador único do player     | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |
| dinheiro  | Quantidade de dinheiro do jogador | Decimal      | Valores decimais   |         | Not Null                                                            |

---

#### **Progresso Jogador**

## Progresso Jogador

| Tabela       | Progresso Jogador                                                                                           |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa o progresso do jogador                                                                           |
| Observações  | FK referenciando Player e Boss                                                                              |

### Campos

| Nome                | Descrição                            | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|---------------------|--------------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_player           | Identificador único do jogador       | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |
| id_boss             | Identificador único do boss          | Int          | Somente valores únicos e inteiros |         | FK                                                                  |
| status_derrotado    | Status de derrota do boss            | Boolean      | true, false        |         | Not Null                                                            |
| cavaleiro_desbloqueado | Cavaleiro desbloqueado pelo progresso | Boolean      | true, false        |         | Not Null                                                            |

---

#### **Personagem Luta**

## Personagem Luta

| Tabela       | Personagem Luta                                                                                              |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa as estatísticas de combate de personagens                                                        |
| Observações  | FK referenciando Personagem                                                                                 |

### Campos

| Nome          | Descrição                         | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|---------------|-----------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_personagem | Identificador único do personagem | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |
| nivel         | Nível do personagem               | Int          | Valores inteiros maiores ou iguais a 1 |         | Not Null                                                            |
| hp_max        | Vida máxima                       | Int          | Valores inteiros maiores ou iguais a 0 |         | Not Null                                                            |
| hp_atual      | Vida atual                        | Int          | Valores inteiros maiores ou iguais a 0 |         | Not Null                                                            |
| magia_max     | Magia máxima                      | Int          | Valores inteiros maiores ou iguais a 0 |         | Not Null                                                            |
| magia_atual   | Magia atual                       | Int          | Valores inteiros maiores ou iguais a 0 |         | Not Null                                                            |
| velocidade    | Velocidade                        | Int          | Valores inteiros maiores ou iguais a 0 |         | Not Null                                                            |

---

#### **Cavaleiro**

## Cavaleiro

| Tabela       | Cavaleiro                                                                                                    |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa os cavaleiros do sistema                                                                         |
| Observações  | FK referenciando Personagem                                                                                 |

### Campos

| Nome          | Descrição                         | Tipo de Dado | Valores Permitidos | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|---------------|-----------------------------------|--------------|--------------------|---------|----------------------------------------------------------------------|
| id_personagem | Identificador único do personagem | Int          | Somente valores únicos e inteiros |         | PK / FK                                                             |
| desbloqueado  | Status de desbloqueio do cavaleiro | Boolean      | true, false        |         | Not Null                                                            |
| classe        | Classe do cavaleiro               | Varchar      | Texto              | 50      | Not Null                                                            |

---

#### **Sala**

## Sala

| Tabela       | Sala                                                                                                         |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa as salas do sistema                                                                              |
| Observações  | Nenhuma                                                                                                     |

### Campos

| Nome         | Descrição                         | Tipo de Dado | Valores Permitidos                  | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|--------------|-----------------------------------|--------------|-------------------------------------|---------|----------------------------------------------------------------------|
| id_sala      | Identificador único da sala       | Int          | Somente valores únicos e inteiros  |         | PK / Identity                                                       |
| nome         | Nome da sala                      | Varchar      | Texto                               | 255     | Not Null                                                            |
| sala_norte   | ID da sala ao norte               | Int          | Inteiro ou nulo                     |         | FK                                                                  |
| sala_sul     | ID da sala ao sul                 | Int          | Inteiro ou nulo                     |         | FK                                                                  |
| sala_leste   | ID da sala ao leste               | Int          | Inteiro ou nulo                     |         | FK                                                                  |
| sala_oeste   | ID da sala ao oeste               | Int          | Inteiro ou nulo                     |         | FK                                                                  |

---

#### **Santuário**

## Santuário

| Tabela       | Santuário                                                                                                    |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa os santuários do sistema                                                                         |
| Observações  | Nenhuma                                                                                                     |

### Campos

| Nome            | Descrição                         | Tipo de Dado | Valores Permitidos                  | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|-----------------|-----------------------------------|--------------|-------------------------------------|---------|----------------------------------------------------------------------|
| id_santuario    | Identificador único do santuário | Int          | Somente valores únicos e inteiros  |         | PK / Identity                                                       |
| nome            | Nome do santuário                | Varchar      | Texto                               | 255     | Not Null                                                            |
| descricao       | Descrição do santuário           | Text         | Texto                               |         | Not Null                                                            |
| id_pre_req_missao | ID da missão pré-requisito      | Int          | Inteiro ou nulo                     |         | FK                                                                  |

---

#### **Grupo Inimigo**

## Grupo Inimigo

| Tabela       | Grupo Inimigo                                                                                                |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa os grupos de inimigos presentes nas salas                                                        |
| Observações  | FK referenciando Sala                                                                                       |

### Campos

| Nome            | Descrição                         | Tipo de Dado | Valores Permitidos                  | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|-----------------|-----------------------------------|--------------|-------------------------------------|---------|----------------------------------------------------------------------|
| id_grupo_inimigo | Identificador único do grupo    | Int          | Somente valores únicos e inteiros  |         | PK / Identity                                                       |
| id_sala         | Identificador da sala            | Int          | Somente valores inteiros            |         | FK                                                                  |

---

#### **Missão**

## Missão

| Tabela       | Missão                                                                                                       |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa as missões do sistema                                                                            |
| Observações  | Nenhuma                                                                                                     |

### Campos

| Nome            | Descrição                         | Tipo de Dado | Valores Permitidos                  | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|-----------------|-----------------------------------|--------------|-------------------------------------|---------|----------------------------------------------------------------------|
| id_missao       | Identificador único da missão    | Int          | Somente valores únicos e inteiros  |         | PK / Identity                                                       |
| nome            | Nome da missão                   | Varchar      | Texto                               | 255     | Not Null                                                            |
| item_necessario | Item necessário para a missão    | Int          | Somente valores inteiros ou nulo   |         | FK                                                                  |
| dialogo_inicial | Diálogo inicial da missão        | Text         | Texto                               |         | Not Null                                                            |
| dialogo_durante | Diálogo durante a missão         | Text         | Texto                               |         | Not Null                                                            |
| dialogo_completa| Diálogo ao completar a missão    | Text         | Texto                               |         | Not Null                                                            |

---

#### **Missão Jogador**

## Missão Jogador

| Tabela       | Missão Jogador                                                                                               |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Relaciona jogadores às missões                                                                              |
| Observações  | FK referenciando Missão e Player                                                                             |

### Campos

| Nome          | Descrição                         | Tipo de Dado | Valores Permitidos                  | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|---------------|-----------------------------------|--------------|-------------------------------------|---------|----------------------------------------------------------------------|
| id_missao     | Identificador único da missão    | Int          | Somente valores inteiros            |         | PK / FK                                                             |
| id_jogador    | Identificador único do jogador   | Int          | Somente valores inteiros            |         | PK / FK                                                             |

---

#### **Item**

## Item

| Tabela       | Item                                                                                                         |
|--------------|------------------------------------------------------------------------------------------------------------|
| Descrição    | Representa os itens disponíveis no sistema                                                                  |
| Observações  | Nenhuma                                                                                                     |

### Campos

| Nome          | Descrição                         | Tipo de Dado | Valores Permitidos                  | Tamanho | Restrições de Domínio (PK, FK, Not Null, Check, Default, Identity) |
|---------------|-----------------------------------|--------------|-------------------------------------|---------|----------------------------------------------------------------------|
| id_item       | Identificador único do item      | Int          | Somente valores únicos e inteiros  |         | PK / Identity                                                       |
| nome          | Nome do item                     | Varchar      | Texto                   