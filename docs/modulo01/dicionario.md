# Dicionário de Dados

## Tabelas e Relações

### Tabela: **Npc_Ferreiro**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_npc_ferreiro`              | INTEGER  | PRIMARY KEY                                                                 |
| `id_sala`                      | INTEGER  | FOREIGN KEY (`id_sala`) REFERENCES `Sala(id_sala)`                         |
| `id_missao_desbloqueia`        | INTEGER  | FOREIGN KEY (`id_missao_desbloqueia`) REFERENCES `Missao(id_missao)`       |
| `nome`                         | VARCHAR  | NOT NULL                                                                     |
| `descricao`                    | VARCHAR  |                                                                             |
| `dialogo_inicial`              | VARCHAR  |                                                                             |
| `dialogo_reparar`              | VARCHAR  |                                                                             |
| `dialogo_upgrade`              | VARCHAR  |                                                                             |

---

### Tabela: **Npc_Quest**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_npc_quest`                 | INTEGER  | PRIMARY KEY                                                                 |
| `id_sala`                      | INTEGER  | FOREIGN KEY (`id_sala`) REFERENCES `Sala(id_sala)`                         |
| `nome`                         | VARCHAR  | NOT NULL                                                                     |
| `descricao`                    | VARCHAR  |                                                                             |
| `dialogo_inicial`              | VARCHAR  |                                                                             |
| `dialogo_recusa`               | VARCHAR  |                                                                             |

---

### Tabela: **Npc_Mercador**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_npc_mercador`              | INTEGER  | PRIMARY KEY                                                                 |
| `id_sala`                      | INTEGER  | FOREIGN KEY (`id_sala`) REFERENCES `Sala(id_sala)`                         |
| `nome`                         | VARCHAR  | NOT NULL                                                                     |
| `descricao`                    | VARCHAR  |                                                                             |
| `dialogo_inicial`              | VARCHAR  |                                                                             |
| `dialogo_vender`               | VARCHAR  |                                                                             |
| `dialogo_comprar`              | VARCHAR  |                                                                             |
| `dialogo_sair`                 | VARCHAR  |                                                                             |

---

## Tabela: **Cavaleiro**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_cavaleiro`                 | SERIAL   | PRIMARY KEY                                                                 |
| `id_classe`                    | INTEGER  | FOREIGN KEY (`id_classe`) REFERENCES `Classe(id_classe)`                    |
| `id_elemento`                  | INTEGER  | FOREIGN KEY (`id_elemento`) REFERENCES `Elemento(id_elemento)`              |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `nivel`                        | INTEGER  | NOT NULL                                                                     |
| `hp_max`                       | INTEGER  | NOT NULL                                                                     |
| `magia_max`                    | INTEGER  | NOT NULL                                                                     |
| `velocidade_base`              | INTEGER  | NOT NULL                                                                     |
| `ataque_fisico_base`           | INTEGER  | NOT NULL                                                                     |
| `ataque_magico_base`           | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Boss**
| Atributo                     | Tipo     | Restrições                                                                 |
|-------------------------------|----------|----------------------------------------------------------------------------|
| `id_boss`                     | SERIAL   | PRIMARY KEY                                                                |
| `id_sala`                     | INTEGER  | FOREIGN KEY (`id_sala`) REFERENCES `Sala(id_sala)`                         |
| `nome`                         | INTEGER  | NOT NULL                                                                    |
| `nivel`                        | INTEGER  | NOT NULL                                                                    |
| `xp_acumulado`                 | INTEGER  | NOT NULL                                                                    |
| `hp_max`                       | INTEGER  | NOT NULL                                                                    |
| `hp_atual`                     | INTEGER  | NOT NULL                                                                    |
| `magia_max`                    | INTEGER  | NOT NULL                                                                    |
| `magia_atual`                  | INTEGER  | NOT NULL                                                                    |
| `velocidade`                   | INTEGER  | NOT NULL                                                                    |
| `ataque_fisico_base`           | INTEGER  | NOT NULL                                                                    |
| `ataque_magico_base`           | INTEGER  | NOT NULL                                                                    |
| `dinheiro`                     | INTEGER  | NOT NULL                                                                    |
| `fala_inicio`                  | VARCHAR  |                                                                             |
| `fala_derrotar_player`         | VARCHAR  |                                                                             |
| `fala_derrotado`               | VARCHAR  |                                                                             |
| `fala_condicao`                | VARCHAR  |                                                                             |

