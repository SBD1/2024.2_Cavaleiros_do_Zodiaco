## DQL

### Data Query Language (DQL)

A Linguagem de Consulta de Dados (DQL) é focada na recuperação de informações armazenadas no banco de dados. O comando mais comum é o SELECT, que permite consultar dados de uma ou mais tabelas, aplicar filtros, ordenações e agrupamentos para obter resultados específicos.

### Consulta de Informações do Jogador

Retorna os detalhes de um jogador, como nome, nível, experiência e atributos.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION public.get_player_info(player_id INTEGER)
    RETURNS TEXT
    LANGUAGE plpgsql
    AS $function$
    BEGIN
        RETURN (
            SELECT STRING_AGG(
                FORMAT(
                    'Nome: %s Nível: %s XP: %s HP: %s/%s Magia: %s/%s Velocidade: %s Ataque Físico: %s Ataque Mágico: %s Elemento: %s',
                    p.nome, p.nivel, p.xp_atual, p.hp_atual, p.hp_max, p.magia_atual, p.magia_max, p.velocidade, 
                    p.ataque_fisico_base, p.ataque_magico_base, e.nome
                ),
                E'\n'
            )
            FROM player p
            INNER JOIN elemento e ON e.id_elemento = p.id_elemento
            WHERE p.id_player = player_id
        );
    END;
    $function$;
    ```
</details>

### Consulta de Salas Conectadas

Retorna as salas conectadas ao jogador.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION get_salas_conectadas(id_player_input INT)
    RETURNS TABLE(id_sala INT, nome VARCHAR, direcao VARCHAR) AS $$  
    BEGIN
        RETURN QUERY
        WITH salas_conectadas AS (
            SELECT s.id_sala_norte AS id_sala, CAST('Norte' AS VARCHAR) AS direcao FROM public.sala s 
            WHERE s.id_sala = (SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1) 
            AND s.id_sala_norte IS NOT NULL
            UNION ALL
            SELECT s.id_sala_sul AS id_sala, CAST('Sul' AS VARCHAR) AS direcao FROM public.sala s 
            WHERE s.id_sala = (SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1) 
            AND s.id_sala_sul IS NOT NULL
        )
        SELECT sc.id_sala, s.nome, sc.direcao
        FROM salas_conectadas sc
        JOIN public.sala s ON sc.id_sala = s.id_sala;
    END;
    $$ LANGUAGE plpgsql;
    ```

</details>

### Visualização de Cavaleiros em Party

Retorna os cavaleiros que pertencem à party do jogador.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE VIEW cavaleiros_party_view AS
    SELECT
        p.id_player,
        p.id_sala,
        ic.id_cavaleiro
    FROM
        party p
    INNER JOIN instancia_cavaleiro ic ON ic.id_party = p.id_player;
    ```
</details>

### Consulta de Itens no Inventário

Retorna os itens que um jogador possui.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE VIEW inventario_view AS
    SELECT 
        i.id_item,
        t.tipo_item,
        i.quantidade,
        p.id_player
    FROM 
        item_armazenado i
    JOIN 
        tipo_item t ON t.id_item = i.id_item
    JOIN 
        inventario inv ON inv.id_player = p.id_player;
    ```
    
</details>

### Consulta de Armaduras Disponíveis para Venda

Lista as armaduras disponíveis no mercado.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE VIEW armadura_venda_view AS
    SELECT 
        a.id_armadura,
        a.nome,
        iv.preco_compra,
        a.descricao,
        iv.nivel_minimo,
        a.raridade_armadura,
        a.defesa_magica,
        a.defesa_fisica,
        a.ataque_magico,
        a.ataque_fisico,
        a.durabilidade_max,
        a.preco_venda
    FROM 
        item_a_venda iv
    JOIN 
        tipo_item ti ON ti.id_item = iv.id_item
    JOIN 
        armadura a ON a.id_armadura = ti.id_item
    ORDER BY 
        iv.nivel_minimo, 
        a.nome;
    ```
    
</details>

### Consulta de Inimigos em uma Sala

Retorna a quantidade de inimigos por sala.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE VIEW inimigos_por_sala_view AS
    SELECT
        s.id_sala,
        COUNT(*)
    FROM
        instancia_inimigo ii
    INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
    INNER JOIN sala s ON s.id_sala = gi.id_sala
    GROUP BY
        s.id_sala;
    ```
    
</details>

### Consulta de Bosses por Sala

Retorna a quantidade de chefes presentes em cada sala.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE VIEW boss_por_sala_view AS
    SELECT
        b.id_sala,
        COUNT(*)
    FROM
        boss b
    INNER JOIN sala s2 ON s2.id_sala = b.id_sala
    GROUP BY
        b.id_sala;
    ```
    
</details>

### Consulta da Ordem de Turnos na Batalha

Retorna a ordem dos turnos na batalha, baseada na velocidade dos personagens e inimigos.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE VIEW view_fila_turnos_batalha AS
    SELECT 
        id_cavaleiro,
        'cavaleiro' AS tipo, 
        velocidade, 
        id_player
    FROM 
        instancia_cavaleiro 
    WHERE 
        id_cavaleiro IN (
            SELECT id_cavaleiro FROM cavaleiros_party_view
        )
    UNION ALL
    SELECT 
        id_instancia AS id_instancia, 
        'inimigo' AS tipo, 
        i.velocidade, 
        p.id_player
    FROM 
        instancia_inimigo ii
    INNER JOIN inimigo i ON i.id_inimigo = ii.id_inimigo 
    INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
    INNER JOIN sala s ON s.id_sala = gi.id_sala
    INNER JOIN party p ON p.id_sala = s.id_sala
    INNER JOIN player pl ON p.id_player = pl.id_player
    ORDER BY velocidade DESC;
    ```
    
</details>

### Consulta de Missões do Jogador

Retorna todas as missões ativas ou concluídas por um jogador.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_missoes_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT m.nome, m.dialogo_durante, m.dialogo_completa, pm.status_missao, im.nome, s.nome, c.nome, saga.nome 
            FROM Player_missao as pm
            JOIN Missao AS m ON pm.id_missao = m.id_missao
            JOIN Item_missao AS im ON m.item_necessario = im.id_item
            JOIN Boss as b ON b.id_item_missao = im.id_item
            JOIN Sala AS s ON s.id_sala = b.id_sala
            JOIN Casa AS c ON c.id_casa = s.id_casa
            JOIN Saga as saga ON saga.id_saga = c.id_saga
            WHERE pm.id_player = p_id_player 
            AND (status_missao = 'i' OR status_missao = 'c');
    END;
$$;
    ```
    
</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 11/12/2024 | Criação do Documento | Vinícius Rufino |
| 1.0 | 29/01/2025 | Melhoria do DQL | Lucas Dourado |
| 2.0 | 02/02/2025 | Atualização do Documento | Vinícius Rufino |
|  2.0 | 03/02/2025 | Atualização do DQL | Vinícius Rufino |
|  2.1 | 10/02/2025 | Atualização do DQL e Adição da Toggle List | Vinícius Rufino |