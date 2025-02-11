# Dicionário de Dados
 Aqui, colocamos as tabelas do dicionário de dados usando o excel.

## Tabelas e Relações

### Tabela: **Armadura**
![Tabela Armadura](./assets/images/Armadura.png)

### Tabela: **Armadura equipada**
![Tabela Armadura equipada ](docs\assets\images\Armaduraequipada.png)

### Tabela: **Audios**

![Tabela Audios](docs\assets\images\audios.png)

## Tabela: **Boss**
![Tabela Boss](docs\assets\images\Boss.png)

### Tabela: **Cavaleiro**
![Tabela CAvaleiro ](docs\assets\images\cavaleiro.png)

### Tabela: **Classe**
![Tabela Calsse ](docs\assets\images\classe.png)

### Tabela: **Consumível**
![Tabela Classe ](docs\assets\images\consumível.png)


### Tabela: **Custos ferreiro**
![Tabela ](docs\assets\images\custosferreiro.png)

### Tabela: **Elemento**
![Tabela Elemento](docs\assets\images\elemento.png)

### Tabela: **Ferreiro**
![Tabela Ferreiro](docs\assets\images\ferreiro.png)


### Tabela: **Flyway_Schema_History**
![Tabela Flyway_Schema_History  ](docs\assets\images\flyway.png)


### Tabela: **Grupo inimigo**
![Tabela Grupo inimigo ](docs\assets\images\grupoinimigo.png)

### Tabela: **Habilidade**
![Tabela Habilidade ](docs\assets\images\habilidade.png)

### Tabela: **Habilidade Boss**
![Tabela Habilidade Boss ](docs\assets\images\habilidadeboss.png)

### Tabela: **Habilidade Cavaleiro**
![Tabela HAbilidade cavaleiro ](docs\assets\images\habilidadecaveleiro.png)

### Tabela: **Habilidade inimigo**
![Tabela HAbilidade inimigo ](docs\assets\images\habilidadeinimigo.png)

### Tabela: **Habilidade Player**
![Tabela Player](docs\assets\images\habplayer.png)

### Tabela: **inimigo**
![Tabela Inimigo](docs\assets\images\inimigo.png)

### Tabela: **Instância Cavaleiro**
![Tabela Instância cavaleiro ](docs\assets\images\instcavaleiro.png)

### Tabela: **Instância inimigo**
![Tabela Instancia inimigo ](docs\assets\images\instinimigo.png)

### Tabela: **Inventário**
![Tabela Inventário ](docs\assets\images\inventário.png)

### Tabela: **Item a venda**
![Tabela Item a venda ](docs\assets\images\itemavenda.png)
### Tabela: **Habilidade Cavaleiro**
![Tabela Habilidade Cavaleiro](docs\assets\images\habcavaleiro.png)

### Tabela: **Item Armazenado**
![Tabela Item Armazenado](docs\assets\images\itemaramaze.png)

### Tabela: **Item grupo inimigo dropa**
![Tabela Item grupo inimigo dropa](docs\assets\images\itemdropa.png)
### Tabela: **Item missão**
![Tabela Item missão ](docs\assets\images\itemmissao.png)

### Tabela: **Livro**
![Tabela Livro ](docs\assets\images\livro.png)

### Tabela: **Material**
![Tabela Material ](docs\assets\images\material.png)

### Tabela: **Material Necessário Ferreiro**
![Tabela Material Necessário Ferreiro ](docs\assets\images\materialnferreiro.png)

### Tabela: **Material receita**
![Tabela MAterial Receita](docs\assets\images\materialreceita.png)

### Tabela: **Mercador**
![Tabela Mercador](docs\assets\images\mercador.png)

### Tabela: **Npc**
![Tabela Npc ](docs\assets\images\npcmercador.png)

### Tabela: **Missão**
![Tabela Missão ](docs\assets\images\missão.png)

### Tabela: **Parte Corpo**
![Tabela Parte corpo](docs\assets\images\PC.png)
### Tabela: **Parte Corpo Boss**
![Tabela Parte corpo Boss](docs\assets\images\PCBoss.png)

### Tabela: **Parte Corpo Cavaleiro**
![Tabela Parte corpo cavaleiro](docs\assets\images\PCCavaleiro.png)

### Tabela: **Parte corpo inimigo**
![Tabela Parte corpo inimigo](docs\assets\images\PCINIMIGO.png)

### Tabela: **Parte corpo player**
![Tabela Parte corpo Player](docs\assets\images\PCPlayer.png)

### Tabela: **Party**
![Tabela Party](docs\assets\images\party.png)

### Tabela: **Player**
![Tabela player ](docs\assets\images\player.png)

### Tabela: **Player Missão**
![Tabela Player Missão ](docs\assets\images\playerMissão.png)


### Tabela: **Quest**
![Tabela quest ](docs\assets\images\Quest.png)

### Tabela: **Receita**
![Tabela Receita ](docs\assets\images\receita.png)

### Tabela: **Saga**
![Tabela Saga](docs\assets\images\saga.png)


### Tabela: **Sala**
![Tabela Sala ](docs\assets\images\sala.png)


### Tabela: **Sala segura**
![Tabela Sala Segura ](docs\assets\images\salaSegura.png)


### Tabela: **Tipo item**
![Tabela Tipo item ](docs\assets\images\tipoitem.png)


### Tabela: **Tipo npc**
![Tabela Tipo npc ](docs\assets\images\tiponpc.png)


### Tabela: **Tipo Personagem**
![Tabela Tipo personagem ](docs\assets\images\tipopersonagem.png)


### Tabela: **xp ncessária**
![Tabela xp necessária ](docs\assets\images\xpnecessária.png)


### Tabela: **receita**
![Tabela Receita  ](docs\assets\images\receita.png)






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