---

### Tabela: **Inimigo**
| Atributo                     | Tipo     | Restrições                                                                 |
|-------------------------------|----------|----------------------------------------------------------------------------|
| `id_inimigo`                  | SERIAL   | PRIMARY KEY                                                                |
| `id_classe`                   | INTEGER  | FOREIGN KEY (`id_classe`) REFERENCES `Classe(id_classe)`                   |
| `id_elemento`                 | INTEGER  | FOREIGN KEY (`id_elemento`) REFERENCES `Elemento(id_elemento)`             |
| `nome`                         | VARCHAR  | NOT NULL                                                                    |
| `nivel`                        | INTEGER  | NOT NULL                                                                    |
| `xp_acumulado`                 | INTEGER  | NOT NULL                                                                    |
| `hp_max`                       | INTEGER  | NOT NULL                                                                    |
| `magia_max`                    | INTEGER  | NOT NULL                                                                    |
| `velocidade`                   | INTEGER  | NOT NULL                                                                    |
| `ataque_fisico_base`           | INTEGER  | NOT NULL                                                                    |
| `ataque_magico_base`           | INTEGER  | NOT NULL                                                                    |
| `dinheiro`                     | INTEGER  | NOT NULL                                                                    |
| `fala_inicio`                  | VARCHAR  |                                                                             |

---

### Tabela: **Grupo_inimigo**
| Atributo           | Tipo     | Restrições                                                                 |
|---------------------|----------|----------------------------------------------------------------------------|
| `id_grupo`          | SERIAL   | PRIMARY KEY                                                                |
| `id_sala`           | INTEGER  | FOREIGN KEY (`id_sala`) REFERENCES `Sala(id_sala)`                        |

---

### Tabela: **Instancia_Inimigo**
| Atributo                     | Tipo     | Restrições                                                                 |
|-------------------------------|----------|----------------------------------------------------------------------------|
| `id_instancia`                | SERIAL   | PRIMARY KEY                                                                |
| `id_inimigo`                  | INTEGER  | FOREIGN KEY (`id_inimigo`) REFERENCES `Inimigo(id_inimigo)`               |
| `id_grupo`                    | INTEGER  | FOREIGN KEY (`id_grupo`) REFERENCES `Grupo_inimigo(id_grupo)`             |
| `hp_atual`                    | INTEGER  | NOT NULL                                                                    |
| `magia_atual`                 | INTEGER  | NOT NULL                                                                    |
| `defesa_fisica_bonus`         | INTEGER  |                                                                            |
| `defesa_magica_bonus`         | INTEGER  |                                                                            |

---


### Tabela: **Inventario**
| Atributo         | Tipo     | Restrições                                                              |
|-------------------|----------|-------------------------------------------------------------------------|
| `id_player`       | INTEGER  | PRIMARY KEY, FOREIGN KEY (`id_player`) REFERENCES `Player(id_player)`  |
| `dinheiro`        | INTEGER  | NOT NULL                                                                 |

---

### Tabela: **Armadura_Instancia**
| Atributo                 | Tipo     | Restrições                                                              |
|---------------------------|----------|-------------------------------------------------------------------------|
| `id_armadura`             | INTEGER  | FOREIGN KEY (`id_armadura`, `id_parte_corpo_armadura`) REFERENCES `Armadura(id_armadura, id_parte_corpo)` |
| `id_parte_corpo_armadura` | enum_parte_corpo | FOREIGN KEY (`id_armadura`, `id_parte_corpo_armadura`) REFERENCES `Armadura(id_armadura, id_parte_corpo)` |
| `id_instancia`            | SERIAL   | PRIMARY KEY                                                             |
| `id_inventario`           | INTEGER  | FOREIGN KEY (`id_inventario`) REFERENCES `Inventario(id_player)`        |
| `raridade_armadura`       | INTEGER  | NOT NULL                                                                 |
| `defesa_magica`           | INTEGER  | NOT NULL                                                                 |
| `defesa_fisica`           | INTEGER  | NOT NULL                                                                 |
| `ataque_magico`           | INTEGER  | NOT NULL                                                                 |
| `ataque_fisico`           | INTEGER  | NOT NULL                                                                 |
| `durabilidade_max`        | INTEGER  | NOT NULL                                                                 |
| `preco_venda`             | INTEGER  | NOT NULL                                                                 |

