-- VIEW inventario_view
CREATE OR REPLACE VIEW inventario_view AS
SELECT 
    nome,
    preco_venda,
    descricao,
    CASE 
        WHEN tipo_item = 'm' THEN 'Material'
        WHEN tipo_item = 'c' THEN 'Consumível'
        WHEN tipo_item = 'l' THEN 'Livro'
        WHEN tipo_item = 'i' THEN 'Item de Missão'
        ELSE 'Outro'
    END AS tipo_item,
    quantidade,
    id_player
FROM (
    SELECT
        c.nome,
        c.preco_venda,
        c.descricao,
        ti.tipo_item,
        ia.quantidade,
        p.id_player 
    FROM inventario i
    JOIN player p ON p.id_player = i.id_player
    JOIN item_armazenado ia ON ia.id_inventario = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN consumivel c ON c.id_item = ti.id_item

    UNION 

    SELECT
        l.nome,
        l.preco_venda,
        l.descricao,
        ti.tipo_item,
        ia.quantidade,
        p.id_player 
    FROM inventario i
    JOIN player p ON p.id_player = i.id_player
    JOIN item_armazenado ia ON ia.id_inventario = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN livro l ON l.id_item = ti.id_item

    UNION 

    SELECT
        m.nome,
        m.preco_venda,
        m.descricao,
        ti.tipo_item,
        ia.quantidade,
        p.id_player 
    FROM inventario i
    JOIN player p ON p.id_player = i.id_player
    JOIN item_armazenado ia ON ia.id_inventario = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN material m ON m.id_material = ti.id_item

    UNION 

    SELECT
        im.nome,
        0, -- Itens de missão não têm preço
        im.descricao,
        ti.tipo_item,
        ia.quantidade,
        p.id_player 
    FROM inventario i
    JOIN player p ON p.id_player = i.id_player
    JOIN item_armazenado ia ON ia.id_inventario = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN item_missao im ON im.id_item = ti.id_item
) AS subquery;

-- VIEW grupo_view
CREATE OR REPLACE VIEW grupo_view AS
SELECT
    ic.id_cavaleiro,
    c.nome,
    e.nome AS elemento,
    ic.nivel,
    ic.xp_atual,
    ic.hp_max,
    ic.magia_max,
    ic.hp_atual,
    ic.magia_atual,
    ic.velocidade,
    ic.ataque_fisico,
    ic.ataque_magico,
    pl.id_player
FROM
    party pt
JOIN player pl ON pt.id_player = pl.id_player
JOIN instancia_cavaleiro ic ON ic.id_party = pt.id_player
JOIN cavaleiro c ON c.id_cavaleiro = ic.id_cavaleiro
JOIN elemento e ON e.id_elemento = c.id_elemento;

-- VIEW armadura_venda_view
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

-- VIEW consumivel_venda_view
CREATE OR REPLACE VIEW consumivel_venda_view AS
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

-- VIEW livro_venda_view
CREATE OR REPLACE VIEW livro_venda_view AS
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

-- VIEW material_venda_view
CREATE OR REPLACE VIEW material_venda_view AS
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

-- VIEW inimigos_por_sala_view
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

-- VIEW boss_por_sala_view
CREATE OR REPLACE VIEW boss_por_sala_view AS
SELECT
    b.id_sala,
    COUNT(*)
FROM
    boss b
INNER JOIN sala s2 ON s2.id_sala = b.id_sala
GROUP BY
    b.id_sala;

-- VIEW cavaleiros_party_view
CREATE OR REPLACE VIEW cavaleiros_party_view AS
SELECT
    ic.id_instancia_cavaleiro,
    p.id_player,
    p.id_sala
FROM
    party p
INNER JOIN instancia_cavaleiro ic ON ic.id_party = p.id_player;

-- VIEW inimigos_sala_player_view
CREATE OR REPLACE VIEW inimigos_sala_player_view AS
SELECT 
    ii.id_instancia,
    pl.id_player
FROM 
    instancia_inimigo ii
INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
INNER JOIN sala s ON s.id_sala = gi.id_sala
INNER JOIN party p ON p.id_sala = s.id_sala
INNER JOIN player pl ON p.id_player = pl.id_player;

-- VIEW armaduras_jogador_view
CREATE OR REPLACE VIEW armaduras_jogador_view AS
SELECT 
    ai.id_armadura,
    ai.id_parte_corpo_armadura,
    ai.id_instancia,
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
JOIN 
    parte_corpo_player pcp ON ai.id_armadura = pcp.armadura_equipada
    AND ai.id_instancia = pcp.instancia_armadura_equipada
    AND ai.id_parte_corpo_armadura = pcp.parte_corpo

UNION ALL

SELECT 
    ai.id_armadura,
    ai.id_parte_corpo_armadura,
    ai.id_instancia,
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
JOIN 
    inventario i ON ai.id_inventario = i.id_player
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM parte_corpo_player pcp
        WHERE pcp.armadura_equipada = ai.id_armadura
          AND pcp.instancia_armadura_equipada = ai.id_instancia
          AND pcp.parte_corpo = ai.id_parte_corpo_armadura
    );

-- VIEW view_fila_turnos_batalha
CREATE OR REPLACE VIEW view_fila_turnos_batalha AS
SELECT 
    id_instancia_cavaleiro AS id_instancia, 
    'cavaleiro' AS tipo, 
    velocidade, 
    id_player
FROM 
    instancia_cavaleiro 
WHERE 
    id_instancia_cavaleiro IN (
        SELECT id_instancia_cavaleiro FROM cavaleiros_party_view
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
