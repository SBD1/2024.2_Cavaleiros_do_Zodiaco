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

        

CREATE OR REPLACE VIEW armadura_venda_view AS
    SELECT 
        a.nome,
        iv.preco_compra,
        a.descricao,
        iv.nivel_minimo
    FROM 
        item_a_venda iv
    JOIN 
        tipo_item ti ON ti.id_item = iv.id_item
    JOIN 
        armadura a ON a.id_armadura = ti.id_item
        ORDER BY iv.nivel_minimo, a.nome;

CREATE OR REPLACE VIEW consumivel_venda_view AS
    SELECT c.nome,
            iv.preco_compra,
            c.descricao,
            iv.nivel_minimo
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN consumivel c ON c.id_item = ti.id_item
            ORDER BY iv.nivel_minimo, c.nome;

CREATE OR REPLACE VIEW livro_venda_view AS
    SELECT l.nome,
            iv.preco_compra,
            l.descricao,
            iv.nivel_minimo
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN livro l ON l.id_item = ti.id_item
            ORDER BY iv.nivel_minimo, l.nome;

CREATE OR REPLACE VIEW material_venda_view AS
    SELECT m.nome,
            iv.preco_compra,
            m.descricao,
            iv.nivel_minimo
            FROM item_a_venda iv
            JOIN tipo_item ti ON ti.id_item = iv.id_item
            JOIN material m ON m.id_material = ti.id_item
            ORDER BY iv.nivel_minimo, m.nome;