---
### Tabela: **Item_a_venda**
| Atributo         | Tipo    | Restrições                                                               |
|-------------------|---------|--------------------------------------------------------------------------|
| `id_item`         | INTEGER | PRIMARY KEY                                                              |
| `preco_compra`    | INTEGER | NOT NULL                                                                  |
| `level_minimo`    | INTEGER | NOT NULL                                                                  |

---

### Tabela: **Party**
| Atributo         | Tipo    | Restrições                                                               |
|-------------------|---------|--------------------------------------------------------------------------|
| `id_player`       | INTEGER | PRIMARY KEY                                                              |
| `id_sala`         | INTEGER | NOT NULL                                                                  |

---


### Tabela: **Instancia_Cavaleiro**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_instancia_cavaleiro`       | SERIAL   | PRIMARY KEY                                                                 |
| `id_cavaleiro`                 | INTEGER  | FOREIGN KEY (`id_cavaleiro`) REFERENCES `Cavaleiro(id_cavaleiro)`            |
| `id_party`                     | INTEGER  | FOREIGN KEY (`id_party`) REFERENCES `Party(id_player)`                       |
| `nivel`                        | INTEGER  | NOT NULL                                                                     |
| `xp_atual`                     | INTEGER  | NOT NULL                                                                     |
| `hp_max`                       | INTEGER  | NOT NULL                                                                     |
| `magia_max`                    | INTEGER  | NOT NULL                                                                     |
| `hp_atual`                     | INTEGER  | NOT NULL                                                                     |
| `magia_atual`                  | INTEGER  | NOT NULL                                                                     |
| `velocidade`                   | INTEGER  | NOT NULL                                                                     |
| `ataque_fisico`                | INTEGER  | NOT NULL                                                                     |
| `ataque_magico`                | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Elemento**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_elemento`                  | SERIAL   | PRIMARY KEY                                                                 |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `descricao`                    | VARCHAR  |                                                                             |
| `fraco_contra`                 | INTEGER  | (Possível chave estrangeira)                                                 |
| `forte_contra`                 | INTEGER  | (Possível chave estrangeira)                                                 |

---

### Tabela: **Progresso_Player**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_player`                    | INTEGER  | FOREIGN KEY (`id_player`) REFERENCES `Player(id_player)`                     |
| `id_boss`                      | INTEGER  | FOREIGN KEY (`id_boss`) REFERENCES `Boss(id_boss)`                           |
| `id_cavaleiro`                 | INTEGER  | FOREIGN KEY (`id_cavaleiro`) REFERENCES `Cavaleiro(id_cavaleiro)`             |
| `status_derrotado`             | BOOLEAN  | NOT NULL                                                                     |

---

### Tabela: **Receita**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_item_gerado`               | INTEGER  | PRIMARY KEY                                                                 |
| `descricao`                    | VARCHAR  |                                                                             |

---

### Tabela: **Player_Missao**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_player`                    | INTEGER  | FOREIGN KEY (`id_player`) REFERENCES `Player(id_player)`                     |
| `id_missao`                    | INTEGER  | FOREIGN KEY (`id_missao`) REFERENCES `Missao(id_missao)`                     |
| `status_missao`                | enum_status_missao | NOT NULL                                                             |

---

### Tabela: **Xp_Necessaria**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `nivel`                        | INTEGER  | PRIMARY KEY                                                                 |
| `xp_necessaria`                | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Material_Receita**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_receita`                   | INTEGER  | FOREIGN KEY (`id_receita`) REFERENCES `Receita(id_item_gerado)`              |
| `id_material`                  | INTEGER  | FOREIGN KEY (`id_material`) REFERENCES `Material(id_material)`               |
| `quantidade`                   | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Habilidade_Player**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_player`                    | INTEGER  | FOREIGN KEY (`id_player`) REFERENCES `Player(id_player)`                     |
| `id_habilidade`                | INTEGER  | FOREIGN KEY (`id_habilidade`) REFERENCES `Habilidade(id_habilidade)`          |
| `slot`                         | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Habilidade_Cavaleiro**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_cavaleiro`                 | INTEGER  | FOREIGN KEY (`id_cavaleiro`) REFERENCES `Cavaleiro(id_cavaleiro)`            |
| `id_habilidade`                | INTEGER  | FOREIGN KEY (`id_habilidade`) REFERENCES `Habilidade(id_habilidade)`          |
| `slot`                         | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Habilidade_Boss**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_boss`                      | INTEGER  | FOREIGN KEY (`id_boss`) REFERENCES `Boss(id_boss)`                           |
| `id_habilidade`                | INTEGER  | FOREIGN KEY (`id_habilidade`) REFERENCES `Habilidade(id_habilidade)`          |

