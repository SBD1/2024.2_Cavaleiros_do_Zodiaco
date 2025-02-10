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

-- VIEW armadura_fabricada_view
CREATE OR REPLACE VIEW armadura_fabricada_view AS
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
    i.id_player
FROM 
    armadura_instancia ai
JOIN armadura a ON a.id_armadura = ai.id_armadura
JOIN 
    inventario i ON ai.id_inventario = i.id_player
JOIN 
    armadura_equipada ae ON ai.id_armadura = ae.id_armadura 
    AND ai.id_instancia = ae.id_armadura_instanciada 
    AND ai.id_parte_corpo_armadura = ae.id_parte_corpo_armadura 
JOIN parte_corpo pc 
ON pc.id_parte_corpo = ae.id_parte_corpo_armadura 

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
        FROM armadura_equipada ae
        WHERE ae.id_armadura = ai.id_armadura
          AND ae.id_armadura_instanciada = ai.id_instancia
          AND ae.id_parte_corpo_armadura = ai.id_parte_corpo_armadura
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
    p.nome AS player_nome,
    p.nivel AS player_nivel,
    p.xp_atual AS player_xp_atual,
    p.hp_max AS player_hp_max,
    p.magia_max AS player_magia_max,
    p.hp_atual AS player_hp_atual,
    p.magia_atual AS player_magia_atual,
    p.velocidade AS player_velocidade,
    p.ataque_fisico AS ataque_fisico_base,
    p.ataque_magico AS ataque_magico_base,
    COALESCE(SUM(ai.ataque_fisico), 0) AS ataque_fisico_armaduras,
    COALESCE(SUM(ai.ataque_magico), 0) AS ataque_magico_armaduras,
    (p.ataque_fisico + COALESCE(SUM(ai.ataque_fisico), 0)) AS ataque_fisico_total,
    (p.ataque_magico + COALESCE(SUM(ai.ataque_magico), 0)) AS ataque_magico_total,
    p.id_elemento,
    e.nome AS elemento_nome,   
    i.dinheiro,
    i.alma_armadura,
    e.fraco_contra as id_fraqueza,
    e.forte_contra as id_vantagem
FROM 
    public.player p
JOIN 
    public.elemento e ON p.id_elemento = e.id_elemento
JOIN 
    public.inventario i ON p.id_player = i.id_player
LEFT JOIN 
    public.armadura_equipada ae ON p.id_player = ae.id_player
LEFT JOIN 
    public.armadura_instancia ai ON ae.id_armadura = ai.id_armadura 
                                 AND ae.id_armadura_instanciada = ai.id_instancia
                                 AND ae.id_parte_corpo_armadura = ai.id_parte_corpo_armadura
GROUP BY 
    p.id_player, p.nome, p.nivel, p.xp_atual, p.hp_max, p.magia_max, 
    p.hp_atual, p.magia_atual, p.velocidade, p.ataque_fisico, p.ataque_magico, 
    p.id_elemento, e.nome, i.dinheiro, i.alma_armadura, e.fraco_contra, e.forte_contra;



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
    ic.id_player,
    cl.nome as classe_nome,
    c.id_classe as classe_id,
    e.id_elemento as elemento_id
FROM instancia_cavaleiro ic
INNER JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro
INNER JOIN elemento e ON c.id_elemento = e.id_elemento
JOIN classe cl on c.id_classe = cl.id_classe;

CREATE VIEW receitas_materiais_view AS
    SELECT r.id_item_gerado, m.nome AS item_gerado, STRING_AGG(mat.nome || ' (' || mr.quantidade || ')', ', ') AS materiais, r.nivel_minimo AS nivel_minimo
    FROM receita r
    JOIN material m ON r.id_item_gerado = m.id_material
    JOIN material_receita mr ON r.id_item_gerado = mr.id_receita
    JOIN material mat ON mr.id_material = mat.id_material
    GROUP BY r.id_item_gerado, m.nome;

CREATE OR REPLACE VIEW receitas_armadura_view AS
    SELECT 
        r.id_item_gerado, 
        ar.nome AS item_gerado, 
        COALESCE(
            STRING_AGG(mat.nome || ' (' || mr.quantidade || ')', ', '), 
            '-'  -- Substitui valores nulos por "-"
        ) AS materiais, 
        r.nivel_minimo, 
        r.alma_armadura, 
        pc.nome AS parte_corpo,
        ar.raridade_armadura,
        ar.defesa_magica,
        ar.defesa_fisica,
        ar.ataque_magico,
        ar.ataque_fisico
    FROM receita r
    JOIN armadura ar ON ar.id_armadura = r.id_item_gerado
    LEFT JOIN material_receita mr ON r.id_item_gerado = mr.id_receita
    LEFT JOIN material mat ON mat.id_material = mr.id_material
    JOIN parte_corpo pc ON ar.id_parte_corpo = pc.id_parte_corpo
    GROUP BY 
        r.id_item_gerado, 
        ar.nome, 
        r.nivel_minimo, 
        r.alma_armadura, 
        pc.nome,
        ar.raridade_armadura,
        ar.defesa_magica,
        ar.defesa_fisica,
        ar.ataque_magico,
        ar.ataque_fisico;

CREATE OR REPLACE VIEW armadura_equipada_view AS
SELECT
    ae.id_player,
    ai.id_armadura,
    ai.id_instancia AS id_armadura_instanciada,
    ai.id_parte_corpo_armadura,
    ai.raridade_armadura,
    ai.defesa_fisica,
    ai.defesa_magica,
    ai.ataque_fisico,
    ai.ataque_magico,
    ai.durabilidade_atual
