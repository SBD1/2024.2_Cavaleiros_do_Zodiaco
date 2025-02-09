CREATE OR REPLACE VIEW inventario_view AS
SELECT 
    nome,
    preco_venda,
    descricao,
    CASE 
        WHEN tipo_item = 'nc' AND tipo_nao_craftavel = 'i' THEN 'Item de Missão'
        WHEN tipo_item = 'nc' AND tipo_nao_craftavel = 'c' THEN 'Consumível'
        WHEN tipo_item = 'nc' AND tipo_nao_craftavel = 'l' THEN 'Livro'
        WHEN tipo_item = 'c' AND tipo_craftavel = 'm' THEN 'Material'
        ELSE 'Outro'
    END AS tipo_item,
    quantidade,
    id_player,
    id_item
FROM (
    -- Itens não craftáveis: Consumíveis
    SELECT
        c.nome,
        c.preco_venda,
        c.descricao,
        ti.tipo_item,
        CAST(nc.tipo_nao_craftavel AS TEXT) AS tipo_nao_craftavel,
        NULL AS tipo_craftavel,
        ia.quantidade,
        p.id_player,
        c.id_item
    FROM item_armazenado ia
    JOIN inventario i ON ia.id_inventario = i.id_player
    JOIN player p ON p.id_player = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN nao_craftavel nc ON nc.id_nao_craftavel = ti.id_item
    JOIN consumivel c ON c.id_item = nc.id_nao_craftavel

    UNION 

    -- Itens não craftáveis: Livros
    SELECT
        l.nome,
        l.preco_venda,
        l.descricao,
        ti.tipo_item,
        CAST(nc.tipo_nao_craftavel AS TEXT) AS tipo_nao_craftavel,
        NULL AS tipo_craftavel,
        ia.quantidade,
        p.id_player,
        l.id_item
    FROM item_armazenado ia
    JOIN inventario i ON ia.id_inventario = i.id_player
    JOIN player p ON p.id_player = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN nao_craftavel nc ON nc.id_nao_craftavel = ti.id_item
    JOIN livro l ON l.id_item = nc.id_nao_craftavel

    UNION 

    -- Itens não craftáveis: Materiais
    SELECT
        m.nome,
        m.preco_venda,
        m.descricao,
        ti.tipo_item,
        CAST(nc.tipo_nao_craftavel AS TEXT) AS tipo_nao_craftavel,
        NULL AS tipo_craftavel,
        ia.quantidade,
        p.id_player,
        m.id_material
    FROM item_armazenado ia
    JOIN inventario i ON ia.id_inventario = i.id_player
    JOIN player p ON p.id_player = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN nao_craftavel nc ON nc.id_nao_craftavel = ti.id_item
    JOIN material m ON m.id_material = nc.id_nao_craftavel

    UNION 

    -- Itens de Missão (sem preço)
    SELECT
        im.nome,
        0, -- Itens de missão não têm preço
        im.descricao,
        ti.tipo_item,
        CAST(nc.tipo_nao_craftavel AS TEXT) AS tipo_nao_craftavel,
        NULL AS tipo_craftavel,
        ia.quantidade,
        p.id_player,
        im.id_item
    FROM item_armazenado ia
    JOIN inventario i ON ia.id_inventario = i.id_player
    JOIN player p ON p.id_player = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN nao_craftavel nc ON nc.id_nao_craftavel = ti.id_item
    JOIN item_missao im ON im.id_item = nc.id_nao_craftavel

    UNION

    -- Itens Craftáveis: Materiais
    SELECT
        m.nome,
        m.preco_venda,
        m.descricao,
        ti.tipo_item,
        NULL AS tipo_nao_craftavel,
        CAST(c.tipo_craftavel AS TEXT) AS tipo_craftavel,
        ia.quantidade,
        p.id_player,
        m.id_material
    FROM item_armazenado ia
    JOIN inventario i ON ia.id_inventario = i.id_player
    JOIN player p ON p.id_player = i.id_player
    JOIN tipo_item ti ON ti.id_item = ia.id_item
    JOIN craftavel c ON c.id_craftavel = ti.id_item
    JOIN material m ON m.id_material = c.id_craftavel
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
    a.durabilidade_max  
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
    p.id_player,
    p.id_sala,
    ic.id_cavaleiro
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
join 
	parte_corpo pc
	on pc.id_parte_corpo = a.id_parte_corpo 
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

CREATE OR REPLACE VIEW player_info_view AS
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
    p.ataque_fisico,
    p.ataque_magico,
    p.id_elemento,
    e.nome AS elemento_nome,   -- Supondo que a tabela 'elemento' tenha um nome
    i.dinheiro,
    i.alma_armadura
FROM 
    public.player p
JOIN 
    public.elemento e ON p.id_elemento = e.id_elemento  -- Relacionando com a tabela 'elemento'
JOIN 
    public.inventario i ON p.id_player = i.id_player;   -- Relacionando com a tabela 'inventario'


CREATE VIEW instancia_cavaleiro_view AS
SELECT 
    ic.id_cavaleiro,
    c.nome AS nome_cavaleiro,
    e.nome AS elemento_nome,
    ic.nivel,
    ic.xp_atual,
    ic.hp_max,
    ic.magia_max,
    ic.hp_atual,
    ic.magia_atual,
    ic.velocidade,
    ic.ataque_fisico,
    ic.ataque_magico,
    ic.id_party,
    ic.id_player
FROM instancia_cavaleiro ic
INNER JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro
INNER JOIN elemento e ON c.id_elemento = e.id_elemento;