---

### Tabela: **Parte_Corpo_Boss**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_boss`                      | INTEGER  | FOREIGN KEY (`id_boss`) REFERENCES `Boss(id_boss)`                           |
| `parte_corpo`                  | enum_parte_corpo | FOREIGN KEY (`parte_corpo`) REFERENCES `Parte_Corpo(id_parte_corpo)`     |
| `defesa_fisica`                | INTEGER  | NOT NULL                                                                     |
| `defesa_magica`                | INTEGER  | NOT NULL                                                                     |
| `chance_acerto_base`           | INTEGER  | NOT NULL                                                                     |
| `chance_acerto_critico`        | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Parte_Corpo_Cavaleiro**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_cavaleiro`                 | INTEGER  | FOREIGN KEY (`id_cavaleiro`) REFERENCES `Cavaleiro(id_cavaleiro)`            |
| `parte_corpo`                  | enum_parte_corpo | FOREIGN KEY (`parte_corpo`) REFERENCES `Parte_Corpo(id_parte_corpo)`     |
| `id_instancia_cavaleiro`       | INTEGER  | FOREIGN KEY (`id_instancia_cavaleiro`) REFERENCES `Instancia_Cavaleiro(id_instancia_cavaleiro)` |
| `defesa_fisica_bonus`          | INTEGER  | NOT NULL                                                                     |
| `defesa_magico_bonus`          | INTEGER  | NOT NULL                                                                     |
| `chance_acerto_base`           | INTEGER  | NOT NULL                                                                     |
| `chance_acerto_critico`        | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Player**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_player`                    | SERIAL   | PRIMARY KEY                                                                 |
| `id_elemento`                  | INTEGER  | FOREIGN KEY (`id_elemento`) REFERENCES `Elemento(id_elemento)`               |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `nivel`                        | INTEGER  | NOT NULL                                                                     |
| `xp_acumulado`                 | INTEGER  | NOT NULL                                                                     |
| `hp_max`                       | INTEGER  | NOT NULL                                                                     |
| `magia_max`                    | INTEGER  | NOT NULL                                                                     |
| `hp_atual`                     | INTEGER  | NOT NULL                                                                     |
| `magia_atual`                  | INTEGER  | NOT NULL                                                                     |
| `velocidade`                   | INTEGER  | NOT NULL                                                                     |
| `ataque_fisico_base`           | INTEGER  | NOT NULL                                                                     |
| `ataque_magico_base`           | INTEGER  | NOT NULL                                                                     |
| `id_sala_safe`                 | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Parte_Corpo_Player**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_player`                    | INTEGER  | FOREIGN KEY (`id_player`) REFERENCES `Player(id_player)`                     |
| `parte_corpo`                  | enum_parte_corpo | FOREIGN KEY (`parte_corpo`) REFERENCES `Parte_Corpo(id_parte_corpo)`     |
| `armadura_equipada`            | INTEGER  | FOREIGN KEY (`armadura_equipada`) REFERENCES `Armadura(id_armadura)`         |
| `instancia_armadura_equipada`  | INTEGER  | FOREIGN KEY (`instancia_armadura_equipada`) REFERENCES `Armadura_Instancia(id_instancia)` |

---

### Tabela: **Elemento_Boss**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_elemento`                  | INTEGER  | FOREIGN KEY (`id_elemento`) REFERENCES `Elemento(id_elemento)`               |
| `id_boss`                      | INTEGER  | FOREIGN KEY (`id_boss`) REFERENCES `Boss(id_boss)`                           |

---

### Tabela: **Habilidade_Inimigo**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_habilidade`                | INTEGER  | FOREIGN KEY (`id_habilidade`) REFERENCES `Habilidade(id_habilidade)`          |
| `id_player`                    | INTEGER  | FOREIGN KEY (`id_player`) REFERENCES `Inimigo(id_inimigo)`                   |

---