FROM
    public.armadura_equipada ae
JOIN
    public.armadura_instancia ai
    ON ae.id_armadura = ai.id_armadura
    AND ae.id_parte_corpo_armadura = ai.id_parte_corpo_armadura
    AND ae.id_armadura_instanciada = ai.id_instancia;

CREATE OR REPLACE VIEW boss_info_view AS
SELECT 
    b.id_boss,
    b.nome AS boss_nome,
    b.nivel AS boss_nivel,
    b.xp_acumulado,
    b.hp_max AS boss_hp_max,
    b.hp_atual AS boss_hp_atual,
    b.magia_max AS boss_magia_max,
    b.magia_atual AS boss_magia_atual,
    b.velocidade AS boss_velocidade,
    b.ataque_fisico AS boss_ataque_fisico,
    b.ataque_magico AS boss_ataque_magico,
    b.dinheiro AS boss_dinheiro,
    b.fala_inicio,
    b.fala_derrotar_player,
    b.fala_derrotado,
    b.fala_condicao,
    e.nome as boss_elemento,
    e.fraco_contra as id_fraqueza,
    e.forte_contra as id_vantagem
FROM 
    public.boss b
JOIN elemento e on e.id_elemento = b.id_elemento;

CREATE OR REPLACE VIEW boss_parte_corpo_info_view AS
SELECT 
    bi.id_boss,
    bi.boss_nome,
    pcb.parte_corpo,
    pc.nome AS boss_parte_corpo,
    pcb.defesa_fisica AS boss_defesa_fisica,
    pcb.defesa_magica AS boss_defesa_magica,
    pcb.chance_acerto AS boss_chance_acerto,
    pcb.chance_acerto_critico AS boss_chance_acerto_critico
FROM 
    boss_info_view bi
JOIN 
    public.parte_corpo_boss pcb ON bi.id_boss = pcb.id_boss
JOIN 
    parte_corpo pc ON pc.id_parte_corpo = pcb.parte_corpo;


CREATE OR REPLACE VIEW party_cavaleiros_view AS
SELECT 
    ic.id_cavaleiro,
    ic.id_player,
    ic.id_party,
    c.nome AS cavaleiro_nome,
    ic.nivel AS cavaleiro_nivel,
    ic.tipo_armadura,
    ic.xp_atual AS cavaleiro_xp_atual,
    ic.hp_max AS cavaleiro_hp_max,
    ic.hp_atual AS cavaleiro_hp_atual,
    ic.magia_max AS cavaleiro_magia_max,
    ic.magia_atual AS cavaleiro_magia_atual,
    ic.velocidade AS cavaleiro_velocidade,
    ic.ataque_fisico AS cavaleiro_ataque_fisico,
    ic.ataque_magico AS cavaleiro_ataque_magico,
    e.nome as cavaleiro_elemento_nome,
    e.fraco_contra as id_fraqueza,
    e.forte_contra as id_vantagem,
    cl.nome as cavaleiro_classe_nome,
    c.id_classe as cavaleiro_classe_id,
    e.id_elemento as cavaleiro_elemento_id
FROM 
    public.instancia_cavaleiro ic
JOIN 
    public.cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro
JOIN party p on p.id_player = ic.id_party
JOIN elemento e on c.id_elemento = e.id_elemento
JOIN classe cl on cl.id_classe = c.id_classe;


CREATE OR REPLACE VIEW cavaleiro_parte_corpo_info_view AS
SELECT 
    ci.id_cavaleiro,
    ci.cavaleiro_nome,
    ci.cavaleiro_nivel,
    pc.nome AS cavaleiro_parte_corpo,
    pcc.defesa_fisica AS cavaleiro_defesa_fisica,
    pcc.defesa_magica AS cavaleiro_defesa_magica,
    pcc.chance_acerto AS cavaleiro_chance_acerto,
    pcc.chance_acerto_critico AS cavaleiro_chance_acerto_critico
FROM 
    party_cavaleiros_view  ci
JOIN 
    public.parte_corpo_cavaleiro pcc ON ci.id_cavaleiro = pcc.id_cavaleiro AND ci.id_player = pcc.id_player
JOIN 
    public.parte_corpo pc ON pc.id_parte_corpo = pcc.parte_corpo;

CREATE OR REPLACE VIEW player_parte_corpo_info_view AS
SELECT 
    pi.id_player,
    pi.player_nome, 
    pi.player_nivel,
    pc.nome AS parte_corpo_nome,
    COALESCE(pcp.defesa_fisica, 0) + COALESCE(aev.defesa_fisica, 0) AS parte_corpo_defesa_fisica_total,
    COALESCE(pcp.defesa_magica, 0) + COALESCE(aev.defesa_magica, 0) AS parte_corpo_defesa_magica_total,
    pcp.chance_acerto AS parte_corpo_chance_acerto,
    pcp.chance_acerto_critico AS parte_corpo_chance_acerto_critico
FROM 
    player_info_view pi
JOIN 
    public.parte_corpo_player pcp ON pi.id_player = pcp.id_player
JOIN 
    public.parte_corpo pc ON pc.id_parte_corpo = pcp.parte_corpo
LEFT JOIN 
    armadura_equipada_view aev ON aev.id_player = pcp.id_player
                              AND aev.id_parte_corpo_armadura = pcp.parte_corpo;
