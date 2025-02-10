## DQL

### Data Query Language (DQL)

A Linguagem de Consulta de Dados (DQL) é focada na recuperação de informações armazenadas no banco de dados. O comando mais comum é o SELECT, que permite consultar dados de uma ou mais tabelas, aplicar filtros, ordenações e agrupamentos para obter resultados específicos.

<details>
    <sumary> Migrações </sumary>

    ```sql
    SELECT 
        iv.id_item,
        c.nome,
        iv.preco_compra,
        c.descricao,
        iv.nivel_minimo
    FROM 
        item_a_venda iv
    JOIN 
        tipo_item ti ON ti.id_item = iv.id_item
    JOIN 
        consumivel c ON c.id_item = ti.id_item
    ORDER BY 
        iv.nivel_minimo, c.nome;

    SELECT 
        iv.id_item,
        l.nome,
        iv.preco_compra,
        l.descricao,
        iv.nivel_minimo
    FROM 
        item_a_venda iv
    JOIN 
        tipo_item ti ON ti.id_item = iv.id_item
    JOIN 
        livro l ON l.id_item = ti.id_item
    ORDER BY 
        iv.nivel_minimo, l.nome;

    SELECT 
        iv.id_item,
        m.nome,
        iv.preco_compra,
        m.descricao,
        iv.nivel_minimo
    FROM 
        item_a_venda iv
    JOIN 
        tipo_item ti ON ti.id_item = iv.id_item
    JOIN 
        material m ON m.id_material = ti.id_item
    ORDER BY 
        iv.nivel_minimo, m.nome;

    SELECT
        s.id_sala,
        COUNT(*)
    FROM
        instancia_inimigo ii
    INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
    INNER JOIN sala s ON s.id_sala = gi.id_sala
    GROUP BY
        s.id_sala;

    SELECT
        b.id_sala,
        COUNT(*)
    FROM
        boss b
    INNER JOIN sala s2 ON s2.id_sala = b.id_sala
    GROUP BY
        b.id_sala;

    SELECT
        p.id_player,
        p.id_sala,
        ic.id_cavaleiro
    FROM
        party p
    INNER JOIN instancia_cavaleiro ic ON ic.id_party = p.id_player;

    SELECT 
        ii.id_instancia,
        pl.id_player
    FROM 
        instancia_inimigo ii
    INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
    INNER JOIN sala s ON s.id_sala = gi.id_sala
    INNER JOIN party p ON p.id_sala = s.id_sala
    INNER JOIN player pl ON p.id_player = pl.id_player;

    SELECT 
        ai.id_instancia,
        ai.id_armadura,
        pc.nome as parte_corpo,
        a.nome,
        a.descricao,
        ai.raridade_armadura,
        ai.durabilidade_atual,
        ai.ataque_fisico,
        ai.ataque_magico,
        ai.defesa_fisica,
        ai.defesa_magica,
        'equipada' AS status_armadura,
        pcp.parte_corpo AS parte_corpo_equipada,
        pcp.id_player
    FROM 
        armadura_instancia ai
    JOIN armadura a ON a.id_armadura = ai.id_armadura
    JOIN 
        parte_corpo_player pcp ON ai.id_armadura = pcp.armadura_equipada
        AND ai.id_instancia = pcp.instancia_armadura_equipada
        AND ai.id_parte_corpo_armadura = pcp.parte_corpo
    JOIN parte_corpo pc 
    ON pc.id_parte_corpo = pcp.parte_corpo

    UNION ALL

    SELECT 
        ai.id_instancia,
        ai.id_armadura,
        pc.nome as parte_corpo ,
        a.nome,
        a.descricao,
        ai.raridade_armadura,
        ai.durabilidade_atual,
        ai.ataque_fisico,
        ai.ataque_magico,
        ai.defesa_fisica,
        ai.defesa_magica,
        'inventario' AS status_armadura,
        NULL AS parte_corpo_equipada,
        i.id_player
    FROM 
        armadura_instancia ai
    JOIN armadura a ON a.id_armadura = ai.id_armadura
    JOIN 
        inventario i ON ai.id_inventario = i.id_player
    JOIN 
        parte_corpo pc ON pc.id_parte_corpo = a.id_parte_corpo 
    WHERE 
        NOT EXISTS (
            SELECT 1
            FROM parte_corpo_player pcp
            WHERE pcp.armadura_equipada = ai.id_armadura
            AND pcp.instancia_armadura_equipada = ai.id_instancia
            AND pcp.parte_corpo = ai.id_parte_corpo_armadura
        );

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

    SELECT 
        p.id_player,
        p.nome,
        p.nivel,
        p.xp_atual,
        p.hp_max,
        p.magia_max,
        p.hp_atual,
        p.magia_atual,
        p.velocidade,
        p.ataque_fisico_base,
        p.ataque_magico_base,
        p.id_elemento,
        e.nome AS elemento_nome,
        i.dinheiro,
        i.alma_armadura
    FROM 
        public.player p
    JOIN 
        public.elemento e ON p.id_elemento = e.id_elemento
    JOIN 
        public.inventario i ON p.id_player = i.id_player;

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