### Tabela: **Item_Armazenado**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_inventario`                | INTEGER  | FOREIGN KEY (`id_inventario`) REFERENCES `Inventario(id_player)`             |
| `id_item`                      | INTEGER  | FOREIGN KEY (`id_item`) REFERENCES `Tipo_Item(id_item)`                      |
| `quantidade`                   | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Item_grupo_inimigo_dropa**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_item`                      | INTEGER  | FOREIGN KEY (`id_item`) REFERENCES `Tipo_Item(id_item)`                      |
| `id_grupo_inimigo`             | INTEGER  | FOREIGN KEY (`id_grupo_inimigo`) REFERENCES `Grupo_inimigo(id_grupo)`        |
| `quantidade`                   | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Classe**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_classe`                    | SERIAL   | PRIMARY KEY                                                                 |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `descricao`                    | VARCHAR  |                                                                             |

---

### Tabela: **Habilidade**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_habilidade`                | SERIAL   | PRIMARY KEY                                                                 |
| `classe_habilidade`            | INTEGER  | FOREIGN KEY (`classe_habilidade`) REFERENCES `Classe(id_classe)`             |
| `elemento_habilidade`         | INTEGER  | FOREIGN KEY (`elemento_habilidade`) REFERENCES `Elemento(id_elemento)`       |
| `nome`                         | VARCHAR  |                                                                             |
| `custo`                        | INTEGER  |                                                                             |
| `descricao`                    | VARCHAR  |                                                                             |
| `frase_uso`                    | VARCHAR  |                                                                             |
| `nivel_necessario`             | INTEGER  |                                                                             |

---

### Tabela: **Tipo_Item**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_item`                      | SERIAL   | PRIMARY KEY                                                                 |
| `tipo_item`                    | enum_tipo_item | NOT NULL                                                                 |

---

### Tabela: **Armadura**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_armadura`                  | INTEGER  | PRIMARY KEY                                                                 |
| `id_parte_corpo`               | enum_parte_corpo | FOREIGN KEY (`id_parte_corpo`) REFERENCES `Parte_Corpo(id_parte_corpo)`   |
| `nome`                         | VARCHAR  | NOT NULL                                                                     |
| `raridade_armadura`            | VARCHAR  | NOT NULL                                                                     |
| `defesa_magica`                | INTEGER  |                                                                             |
| `defesa_fisica`                | INTEGER  |                                                                             |
| `ataque_magico`                | INTEGER  |                                                                             |
| `ataque_fisico`                | INTEGER  |                                                                             |
| `durabilidade_max`             | INTEGER  |                                                                             |
| `preco_venda`                  | INTEGER  |                                                                             |
| `descricao`                    | INTEGER  |                                                                             |

---

### Tabela: **Material**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_material`                  | INTEGER  | PRIMARY KEY                                                                 |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `preco_venda`                  | INTEGER  | NOT NULL                                                                     |
| `descricao`                    | VARCHAR  |                                                                             |

---

### Tabela: **Item_Missao**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_item`                      | INTEGER  | PRIMARY KEY                                                                 |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `descricao`                    | VARCHAR  |                                                                             |

---

### Tabela: **Consumivel**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_item`                      | INTEGER  | PRIMARY KEY                                                                 |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `descricao`                    | VARCHAR  |                                                                             |
| `preco_venda`                  | INTEGER  | NOT NULL                                                                     |
| `saude_restaurada`             | INTEGER  |                                                                             |
| `magia_restaurada`             | INTEGER  |                                                                             |
| `saude_maxima`                 | INTEGER  |                                                                             |
| `magia_maxima`                 | INTEGER  |                                                                             |

---

