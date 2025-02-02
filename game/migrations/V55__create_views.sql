CREATE OR REPLACE VIEW inventario_view AS
SELECT 
    nome,
    preco_venda,
    descricao,
    CASE 
        WHEN tipo_item = 'm' THEN 'Material'
        WHEN tipo_item = 'c' THEN 'Consumível'
        WHEN tipo_item = 'l' THEN 'Livro'
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


CREATE OR REPLACE VIEW items_a_venda_view
AS SELECT subquery.nome,
    subquery.preco_compra,
    subquery.descricao,
        CASE
            WHEN subquery.tipo_item = 'a'::enum_tipo_item THEN 'Armadura'::text
            WHEN subquery.tipo_item = 'm'::enum_tipo_item THEN 'Material'::text
            WHEN subquery.tipo_item = 'c'::enum_tipo_item THEN 'Consumível'::text
            WHEN subquery.tipo_item = 'l'::enum_tipo_item THEN 'Livro'::text
            ELSE 'Outro'::text
        END AS tipo_item,
    subquery.level_minimo
    FROM (   SELECT c.nome,
            iv.preco_compra,
            c.descricao,
            iv.level_minimo,
            ti.tipo_item
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN consumivel c ON c.id_item = ti.id_item
        UNION
         SELECT l.nome,
            iv.preco_compra,
            l.descricao,
            iv.level_minimo,
            ti.tipo_item
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN livro l ON l.id_item = ti.id_item
        UNION
        SELECT m.nome,
            iv.preco_compra,
            m.descricao,
            iv.level_minimo,
            ti.tipo_item
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN material m ON m.id_material = ti.id_item
        UNION
        SELECT a.nome,
            iv.preco_compra,
            a.descricao,
            iv.level_minimo,
            ti.tipo_item
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN armadura a ON a.id_armadura = ti.id_item) subquery;