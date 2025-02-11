## Stored Procedures

Uma Stored Procedure é um bloco de código SQL armazenado no banco de dados, que pode ser executado várias vezes sem precisar ser reescrito. As procedures permitem realizar operações mais complexas, como manipulação de dados e lógica de negócios, aceitando parâmetros de entrada e podendo modificar dados do banco.

### Get Inventario Cursor

Esta procedure retorna um cursor com o inventário de um jogador específico. Ela seleciona todos os itens do inventário do jogador, incluindo materiais, consumíveis, livros e itens de missão, e os organiza em uma view chamada inventario_view.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_inventario_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT * FROM inventario_view
            WHERE id_player = p_id_player;
    END;
    $$;
    ```
</details>

### Get Missoes Cursor

Esta procedure retorna um cursor com as missões de um jogador específico. Ela seleciona as missões do jogador, incluindo informações sobre o boss, a sala, a casa e a saga relacionada à missão.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_missoes_cursor(IN p_id_player INT, INOUT cur REFCURSOL)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT m.nome, m.dialogo_durante, m.dialogo_completa, pm.status_missao, im.nome, s.nome, c.nome, saga.nome FROM Player_missao as pm
            JOIN
            Missao AS m
            ON pm.id_missao = m.id_missao
            JOIN
            Item_missao AS im
            ON m.item_necessario = im.id_item
            JOIN
            Boss as b
            ON b.id_item_missao = im.id_item
            JOIN
            Sala AS s 
            ON s.id_sala = b.id_sala
            JOIN
            Casa AS c 
            ON c.id_casa = s.id_casa
            JOIN
            Saga as saga 
            ON saga.id_saga = c.id_saga
            WHERE pm.id_player = p_id_player 
            AND (status_missao = 'i' OR status_missao = 'c');
    END;
    $$;
    ```
</details>

### Get Casa Atual

Esta procedure retorna um cursor com a casa atual em que o jogador está. Ela seleciona a casa com base na sala atual do jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_casa_atual(IN p_id_player INT, INOUT cur REFCURSOR)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT s.id_casa, c.nome FROM 
            Party as p
            JOIN
            Sala AS s 
            ON p.id_sala = s.id_sala
            JOIN
            Casa as c 
            ON c.id_casa = s.id_casa
            WHERE p.id_player = p_id_player;
    END;
    $$;
    ```
</details>

### Get Saga Segura

Esta procedure retorna um cursor com a saga segura (SafeHouse) do jogador. Ela seleciona a saga segura com base na sala segura do jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_saga_segura(IN p_id_player INT, INOUT cur REFCURSOR)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT sa.id_saga, sa.nome
                FROM public.sala_segura AS ss
                JOIN public.sala AS s ON ss.id_sala = s.id_sala
                JOIN public.casa AS c ON s.id_casa = c.id_casa
                JOIN public.saga AS sa ON c.id_saga = sa.id_saga
                LIMIT 1;
    END;
    $$;
    ```
</details>

### Get Saga Atual

Esta procedure retorna um cursor com a saga atual em que o jogador está. Ela seleciona a saga com base na sala atual do jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_saga_atual(IN p_id_player INT, INOUT cur REFCURSOR)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT c.id_saga, sa.nome FROM 
            Party as p
            JOIN
            Sala AS s 
            ON p.id_sala = s.id_sala
            JOIN
            Casa as c 
            ON c.id_casa = s.id_casa
            JOIN
            Saga as sa
            ON sa.id_saga = c.id_saga
            WHERE p.id_player = p_id_player;
    END;
    $$;
    ```
</details>

### Get Grupo Cursor

Esta procedure retorna um cursor com os cavaleiros que estão no grupo do jogador. Ela seleciona os cavaleiros que estão na party do jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_grupo_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT * FROM grupo_view
            WHERE id_player = p_id_player;
    END;
    $$;
    ```
</details>

### Trocar Cavaleiro Party