### Tabela: **Livro**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_item`                      | INTEGER  | PRIMARY KEY                                                                 |
| `id_habilidade`                | INTEGER  | FOREIGN KEY (`id_habilidade`) REFERENCES `Habilidade(id_habilidade)`         |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `descricao`                    | VARCHAR  |                                                                             |
| `preco_venda`                  | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Missao**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_missao`                    | SERIAL   | PRIMARY KEY                                                                 |
| `id_missao_anterior`           | INTEGER  | FOREIGN KEY (`id_missao_anterior`) REFERENCES `Missao(id_missao)`           |
| `item_necessario`              | INTEGER  | FOREIGN KEY (`item_necessario`) REFERENCES `Item_Missao(id_item)`           |
| `nome`                         | INTEGER  | UNIQUE, NOT NULL                                                             |
| `dialogo_inicial`              | VARCHAR  |                                                                             |
| `dialogo_durante`              | VARCHAR  |                                                                             |
| `dialogo_completa`             | VARCHAR  |                                                                             |

---

### Tabela: **Santuario**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_santuario`                 | SERIAL   | PRIMARY KEY                                                                 |
| `id_missao_requisito`          | INTEGER  | FOREIGN KEY (`id_missao_requisito`) REFERENCES `Missao(id_missao)`           |
| `id_missao_proximo_santuario`  | INTEGER  | FOREIGN KEY (`id_missao_proximo_santuario`) REFERENCES `Missao(id_missao)`  |
| `nome`                         | VARCHAR  | UNIQUE, NOT NULL                                                             |
| `descricao`                    | VARCHAR  |                                                                             |
| `nivel_recomendado`           | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Casa**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_casa`                      | SERIAL   | PRIMARY KEY                                                                 |
| `id_santuario`                 | INTEGER  | FOREIGN KEY (`id_santuario`) REFERENCES `Santuario(id_santuario)`            |
| `id_missao_requisito`          | INTEGER  | FOREIGN KEY (`id_missao_requisito`) REFERENCES `Missao(id_missao)`           |
| `id_missao_proxima_casa`       | INTEGER  | FOREIGN KEY (`id_missao_proxima_casa`) REFERENCES `Missao(id_missao)`       |
| `nome`                         | VARCHAR  | NOT NULL                                                                     |
| `descricao`                    | VARCHAR  |                                                                             |
| `nivel_recomendado`           | INTEGER  | NOT NULL                                                                     |

---

### Tabela: **Sala**
| Atributo                      | Tipo     | Restrições                                                                  |
|--------------------------------|----------|-----------------------------------------------------------------------------|
| `id_sala`                      | SERIAL   | PRIMARY KEY                                                                 |
| `id_casa`                      | INTEGER  | FOREIGN KEY (`id_casa`) REFERENCES `Casa(id_casa)`                          |
| `nome`                         | VARCHAR  | NOT NULL                                                                     |
| `id_sala_norte`                | INTEGER  | (Possivelmente referência para outra sala)                                 |
| `id_sala_sul`                  | INTEGER  | (Possivelmente referência para outra sala)                                 |
| `id_sala_leste`                | INTEGER  | (Possivelmente referência para outra sala)                                 |
| `id_sala_oeste`                | INTEGER  | (Possivelmente referência para outra sala)                                 |

---

## Relacionamentos

- **Instancia_Cavaleiro**:
  - `id_cavaleiro` → `Cavaleiro(id_cavaleiro)`
  - `id_party` → `Party(id_player)`

- **Elemento**:
  - `fraco_contra` → `Elemento(id_elemento)`
  - `forte_contra` → `Elemento(id_elemento)`

- **Progresso_Player**:
  - `id_player` → `Player(id_player)`
  - `id_boss` → `Boss(id_boss)`
  - `id_cavaleiro` → `Cavaleiro(id_cavaleiro)`

- **Receita**:
  - N/A

- **Player_Missao**:
  - `id_player` → `Player(id_player)`
  - `id_missao` → `Missao(id_missao)`

- **Xp_Necessaria**:
  - N/A

- **Material_Receita**:
  - `id_receita` → `Receita(id_item_gerado)`
  - `id_material` → `Material(id_material)`

- **Habilidade_Player**:
  - `id_player` → `Player(id_player)`
  - `id_habilidade` → `Habilidade(id_habilidade)`

- **Habilidade_Cavaleiro**:
  - `id_cavaleiro` → `Cavaleiro(id_cavaleiro)`
  - `id_habilidade` → `Habilidade(id_habilidade)`

- **Habilidade_Boss**:
  - `id_boss` → `Boss(id_boss)`
  - `id_habilidade` → `Habilidade(id_habilidade)`

- **Parte_Corpo_Boss**:
  - `id_boss` → `Boss(id_boss)`
  - `parte_corpo` → `Parte_Corpo(id_parte_corpo)`

- **Parte_Corpo_Cavaleiro**:
  - `id_cavaleiro` → `Cavaleiro(id_cavaleiro)`
  - `parte_corpo` → `Parte_Corpo(id_parte_corpo)`
  - `id_instancia_cavaleiro` → `Instancia_Cavaleiro(id_instancia_cavaleiro)`

- **Player**:
  - `id_elemento` → `Elemento(id_elemento)`

- **Parte_Corpo_Player**:
  - `id_player` → `Player(id_player)`
  - `parte_corpo` → `Parte_Corpo(id_parte_corpo)`
  - `armadura_equipada` → `Armadura(id_armadura)`
  - `instancia_armadura_equipada` → `Armadura_Instancia(id_instancia)`

- **Elemento_Boss**:
  - `id_elemento` → `Elemento(id_elemento)`
  - `id_boss` → `Boss(id_boss)`

- **Habilidade_Inimigo**:
  - `id_habilidade` → `Habilidade(id_habilidade)`
  - `id_player` → `Inimigo(id_inimigo)`

- **Item_Armazenado**:
  - `id_inventario` → `Inventario(id_player)`
  - `id_item` → `Tipo_Item(id_item)`

- **Item_grupo_inimigo_dropa**:
  - `id_item` → `Tipo_Item(id_item)`
  - `id_grupo_inimigo` → `Grupo_inimigo(id_grupo)`

- **Classe**:
  - N/A

- **Habilidade**:
  - `classe_habilidade` → `Classe(id_classe)`
  - `elemento_habilidade` → `Elemento(id_elemento)`

- **Tipo_Item**:
  - N/A

- **Armadura**:
  - `id_parte_corpo` → `Parte_Corpo(id_parte_corpo)`

- **Material**:
  - N/A

- **Item_Missao**:
  - N/A

- **Consumivel**:
  - N/A

- **Livro**:
  - `id_habilidade` → `Habilidade(id_habilidade)`

- **Missao**:
  - `id_missao_anterior` → `Missao(id_missao)`
  - `item_necessario` → `Item_Missao(id_item)`

- **Santuario**:
  - `id_missao_requisito` → `Missao(id_missao)`
  - `id_missao_proximo_santuario` → `Missao(id_missao)`

- **Casa**:
  - `id_santuario` → `Santuario(id_santuario)`
  - `id_missao_requisito` → `Missao(id_missao)`
  - `id_missao_proxima_casa` → `Missao(id_missao)`

- **Sala**:
  - `id_casa` → `Casa(id_casa)`


- **Npc_Ferreiro**:
  - `id_sala` → `Sala(id_sala)`
  - `id_missao_desbloqueia` → `Missao(id_missao)`

- **Npc_Quest**:
  - `id_sala` → `Sala(id_sala)`

- **Npc_Mercador**:
  - `id_sala` → `Sala(id_sala)`

 - **Inimigo**:
  - `id_elemento` → `Elemento(id_elemento)`
  - `id_classe` → `Classe(id_classe)`

- **Instancia_Inimigo**:
  - `id_inimigo` → `Inimigo(id_inimigo)`
  - `id_grupo` → `Grupo_inimigo(id_grupo)`

- **Grupo_inimigo**:
  - `id_sala` → `Sala(id_sala)`



- **Inventario**:
  - `id_player` → `Player(id_player)`

- **Armadura_Instancia**:
  - `id_armadura`, `id_parte_corpo_armadura` → `Armadura(id_armadura, id_parte_corpo)`
  - `id_inventario` → `Inventario(id_player)`

- **Item_a_venda**:
  - `id_item` → `Tipo_Item(id_item)`


- **Party**:
  - `id_sala` → `Sala(id_sala)`


### Tipo: **tipo_item**
Representa os tipos de itens no sistema.

| Valor | Significado     |
|-------|-----------------|
| `a`   | armadura        |
| `m`   | material        |
| `i`   | item_missao     |
| `c`   | consumivel      |
| `l`   | livro           |

---

### Tipo: **parte_corpo**
Representa as partes do corpo.

| Valor | Significado     |
|-------|-----------------|
| `c`   | cabeça          |
| `t`   | tronco          |
| `b`   | braços          |
| `p`   | pernas          |

---

### Tipo: **enum_tipo_item**
Representa os tipos de itens no sistema.

| Valor | Significado     |
|-------|-----------------|
| `a`   | armadura        |
| `m`   | material        |
| `i`   | item_missao     |
| `c`   | consumivel      |
| `l`   | livro           |

---

### Tipo: **enum_parte_corpo**
Representa as partes do corpo.

| Valor | Significado     |
|-------|-----------------|
| `c`   | cabeça          |
| `t`   | tronco          |
| `b`   | braços          |
| `p`   | pernas          |

---