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



create view grupo_view as
select
    ic.id_cavaleiro,
	c.nome,
	e.nome as elemento ,
	ic.nivel ,
	ic.xp_atual ,
	ic.hp_max ,
	ic.magia_max ,
	ic.hp_atual ,
	ic.magia_atual ,
	ic.velocidade ,
	ic.ataque_fisico ,
	ic.ataque_magico,
	pl.id_player
	from
	party pt
inner join player pl
		 on
	pt.id_player = pl.id_player
inner join instancia_cavaleiro ic 
		 on
	ic.id_party = pt.id_sala
inner join cavaleiro c 
	on c.id_cavaleiro = ic.id_cavaleiro 
inner join elemento e 
	on e.id_elemento = c.id_elemento ;

        

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


CREATE OR REPLACE VIEW consumivel_venda_view AS
    SELECT iv.id_item,
            c.nome,
            iv.preco_compra,
            c.descricao,
            iv.nivel_minimo
            
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN consumivel c ON c.id_item = ti.id_item
            ORDER BY iv.nivel_minimo, c.nome;

CREATE OR REPLACE VIEW livro_venda_view AS
    SELECT iv.id_item,
            l.nome,
            iv.preco_compra,
            l.descricao,
            iv.nivel_minimo
            
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN livro l ON l.id_item = ti.id_item
            ORDER BY iv.nivel_minimo, l.nome;

CREATE OR REPLACE VIEW material_venda_view AS
    SELECT iv.id_item,
            m.nome,
            iv.preco_compra,
            m.descricao,
            iv.nivel_minimo
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN material m ON m.id_material = ti.id_item
            ORDER BY iv.nivel_minimo, m.nome;


create or replace view inimigos_por_sala_view as
		 select
	s.id_sala ,
	count(*)
from
	instancia_inimigo ii
inner join grupo_inimigo gi 
				 on
	ii.id_grupo = ii.id_grupo
inner join sala s
				 on
	s.id_sala = gi.id_sala
group by
	s.id_sala;


create view boss_por_sala_view as
select
	b.id_sala,
	count(*)
from
	boss b
inner join sala s2 on
	s2.id_sala = b.id_sala
group by
	b.id_sala;
		

			 
-- select pros camaradas (cavaleiros na party do player)
create view cavaleiros_party_view as
select
	ic.id_instancia_cavaleiro,p.id_player,p.id_sala
from
	party p
inner join instancia_cavaleiro ic
			  		   on
	ic.id_party = p.id_player;

-- select pros inimigos (inimigos na sala que o player tá)
<<<<<<< HEAD
create view inimigos_sala_player_view as 
 SELECT ii.id_instancia,pl.id_player FROM instancia_inimigo ii
        INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
        inner join sala s on s.id_sala = gi.id_sala 
        inner join party p on p.id_sala = s.id_sala 
        inner join player pl on p.id_player = p.id_player;
        

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
FROM Armadura_Instancia ai
JOIN Parte_Corpo_Player pcp
    ON ai.id_armadura = pcp.armadura_equipada
    AND ai.id_instancia = pcp.instancia_armadura_equipada
    AND ai.id_parte_corpo_armadura = pcp.parte_corpo
=======
 create view inimigos_sala_player_view as 
 SELECT ii.id_instancia,pl.id_player,p.id_sala FROM instancia_inimigo ii
        INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
        inner join sala s on s.id_sala = gi.id_sala 
        inner join party p on p.id_sala = s.id_sala 
        inner join player pl on p.id_player = p.id_player ;
        
        
create or replace VIEW view_fila_turnos_batalha AS
SELECT 
    id_instancia_cavaleiro AS id_instancia, 
    'cavaleiro' AS tipo, 
    velocidade, 
    id_player
FROM instancia_cavaleiro 
WHERE id_instancia_cavaleiro IN (
    SELECT id_instancia_cavaleiro FROM cavaleiros_party_view
)
    
UNION ALL

SELECT 
    id_instancia AS id_instancia, 
    'inimigo' AS tipo, 
    i.velocidade , 
    p.id_player
FROM instancia_inimigo ii
inner join inimigo i
on i.id_inimigo  = ii.id_inimigo 
INNER JOIN grupo_inimigo gi ON ii.id_grupo = gi.id_grupo
        inner join sala s on s.id_sala = gi.id_sala 
        inner join party p on p.id_sala = s.id_sala 
        inner join player pl on p.id_player = p.id_player 
>>>>>>> efc9167868a79ffacbec8cf360945092f5524730

UNION ALL

SELECT 
<<<<<<< HEAD
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
FROM Armadura_Instancia ai
JOIN Inventario i
    ON ai.id_inventario = i.id_player
WHERE NOT EXISTS (
    SELECT 1
    FROM Parte_Corpo_Player pcp
    WHERE pcp.armadura_equipada = ai.id_armadura
      AND pcp.instancia_armadura_equipada = ai.id_instancia
      AND pcp.parte_corpo = ai.id_parte_corpo_armadura
);
=======
    id_player AS id_instancia, 
    'player' AS tipo, 
    velocidade, 
    id_player
FROM player

ORDER BY velocidade DESC;
>>>>>>> efc9167868a79ffacbec8cf360945092f5524730