Esta procedure permite que o jogador troque cavaleiros na sua party. Ela verifica se o jogador já tem 3 cavaleiros na party e, se sim, remove um para adicionar outro.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE trocar_cavaleiro_party(
        IN p_id_player INT,
        IN p_id_cavaleiro_novo INT,
        IN p_id_cavaleiro_removido INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        total_cavaleiros INT;
        id_sala_var INT;
    BEGIN
        SELECT id_sala INTO id_sala_var FROM party WHERE id_player = p_id_player LIMIT 1;

        IF id_sala_var IS NULL THEN
            RAISE EXCEPTION 'O jogador não tem uma party.';
        END IF;

        SELECT COUNT(*) INTO total_cavaleiros 
        FROM instancia_cavaleiro ic
        WHERE ic.id_party = id_sala_var;

        IF total_cavaleiros >= 3 THEN
            IF NOT EXISTS (SELECT 1 FROM instancia_cavaleiro WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido) THEN
                RAISE EXCEPTION 'O cavaleiro escolhido para remoção não está na party.';
            END IF;

            UPDATE instancia_cavaleiro 
            SET id_party = NULL 
            WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido;

            RAISE NOTICE 'Cavaleiro % foi removido da party e está disponível novamente.', p_id_cavaleiro_removido;
        END IF;

        INSERT INTO instancia_cavaleiro (id_player,id_cavaleiro, id_party, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico)
        SELECT 
            p_id_player,
            p_id_cavaleiro_novo, 
            id_sala_var,
            nivel, 0, hp_max, magia_max, hp_max, magia_max, velocidade_base, ataque_fisico_base, ataque_magico_base
        FROM cavaleiro
        WHERE id_cavaleiro = p_id_cavaleiro_novo;

        RAISE NOTICE 'Cavaleiro % foi adicionado à party.', p_id_cavaleiro_novo;
    END;
    $$;
    ```
</details>

### Criar Item

Esta procedure permite que o jogador crie um item a partir de uma receita, consumindo os materiais necessários.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE criar_item(
        IN p_id_player INT,
        IN p_id_item_gerado INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        material RECORD; 
        insuficiente BOOLEAN := FALSE;
    BEGIN
        FOR material IN 
            SELECT mr.id_material, mr.quantidade
            FROM material_receita mr
            WHERE mr.id_receita = p_id_item_gerado
        LOOP
            IF (SELECT quantidade FROM item_armazenado 
                WHERE id_inventario = p_id_player 
                AND id_item = material.id_material) < material.quantidade THEN
                insuficiente := TRUE;
            END IF;
        END LOOP;

        IF insuficiente THEN
            RAISE EXCEPTION 'Você não tem materiais suficientes para criar este item.';
        END IF;

        UPDATE item_armazenado ia
        SET quantidade = ia.quantidade - mr.quantidade
        FROM material_receita mr
        WHERE ia.id_inventario = p_id_player
        AND ia.id_item = mr.id_material
        AND mr.id_receita = p_id_item_gerado;

        INSERT INTO item_armazenado (id_inventario, id_item, quantidade)
        VALUES (p_id_player, p_id_item_gerado, 1)
        ON CONFLICT (id_inventario, id_item) 
        DO UPDATE SET quantidade = item_armazenado.quantidade + 1;

        RAISE NOTICE 'Item criado com sucesso!';
    END;
    $$;
    ```
</details>

### Comprar Item

Esta procedure permite que o jogador compre um item de um mercador, verificando se ele tem dinheiro suficiente e se atende ao nível mínimo necessário.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE comprar_item(
        p_id_player INT,
        p_id_item INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_dinheiro_atual NUMERIC;
        v_preco_item NUMERIC;
        v_level_minimo INT;
        v_jogador_level INT;
        v_id_inventario INT;
        v_quantidade_atual INT;
    BEGIN
        SELECT dinheiro, id_player INTO v_dinheiro_atual, v_id_inventario
        FROM inventario
        WHERE id_player = p_id_player;

        IF v_dinheiro_atual IS NULL THEN
            RAISE EXCEPTION 'Jogador não encontrado.';
        END IF;

        SELECT preco_compra, nivel_minimo INTO v_preco_item, v_level_minimo
        FROM item_a_venda
        WHERE id_item = p_id_item;

        IF v_preco_item IS NULL THEN
            RAISE EXCEPTION 'Item não encontrado.';
        END IF;

        SELECT nivel INTO v_jogador_level
        FROM player
        WHERE id_player = p_id_player;

        IF v_jogador_level IS NULL THEN
            RAISE EXCEPTION 'Jogador não encontrado.';
        END IF;

        IF v_jogador_level < v_level_minimo THEN
            RAISE EXCEPTION 'Você precisa ser nível % para comprar este item.', v_level_minimo;
        END IF;

        IF v_dinheiro_atual < v_preco_item THEN
            RAISE EXCEPTION 'Dinheiro insuficiente para comprar o item.';
        END IF;

        UPDATE inventario
        SET dinheiro = dinheiro - v_preco_item
        WHERE id_player = v_id_inventario;

        SELECT quantidade INTO v_quantidade_atual
        FROM item_armazenado
        WHERE id_inventario = v_id_inventario
        AND id_item = p_id_item;

        IF NOT FOUND THEN
            INSERT INTO item_armazenado (id_inventario, id_item, quantidade)
            VALUES (v_id_inventario, p_id_item, 1);
        ELSE
            UPDATE item_armazenado
            SET quantidade = quantidade + 1
            WHERE id_inventario = v_id_inventario
            AND id_item = p_id_item;
        END IF;

        RAISE NOTICE 'Item comprado com sucesso!';
    END $$;
    ```
</details>

### Vender Item

Esta procedure permite que o jogador venda um item, recebendo dinheiro em troca.

<details>
    <sumary>Migrações</sumary>

    ```sql
   CREATE OR REPLACE PROCEDURE vender_item(
        p_id_player INT,
        p_id_item INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_preco_venda NUMERIC;
        v_quantidade_atual INT;
    BEGIN
        SELECT preco_venda, quantidade
        INTO v_preco_venda, v_quantidade_atual
        FROM inventario_view
        WHERE id_player = p_id_player
        AND id_item = p_id_item;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Você não possui este item no inventário.';
        END IF;

        IF v_quantidade_atual <= 0 THEN
            RAISE EXCEPTION 'Quantidade insuficiente para vender.';
        END IF;

        IF v_quantidade_atual > 1 THEN
            UPDATE item_armazenado
            SET quantidade = quantidade - 1
            WHERE id_inventario = p_id_player
            AND id_item = p_id_item;
        ELSE
            DELETE FROM item_armazenado
            WHERE id_inventario = p_id_player
            AND id_item = p_id_item;
        END IF;

        UPDATE inventario
        SET dinheiro = dinheiro + v_preco_venda
        WHERE id_player = p_id_player;

        RAISE NOTICE 'Item vendido com sucesso!';
    END $$;
    ```
</details>

### Comprar Armadura

Esta procedure permite que o jogador compre uma armadura, verificando se ele tem dinheiro suficiente e se atende ao nível mínimo necessário.

<details>
    <sumary>Migrações</sumary>

    ```sql
   CREATE OR REPLACE PROCEDURE comprar_armadura(
        p_id_player INTEGER,
        p_id_item INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_preco_compra INTEGER;
        v_nivel_minimo INTEGER;
        v_jogador_nivel INTEGER;
        v_dinheiro_disponivel INTEGER;
        v_raridade TEXT;
        v_defesa_magica INTEGER;
        v_defesa_fisica INTEGER;
        v_ataque_magico INTEGER;
        v_ataque_fisico INTEGER;
        v_durabilidade_max INTEGER;
    BEGIN
        SELECT iv.preco_compra, iv.nivel_minimo, a.raridade_armadura::TEXT,
            a.defesa_magica, a.defesa_fisica, a.ataque_magico, a.ataque_fisico, a.durabilidade_max
        INTO v_preco_compra, v_nivel_minimo, v_raridade, 
            v_defesa_magica, v_defesa_fisica, v_ataque_magico, v_ataque_fisico, v_durabilidade_max
        FROM item_a_venda iv
        JOIN tipo_item ti ON ti.id_item = iv.id_item
        JOIN armadura a ON a.id_armadura = ti.id_item
        WHERE iv.id_item = p_id_item;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Armadura não encontrada para compra.';
        END IF;

        SELECT nivel, i.dinheiro
        INTO v_jogador_nivel, v_dinheiro_disponivel
        FROM player p 
        JOIN inventario i 
        ON p.id_player = i.id_player
        WHERE p.id_player = p_id_player;

        IF v_jogador_nivel < v_nivel_minimo THEN
            RAISE EXCEPTION 'Você precisa ser nível % para comprar esta armadura.', v_nivel_minimo;
        END IF;

        IF v_dinheiro_disponivel < v_preco_compra THEN
            RAISE EXCEPTION 'Dinheiro insuficiente para comprar esta armadura.';
        END IF;

        UPDATE inventario
        SET dinheiro = dinheiro - v_preco_compra
        WHERE id_player = p_id_player;

        INSERT INTO armadura_instancia (
            id_armadura, id_parte_corpo_armadura, id_inventario, raridade_armadura,
            defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_atual, preco_venda
        )
        SELECT 
            a.id_armadura, a.id_parte_corpo, p_id_player, v_raridade,
            v_defesa_magica, v_defesa_fisica, v_ataque_magico, v_ataque_fisico, v_durabilidade_max, v_preco_compra
        FROM armadura a
        WHERE a.id_armadura = p_id_item;

        RAISE NOTICE 'Armadura comprada e adicionada ao inventário com sucesso!';
    END;
    $$;
    ```
</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 10/02/2025 | Criação do Documento | Vinícius Rufino |