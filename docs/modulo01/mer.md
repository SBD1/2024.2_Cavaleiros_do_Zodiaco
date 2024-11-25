## Modelo Entidade-Relacionamento (MER)
O **Modelo Entidade-Relacionamento (MER)** é uma descrição textual das entidades e relacionamentos que compõem a estrutura de um banco de dados. Diferentemente do DER, o MER apresenta as informações de forma textual, facilitando a compreensão e detalhamento dos componentes.

## Tabelas e Atributos

### **Personagem**
- **id_personagem**
- **nome**

### **Player**
- **id_personagem**

### **NPC Quest**
- **id_personagem**
- **dialogo_inicial**
- **dialogo_recusa**

### **NPC Mercado**
- **id_personagem**
- **dialogo_inicial**
- **dialogo_vender**
- **dialogo_comprar**
- **dialogo_sair**

### **Party**
- **id_player**
- **id_sala**

### **Inventário**
- **id_player**
- **dinheiro**

### **Progresso Jogador**
- **id_player**
- **id_boss**
- **status_derrotado**
- **cavaleiro_desbloqueado**

### **Personagem Luta**
- **id_personagem**
- **nivel**
- **hp_max**
- **hp_atual**
- **magia_max**
- **magia_atual**
- **velocidade**

### **Cavaleiro**
- **id_personagem**
- **desbloqueado**
- **classe**

### **Inimigo**
- **id_personagem**
- **dinheiro**
- **fala_inicio**

### **Boss**
- **id_personagem**
- **dinheiro**
- **fala_inicio**
- **fala_derrota**

### **Sala**
- **id_sala**
- **nome**
- **sala_norte**
- **sala_sul**
- **sala_leste**
- **sala_oeste**

### **Santuário**
- **id_santuario**
- **nome**
- **descricao**
- **id_pre_req_missao**

### **Grupo Inimigo**
- **id_grupo_inimigo**
- **id_sala**

### **Missão**
- **id_missao**
- **nome**
- **item_necessario**
- **dialogo_inicial**
- **dialogo_durante**
- **dialogo_completa**

### **Missão Jogador**
- **id_missao**
- **id_jogador**

### **Item**
- **id_item**
- **nome**
- **tipo_item**
- **preco_compra**
- **preco_venda**

### **Armadura**
- **id_item**
- **defesa_magica**
- **defesa_fisica**
- **ataque_magico**
- **ataque_fisico**
- **durabilidade_max**
- **parte_corpo**

### **Material**
- **id_item**

### **Consumível**
- **id_item**
- **saude**
- **magia**
- **saude_maxima**
- **magia_maxima**
- **quantidade**

### **Livro**
- **id_item**

### **Item Instanciado**
- **id_nivel**
- **durabilidade_atual**

### **Receita**
- **id_receita**
- **material_necessario**

### **Habilidade**
- **id_habilidade**
- **classe**
- **tipo_habilidade**
- **frase_uso**
- **descricao**
- **nome**
- **valor**

### **Elemento**
- **id_elemento**
- **nome**
- **fraco_contra**
- **forte_contra**

### **Parte do Corpo**
- **id_parte**
- **tipo_parte**
- **defesa**
- **prob_acerto**
- **chance_critico**

---

## Relacionamentos

### **Item Instanciado aponta para Item**
- Um **Item Instanciado** aponta para um **Item**.
- Um **Item** é apontado por **N Itens Instanciados**.

### **Parte do Corpo equipa Armadura**
- Uma **Parte do Corpo** equipa uma **Armadura**.
- Uma **Armadura** é equipada por **N Partes do Corpo**.

### **Personagem Luta possui Elemento**
- Um **Personagem Luta** possui de 0 a **N Elementos**.
- Um **Elemento** é possuído por 0 a **N Personagens Luta**.

### **Personagem Luta utiliza Habilidade**
- Um **Personagem Luta** utiliza de 0 a **N Habilidades**.
- Uma **Habilidade** é utilizada por 0 a **N Personagens Luta**.

### **Player está em Party**
- Um **Player** está em uma **Party**.
- Uma **Party** está com um **Player**.

### **Cavaleiro participa de Party**
- Um **Cavaleiro** participa de uma **Party**.
- Uma **Party** é participada por 0 a **N Cavaleiros**.

### **Progresso do Jogador desbloqueia Cavaleiro**
- Um **Progresso do Jogador** desbloqueia de 0 a **1 Cavaleiro**.
- Um **Cavaleiro** é desbloqueado por um **Progresso do Jogador**.

### **Player avança Progresso Jogador**
- Um **Player** avança 0 a **N Progresso Jogador**.
- Um **Progresso Jogador** é avançado por um **Player**.

### **Progresso Jogador derrota Boss**
- Um **Progresso Jogador** derrota um **Boss**.
- Um **Boss** é derrotado por um **Progresso Jogador**.

### **Player possui Inventário**
- Um **Player** possui um **Inventário**.
- Um **Inventário** é possuído por um **Player**.

### **Inventário armazena Item Instanciado**
- Um **Inventário** armazena de 0 a **N Itens Instanciados**.
- Um **Item Instanciado** é armazenado por 0 a **1 Inventário**.

### **Inimigo participa de Grupo Inimigo**
- Um **Inimigo** participa de 0 a **N Grupos de Inimigos**.
- Um **Grupo Inimigo** é participado por pelo menos **1 Inimigo**.

### **Boss dropa Item Instanciado**
- Um **Boss** dropa de 1 a **N Itens Instanciados**.
- Um **Item Instanciado** é dropado por um **Boss**.

### **Santuário contém Salas**
- Um **Santuário** contém de 1 a **N Salas**.
- Uma **Sala** é contida por um **Santuário**.

### **Party está na Sala**
- Uma **Party** está em uma **Sala**.
- Em uma **Sala** está de 0 a **1 Party**.

### **Grupo Inimigo está na Sala**
- Um **Grupo Inimigo** está em uma **Sala**.
- Em uma **Sala** está de 0 a **N Grupos de Inimigos**.

### **Livro ensina uma Habilidade**
- Um **Livro** ensina uma **Habilidade**.
- Uma **Habilidade** é ensinada por um **Livro**.

### **Player aceita Missão Jogador**
- Um **Player** aceita de 0 a **N Missões Jogadores**.
- Uma **Missão Jogador** é aceita por um **Player**.

### **NPC Mercado vende Item Instanciado**
- Um **NPC Mercado** vende de 0 a **N Itens Instanciados**.
- Um **Item Instanciado** é vendido por um **NPC Mercado**.

### **Grupo Inimigo dropa Item Instanciado**
- Um **Grupo Inimigo** dropa de 0 a **N Itens Instanciados**.
- Um **Item Instanciado** é dropado por um **Grupo Inimigo**.

### **Sala Origem viaja para uma Sala Destino**
- Uma **Sala Origem** viaja para uma **Sala Destino**.

### **Material gera Armadura**
- Um **Material** gera 0 ou **1 Armadura**.
- Uma **Armadura** pode ser gerada por 0 a **N Materiais**.

### **Receita gera Armadura**
- Uma **Receita** gera 0 a **N Armaduras**.
- Uma **Armadura** é gerada por 0 ou **1 Receita**.

## Histórico de versão

| Data       | Descrição                                        | Autor                                        |
| ---------- | ------------------------------------------------ | -------------------------------------------- |
| 25/11/2024 | Versão inicial do Modelo Entidade Relacionamento | [Lucas Ramon](https://github.com/lramon2001) |
