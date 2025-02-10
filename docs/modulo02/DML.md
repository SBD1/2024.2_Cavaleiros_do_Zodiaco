## DML

### Data Manipulation Language (DML)

A Linguagem de Manipulação de Dados (DML) é utilizada para inserir, atualizar, excluir e gerenciar os dados armazenados nas tabelas. Comandos DML são fundamentais para a operação diária do banco de dados.

<details>
    <sumary>Migrações</sumary>

    ```sql
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

    INSERT INTO Elemento (id_elemento, nome, descricao)
    VALUES
    (1, 'Água', 'Flui e adapta-se, frequentemente usada para defesa e restrição de movimentos.'),
    (2, 'Fogo', 'Controla o calor e as chamas, usado frequentemente para atacar com intensidade.'),
    (3, 'Luz', 'Sólido e confiável, usado para defesa e ataques físicos.'),
    (4, 'Terra', 'Sólido e confiável, usado para defesa e ataques físicos.'),
    (5, 'Trevas', 'Sólido e confiável, usado para defesa e ataques físicos.'),
    (6, 'Trovão', 'Poderoso e chocante, usado para ataques elétricos rápidos e devastadores.'),
    (7, 'Vento', 'Rápido e inconstante, usado para movimentação rápida e ataques evasivos.');

    UPDATE Elemento SET fraco_contra = 4, forte_contra = 2 WHERE id_elemento = 1;  
    UPDATE Elemento SET fraco_contra = 1, forte_contra = 7 WHERE id_elemento = 2;  
    UPDATE Elemento SET fraco_contra = 0, forte_contra = 5 WHERE id_elemento = 3;  
    UPDATE Elemento SET fraco_contra = 6, forte_contra = 1 WHERE id_elemento = 4;  
    UPDATE Elemento SET fraco_contra = 3, forte_contra = 0 WHERE id_elemento = 5;  
    UPDATE Elemento SET fraco_contra = 7, forte_contra = 4 WHERE id_elemento = 6;  
    UPDATE Elemento SET fraco_contra = 2, forte_contra = 6 WHERE id_elemento = 7;  

    INSERT INTO Classe (nome, descricao)
    VALUES
    ('Tank', 'O Tank é a muralha inabalável do grupo, projetado para absorver dano e proteger seus aliados.'),
    ('DPS', 'O DPS é o principal responsável por causar dano aos inimigos.'),
    ('Healer', 'O Healer é o sustentáculo do grupo, focado em manter os aliados vivos e fortalecidos.');

    INSERT INTO inventario (id_player, dinheiro)
    VALUES 
        (1, 50),
        (2, 50);

    INSERT INTO public.parte_corpo (id_parte_corpo, nome, defesa_magica, defesa_fisica, chance_acerto, chance_acerto_critico)
    VALUES 
        ('c', 'Cabeça', 5, 10, 80, 5),
        ('t', 'Tronco', 8, 15, 90, 3),
        ('b', 'Braços', 4, 7, 85, 8),
        ('p', 'Pernas', 6, 9, 88, 6);

    INSERT INTO Texto (nome_texto, texto)
    VALUES 
    ('logo', '     ______                           __          _                                      __               _____              __    _'),
    ('introducao', 'Desde tempos imemoriais, quando o mal ameaçou dominar o mundo, guerreiros sagrados se ergueram para proteger a paz na Terra.');

    INSERT INTO Consumivel (nome, descricao, preco_venda, saude_restaurada, magia_restaurada, saude_maxima, magia_maxima)
    VALUES
    ('Poção de Vida', 'Recupera 50 pontos de vida.', 100, 50, 0, 0, 0),
    ('Elixir da Vida', 'Aumenta a saúde máxima em 20 pontos.', 300, 0, 0, 20, 0),
    ('Poção de Magia', 'Recupera 40 pontos de magia.', 120, 0, 40, 0, 0),
    ('Elixir da Magia', 'Aumenta a magia máxima em 15 pontos.', 350, 0, 0, 0, 15);

    INSERT INTO item_a_venda(id_item, preco_compra, nivel_minimo)
    VALUES 
    (1,10,1), 
    (2,50,5), 
    (3,10,1), 
    (4,50,5);

    INSERT INTO Saga (id_missao_requisito, id_missao_proxima_saga, nome, descricao, nivel_recomendado)
    VALUES 
    (NULL, NULL, 'Saga SafeHouse', 'O início da jornada dos Cavaleiros de Bronze.', 1),
    (NULL, NULL, 'Saga Guerra Galáctica', 'Um torneio lendário onde os Cavaleiros de Atena lutam pelo prêmio supremo.', 1);

    INSERT INTO Casa (id_saga, id_missao_requisito, id_missao_proxima_casa, nome, descricao, nivel_recomendado)
    VALUES 
    (1, NULL, NULL, 'Casa SafeHouse', 'O lugar onde os Cavaleiros de Bronze viveram antes de seus treinamentos.', 1),
    (2, NULL, NULL, 'Grécia', 'O lugar onde o cavaleiro de Pegasus conseguiu sua armadura.', 1);

    INSERT INTO Sala (id_casa, nome, id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste)
    VALUES 
    (1, 'Sala Principal SafeHouse', 2, 3, NULL, NULL),
    (1, 'Sala Das Missões', NULL, 1, NULL, NULL),
    (1, 'Oficina de Armaduras de Mu', 1, NULL, NULL, NULL);

    INSERT INTO public.Sala_Segura (id_sala)
    VALUES (1);

    INSERT INTO Party (id_player, id_sala) 
    VALUES 
    (1,1), 
    (2,1);

    INSERT INTO Grupo_inimigo(id_sala)
    VALUES (4);

    SELECT public.criar_instancia_inimigo(1,1);
    SELECT public.criar_instancia_inimigo(1,2);
    SELECT public.criar_instancia_inimigo(3,2);
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
|  2.2 | 10/02/2025 | Atualização do DML e Adição da Toggle List | Vinícius Rufino |