## DML

### Data Manipulation Language (DML)

A Linguagem de Manipulação de Dados (DML) é utilizada para inserir, atualizar, excluir e gerenciar os dados armazenados nas tabelas. Comandos DML são fundamentais para a operação diária do banco de dados.

### Atualização de Fraquezas e Forças dos Elementos

Define quais elementos são fortes ou fracos contra outros, influenciando a mecânica de combate.

<details>
    <sumary>Migrações</sumary>

    ```sql
   UPDATE Elemento SET fraco_contra = 4, forte_contra = 2 WHERE id_elemento = 1;  
    UPDATE Elemento SET fraco_contra = 1, forte_contra = 7 WHERE id_elemento = 2;  
    UPDATE Elemento SET fraco_contra = 0, forte_contra = 5 WHERE id_elemento = 3;  
    UPDATE Elemento SET fraco_contra = 6, forte_contra = 1 WHERE id_elemento = 4;  
    UPDATE Elemento SET fraco_contra = 3, forte_contra = 0 WHERE id_elemento = 5;  
    UPDATE Elemento SET fraco_contra = 7, forte_contra = 4 WHERE id_elemento = 6;  
    UPDATE Elemento SET fraco_contra = 2, forte_contra = 6 WHERE id_elemento = 7;
    ```
</details>

### Inserção de Classes

Define as classes disponíveis no jogo, como Tank, DPS e Healer.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Classe (nome, descricao)
    VALUES
    ('Tank', 'Absorve dano e protege aliados.'),
    ('DPS', 'Causa alto dano aos inimigos.'),
    ('Healer', 'Mantém os aliados vivos com habilidades de cura.');

    ```
</details>

### Inserção de XP Necessária para Subir de Nível

Define a quantidade de XP necessária para cada nível.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO public.xp_necessaria (nivel, xp_necessaria)
    VALUES (2, 5), (3, 10), (4, 15), (5, 20), (6, 25);
    ```
</details>

### Inserção de Consumíveis

Define itens que restauram HP e MP.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Consumivel (nome, descricao, preco_venda, saude_restaurada, magia_restaurada)
    VALUES
    ('Poção de Vida', 'Recupera 50 pontos de vida.', 100, 50, 0),
    ('Poção de Magia', 'Recupera 40 pontos de magia.', 120, 0, 40);
    ```
</details>

### Inserção de Itens à Venda

Define os itens disponíveis para compra.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO item_a_venda (id_item, preco_compra, nivel_minimo)
    VALUES (1, 10, 1), (2, 50, 5), (3, 10, 1), (4, 50, 5);
    ```
</details>

### Inserção de NPCs

Adiciona NPCs como ferreiros e mercadores.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Npc_Ferreiro (id_sala, nome, descricao, dialogo_inicial)
    VALUES (1, 'Mu de Áries', 'Um lendário ferreiro.', 'Bem-vindo à minha oficina!');
    ```
</details>

### Inserção de Salas

Adiciona as salas e define sua conectividade.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul)
    VALUES (1, 'Sala Principal SafeHouse', 2, 3);

    INSERT INTO Sala (id_casa, nome, id_sala_norte)
    VALUES (1, 'Oficina de Armaduras de Mu', 1);
    ```
</details>

### Inserção de Sagas

Adiciona as sagas e a progressão do jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Saga (id_missao_requisito, nome, descricao, nivel_recomendado)
    VALUES (NULL, 'Saga Guerra Galáctica', 'Torneio lendário pelo prêmio supremo.', 1);
    ```
</details>

### Inserção de Inimigos

<details>
    <sumary>Migrações</sumary>

    ```sql
    INSERT INTO Inimigo (id_classe, id_elemento, nome, nivel, xp_acumulado, hp_max, magia_max, velocidade, ataque_fisico_base, ataque_magico_base, dinheiro, fala_inicio)
    VALUES (3, 2, 'Aspirante a Cavaleiro de Bronze Agua', 1, 0, 10, 30, 15, 10, 2, 10, 'Você acha que vai se tornar um verdadeiro cavaleiro?');
    ```
</details>

### Remoção de Armadura Após Desmanche

Remove uma armadura e concede almas ao jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    DELETE FROM armadura_instancia WHERE id_instancia = p_id_instancia;

    UPDATE inventario
    SET alma_armadura = alma_armadura + v_almas_recebidas
    WHERE id_player = p_id_player;
    ```
</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 11/12/2024 | Criação do Documento | Vinícius Rufino |
| 1.0 | 11/12/2024 | Finalização do documento | [Lucas Avelar](https://github.com/LucasAvelar2711) |
|  1.1 | 29/01/2025 | Melhoria do DML | Lucas Dourado |
|  2.0 | 02/02/2025 | Atualização do Documento | Vinícius Rufino |
|  2.1 | 03/02/2025 | Atualização do DML | Vinícius Rufino |