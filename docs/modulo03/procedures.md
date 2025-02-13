## Introdução
De acordo com Sistemas de Banco de Dados de Elmasri e Navathe (2011), procedimentos mais elaborados para impor regras são popularmente chamados de procedimentos armazenados (stored procedures). Esses procedimentos se tornam parte da definição geral do banco de dados e são chamados de forma apropriada quando certas condições são atendidas.

As stored procedures desempenham um papel essencial na automação e padronização de operações dentro de um banco de dados, permitindo a execução eficiente de processos complexos diretamente no servidor de dados. Sua utilização proporciona maior desempenho, segurança e integridade, reduzindo a redundância de código e minimizando o tráfego entre a aplicação e o banco de dados.

## Objetivo
Este documento tem como objetivo documentar a implementação e utilização de *stored procedures* para gerenciar diferentes aspectos do sistema de banco de dados do nosso baseado em *Cavaleiros do Zodíaco*. As *procedures* descritas abrangem operações como consulta de inventário, gerenciamento de missões, movimentação do jogador pelo mundo do jogo, administração de grupo, manipulação de itens e armaduras, além de interações econômicas dentro do jogo.  



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

### Fabricar Armadura

Esta procedure permite que o jogador fabrique uma armadura, verificando se ele tem alma de aramdura e os materiais necessários e também se atende ao nível mínimo necessário.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE fabricar_armadura(
        IN p_id_player INT,
        IN p_id_item_gerado INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        material RECORD; 
        insuficiente BOOLEAN := FALSE;
        alma_necessaria INT;
        alma_disponivel INT;
        raridade_armadura TEXT;
        defesa_magica INT;
        defesa_fisica INT;
        ataque_magico INT;
        ataque_fisico INT;
        durabilidade_max INT;
        id_parte_corpo enum_parte_corpo;
    BEGIN
        -- Obter a quantidade de Alma de Armadura necessária e os atributos da armadura
        SELECT 
            r.alma_armadura, 
            ar.raridade_armadura, 
            ar.defesa_magica, 
            ar.defesa_fisica, 
            ar.ataque_magico, 
            ar.ataque_fisico, 
            ar.durabilidade_max, 
            ar.id_parte_corpo
        INTO 
            alma_necessaria, 
            raridade_armadura, 
            defesa_magica, 
            defesa_fisica, 
            ataque_magico, 
            ataque_fisico, 
            durabilidade_max, 
            id_parte_corpo
        FROM receitas_armadura_view r
        JOIN armadura ar ON r.id_item_gerado = ar.id_armadura
        WHERE r.id_item_gerado = p_id_item_gerado;

        -- Verificar se há Alma de Armadura suficiente no inventário
        SELECT alma_armadura
        INTO alma_disponivel
        FROM inventario
        WHERE id_player = p_id_player;

        IF alma_disponivel < alma_necessaria THEN
            RAISE EXCEPTION 'Você não tem Alma de Armadura suficiente para fabricar esta armadura.';
        END IF;

        -- Verificar se o jogador possui os materiais necessários
        FOR material IN 
            SELECT mr.id_material, mr.quantidade
            FROM material_receita mr
            WHERE mr.id_receita = p_id_item_gerado
        LOOP
            IF (SELECT quantidade 
                FROM item_armazenado 
                WHERE id_inventario = p_id_player 
                AND id_item = material.id_material) < material.quantidade THEN
                insuficiente := TRUE;
            END IF;
        END LOOP;

        IF insuficiente THEN
            RAISE EXCEPTION 'Você não tem materiais suficientes para fabricar esta armadura.';
        END IF;

        -- Consumir a Alma de Armadura
        UPDATE inventario
        SET alma_armadura = alma_armadura - alma_necessaria
        WHERE id_player = p_id_player;

        -- Consumir os materiais necessários
        UPDATE item_armazenado ia
        SET quantidade = ia.quantidade - mr.quantidade
        FROM material_receita mr
        WHERE ia.id_inventario = p_id_player
        AND ia.id_item = mr.id_material
        AND mr.id_receita = p_id_item_gerado;

        -- Criar a instância da armadura
        INSERT INTO armadura_instancia (
            id_armadura, 
            id_parte_corpo_armadura, 
            id_inventario, 
            raridade_armadura, 
            defesa_magica, 
            defesa_fisica, 
            ataque_magico, 
            ataque_fisico, 
            durabilidade_atual
        )
        VALUES (
            p_id_item_gerado,         -- ID da armadura gerada
            id_parte_corpo,           -- Parte do corpo da armadura
            p_id_player,              -- ID do inventário do jogador (correspondente ao ID do jogador)
            raridade_armadura,        -- Raridade da armadura
            defesa_magica,            -- Defesa mágica
            defesa_fisica,            -- Defesa física
            ataque_magico,            -- Ataque mágico
            ataque_fisico,            -- Ataque físico
            durabilidade_max          -- Durabilidade máxima
        );

        RAISE NOTICE 'Armadura fabricada com sucesso e adicionada ao inventário!';
    END;
    $$;
    ```
</details>

### Equipar Armadura

Esta procedure permite que um jogador equipe uma armadura específica que esteja em seu inventário.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE equipar_armadura(
        p_id_player INTEGER,
        p_id_instancia INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_id_armadura INTEGER;
        v_id_parte_corpo_armadura enum_parte_corpo;
        v_armadura_atual INTEGER;
        v_instancia_atual INTEGER;
    BEGIN
        -- Verificar se a armadura existe no inventário do jogador
        SELECT id_armadura, id_parte_corpo_armadura
        INTO v_id_armadura, v_id_parte_corpo_armadura
        FROM Armadura_Instancia
        WHERE id_instancia = p_id_instancia
        AND id_inventario = p_id_player;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'A armadura não está no inventário do jogador ou não existe.';
        END IF;

        -- Verificar se o jogador já possui uma armadura equipada na mesma parte do corpo
        SELECT armadura_equipada, instancia_armadura_equipada
        INTO v_armadura_atual, v_instancia_atual
        FROM Parte_Corpo_Player
        WHERE id_player = p_id_player
        AND parte_corpo = v_id_parte_corpo_armadura;

        IF FOUND THEN
            -- Se uma armadura já estiver equipada, ela é devolvida ao inventário
            UPDATE Armadura_Instancia
            SET id_inventario = p_id_player
            WHERE id_armadura = v_armadura_atual
            AND id_instancia = v_instancia_atual;
        END IF;

        -- Atualizar a nova armadura como equipada
        UPDATE Parte_Corpo_Player
        SET armadura_equipada = v_id_armadura,
            instancia_armadura_equipada = p_id_instancia
        WHERE id_player = p_id_player
        AND parte_corpo = v_id_parte_corpo_armadura;

        -- Remover a armadura equipada do inventário
        UPDATE Armadura_Instancia
        SET id_inventario = NULL
        WHERE id_instancia = p_id_instancia;

        RAISE NOTICE 'A armadura foi equipada com sucesso!';
    END;
    $$;
    ```
</details>

### Restaurar Durabilidade

Restaura a durabilidade de uma armadura específica no inventário de um jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE restaurar_durabilidade(
        p_id_player INT,
        p_id_instancia INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_raridade VARCHAR(20);
        v_durabilidade_atual INT;
        v_custo_alma INT;
        v_almas_disponiveis INT;
        v_id_custo_ferreiro INT;
        v_material_id INT;
        v_quantidade_necessaria INT;
        v_quantidade_disponivel INT;
        v_id_inventario INT;
        v_nome_material TEXT;
    BEGIN
        -- Buscar o ID do inventário do jogador
        SELECT id_player INTO v_id_inventario
        FROM inventario
        WHERE id_player = p_id_player;

        -- Se o inventário não existir, retorna erro
        IF v_id_inventario IS NULL THEN
            RAISE EXCEPTION 'Inventário não encontrado para o jogador!';
        END IF;

        -- Buscar informações da armadura
        SELECT raridade_armadura, durabilidade_atual 
        INTO v_raridade, v_durabilidade_atual
        FROM armadura_instancia 
        WHERE id_instancia = p_id_instancia;

        -- Se a armadura não existir, retorna erro
        IF v_raridade IS NULL OR v_durabilidade_atual IS NULL THEN
            RAISE EXCEPTION 'A armadura selecionada não existe!';
        END IF;

        -- Se a durabilidade já estiver em 100%, não faz nada
        IF v_durabilidade_atual = 100 THEN
            RAISE EXCEPTION 'A durabilidade já está em 100%%. Nenhuma restauração foi feita.';
            RETURN;
        END IF;

        -- Buscar o custo de alma da restauração com base na durabilidade atual
        SELECT id, custo_alma INTO v_id_custo_ferreiro, v_custo_alma
        FROM custos_ferreiro
        WHERE tipo_acao = 'restaurar'
        AND raridade = v_raridade
        AND v_durabilidade_atual BETWEEN durabilidade_min AND durabilidade_max;

        -- Se não encontrou um custo, retorna erro
        IF v_id_custo_ferreiro IS NULL THEN
            RAISE EXCEPTION 'Erro ao calcular o custo de restauração!';
        END IF;

        -- Buscar quantas Almas de Armadura o jogador tem
        SELECT alma_armadura INTO v_almas_disponiveis
        FROM inventario
        WHERE id_player = p_id_player;

        -- Se o jogador não tem almas ou não tem o suficiente, retorna erro
        IF v_almas_disponiveis IS NULL OR v_almas_disponiveis < v_custo_alma THEN
            RAISE EXCEPTION 'Você não tem Almas de Armadura suficientes para restaurar a durabilidade!';
        END IF;

        -- Deduzir as Almas de Armadura do jogador
        UPDATE inventario
        SET alma_armadura = alma_armadura - v_custo_alma
        WHERE id_player = p_id_player;

        -- Restaurar a durabilidade da armadura
        UPDATE armadura_instancia
        SET durabilidade_atual = 100
        WHERE id_instancia = p_id_instancia;

        RAISE NOTICE 'Durabilidade restaurada para 100%%! Foram usadas % Almas.', v_custo_alma;
    END;
    $$;
    ```
</details>

### Melhorar armadura
Essa procedure permite que o jogador melhore as instancias de armaduras encontradas em seu inventário (seja equipada ou não), reduzindo a quantidade de alma de armaduras e materiais necessários.

<details>
    <sumary>Migration V56</sumary>

    ```sql  
    CREATE OR REPLACE PROCEDURE melhorar_armadura(
        p_id_player INT,
        p_id_instancia INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_raridade_atual VARCHAR(20);
        v_nova_raridade VARCHAR(20);
        v_custo_alma INT;
        v_almas_disponiveis INT;
        v_id_custo_ferreiro INT;
        v_id_inventario INT;
        v_material_id INT;
        v_quantidade_necessaria INT;
        v_quantidade_disponivel INT;
        v_material_nome TEXT;
        v_nome_armadura TEXT;
    BEGIN
        -- Buscar o ID do inventário do jogador
        SELECT id_player INTO v_id_inventario
        FROM inventario
        WHERE id_player = p_id_player;

        -- Se o inventário não existir, retorna erro
        IF v_id_inventario IS NULL THEN
            RAISE EXCEPTION 'Inventário não encontrado para o jogador!';
        END IF;

        -- Pega o nome da armadura
        SELECT  a.nome into v_nome_armadura
        FROM armadura_instancia ai
        JOIN armadura a on a.id_armadura = ai.id_armadura
        WHERE id_instancia = p_id_instancia;

        -- Buscar a raridade atual da armadura
        SELECT raridade_armadura INTO v_raridade_atual
        FROM armadura_instancia
        WHERE id_instancia = p_id_instancia;

        -- Definir a nova raridade
        IF v_raridade_atual = 'Bronze' THEN
            v_nova_raridade := 'Prata';
        ELSIF v_raridade_atual = 'Prata' THEN
            v_nova_raridade := 'Ouro';
        ELSE
            RAISE EXCEPTION 'Esta armadura já está no nível máximo (Ouro)!';
        END IF;

        -- Buscar o custo da melhoria
        SELECT id, custo_alma INTO v_id_custo_ferreiro, v_custo_alma
        FROM custos_ferreiro
        WHERE tipo_acao = 'melhorar' AND raridade = v_raridade_atual;

        -- Se não encontrou o custo, retorna erro
        IF v_id_custo_ferreiro IS NULL THEN
            RAISE EXCEPTION 'Erro ao calcular o custo de melhoria!';
        END IF;

        -- Buscar quantas Almas de Armadura o jogador tem
        SELECT alma_armadura INTO v_almas_disponiveis
        FROM inventario
        WHERE id_player = p_id_player;

        -- Se o jogador não tem almas ou não tem o suficiente, retorna erro
        IF v_almas_disponiveis IS NULL OR v_almas_disponiveis < v_custo_alma THEN
            RAISE EXCEPTION 'Você não tem Almas de Armadura suficientes para melhorar a Armadura % ! Custo: %, Disponível: %', v_nome_armadura, v_custo_alma, COALESCE(v_almas_disponiveis, 0);
        END IF;

        -- Verificar materiais necessários na tabela material_necessario_ferreiro
        FOR v_material_id, v_quantidade_necessaria, v_material_nome IN
            SELECT mn.id_material, quantidade, m.nome
            FROM material_necessario_ferreiro mn
            JOIN material m
            ON m.id_material = mn.id_material
            WHERE id_custo_ferreiro = v_id_custo_ferreiro
        LOOP
            -- Verificar quantidade disponível do material no inventário
            SELECT quantidade INTO v_quantidade_disponivel
            FROM item_armazenado
            WHERE id_inventario = v_id_inventario AND id_item = v_material_id;

            -- Se não houver quantidade suficiente do material, retorna erro
            IF v_quantidade_disponivel IS NULL OR v_quantidade_disponivel < v_quantidade_necessaria THEN
                RAISE EXCEPTION 'Você não possui materiais suficientes para melhorar a Armadura %! Material: %, Necessário: %, Disponível: %', v_nome_armadura, v_material_nome, v_quantidade_necessaria, COALESCE(v_quantidade_disponivel, 0);
            END IF;
        END LOOP;

        -- Deduzir as Almas de Armadura do jogador
        UPDATE inventario
        SET alma_armadura = alma_armadura - v_custo_alma
        WHERE id_player = p_id_player;

        -- Deduzir os materiais necessários do inventário do jogador
        FOR v_material_id, v_quantidade_necessaria IN
            SELECT id_material, quantidade
            FROM material_necessario_ferreiro
            WHERE id_custo_ferreiro = v_id_custo_ferreiro
        LOOP
            UPDATE item_armazenado
            SET quantidade = quantidade - v_quantidade_necessaria
            WHERE id_inventario = v_id_inventario AND id_item = v_material_id;
        END LOOP;

        -- Melhorar a raridade da armadura e restaurar a durabilidade
        UPDATE armadura_instancia
        SET raridade_armadura = v_nova_raridade, durabilidade_atual = 100
        WHERE id_instancia = p_id_instancia;

        RAISE NOTICE 'Armadura melhorada para % e durabilidade restaurada para 100%%! Foram usadas % Almas e os materiais necessários foram consumidos.', v_nova_raridade, v_custo_alma;
    END;
    $$;

    ```
</details>

### Desmanchar Armadura
Essa procedure peremite que o jogador desmanche as instancias de armaduras encontradas em seu inventário (seja equipada ou não), recebendo alma de armadura como recompensa.

<details>
    <sumary>Migration V56</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE desmanchar_armadura(
    p_id_player INT,
    p_id_instancia INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_raridade VARCHAR(20);
        v_almas_recebidas INT;
    BEGIN
        -- Buscar a raridade da armadura
        SELECT raridade_armadura INTO v_raridade
        FROM armadura_instancia
        WHERE id_instancia = p_id_instancia;

        -- Se a armadura não existir, retorna erro
        IF v_raridade IS NULL THEN
            RAISE EXCEPTION 'A armadura selecionada não existe!';
        END IF;

        -- Buscar quantas Almas serão recebidas
        SELECT custo_alma INTO v_almas_recebidas
        FROM custos_ferreiro
        WHERE tipo_acao = 'desmanchar' AND raridade = v_raridade;

        -- Se o custo não for encontrado, retorna erro
        IF v_almas_recebidas IS NULL THEN
            RAISE EXCEPTION 'Erro ao calcular a quantidade de Almas recebidas ao desmanchar!';
        END IF;

        UPDATE parte_corpo_player
        SET instancia_armadura_equipada = NULL, armadura_equipada = NULL
        WHERE id_player = p_id_player AND instancia_armadura_equipada = p_id_instancia;

        -- Remover a armadura da tabela armadura_instancia
        DELETE FROM armadura_instancia WHERE id_instancia = p_id_instancia;

        -- Adicionar as Almas ao inventário do jogador
        UPDATE inventario
        SET alma_armadura = alma_armadura + v_almas_recebidas
        WHERE id_player = p_id_player;

        RAISE NOTICE 'Armadura desmanchada! Você recebeu % Almas de Armadura.', v_almas_recebidas;
    END;
    $$;

    CREATE PROCEDURE adicionar_cavaleiro_party(
        IN p_id_cavaleiro INT,
        IN p_id_player INT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        -- Verifica se o cavaleiro pertence ao jogador
        IF EXISTS (
            SELECT 1
            FROM instancia_cavaleiro
            WHERE id_cavaleiro = p_id_cavaleiro
            AND id_player = p_id_player
        ) THEN
            -- Atualiza o id_party do cavaleiro para o id_player
            UPDATE instancia_cavaleiro
            SET id_party = p_id_player
            WHERE id_cavaleiro = p_id_cavaleiro
            AND id_player = p_id_player;

            -- Mensagem de confirmação no log do servidor
            RAISE NOTICE 'Cavaleiro ID % foi adicionado à party do jogador %', p_id_cavaleiro, p_id_player;

        ELSE
            -- Caso o cavaleiro não pertença ao jogador, lança um erro
            RAISE EXCEPTION 'Cavaleiro não pertence ao jogador ou já está na party.';
        END IF;
    END;
    $$;
    ```
</details>

### Remover Cavaleiro da Party
A stored procedure remover_cavaleiro_party tem a função de remover um cavaleiro da party de um jogador. Ela verifica se o cavaleiro pertence ao jogador e se está atualmente na party antes de executar a remoção.

<details>

    ```sql

    CREATE PROCEDURE remover_cavaleiro_party(
    IN p_id_cavaleiro INT,
    IN p_id_player INT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        -- Verifica se o cavaleiro pertence ao jogador e está na party
        IF EXISTS (
            SELECT 1
            FROM instancia_cavaleiro
            WHERE id_cavaleiro = p_id_cavaleiro
            AND id_player = p_id_player
            AND id_party = p_id_player
        ) THEN
            -- Atualiza o id_party do cavaleiro para NULL, removendo da party
            UPDATE instancia_cavaleiro
            SET id_party = NULL
            WHERE id_cavaleiro = p_id_cavaleiro
            AND id_player = p_id_player;

            -- Mensagem de confirmação no log do servidor
            RAISE NOTICE 'Cavaleiro ID % foi removido da party do jogador %', p_id_cavaleiro, p_id_player;

        ELSE
            -- Caso o cavaleiro não pertença ao jogador ou não esteja na party, lança um erro
            RAISE EXCEPTION 'Cavaleiro não pertence ao jogador ou não está na party.';
        END IF;
    END;
    $$;
   
    ```

</details>

### Dropar itens do Boss
A stored procedure adicionar_drop_boss é responsável por adicionar ao inventário do jogador os itens que um boss deixa como recompensa após ser derrotado.

<details>

    ```sql

    CREATE OR REPLACE PROCEDURE adicionar_drop_boss(
    p_id_boss INT, 
    p_id_player INT
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        r_item RECORD;
    BEGIN
        -- Percorre todos os itens que o boss dropa
        FOR r_item IN
            SELECT id_item, quantidade
            FROM item_boss_dropa
            WHERE id_boss = p_id_boss
        LOOP
            -- Insere ou atualiza os itens no inventário do jogador
            INSERT INTO item_armazenado (id_inventario, id_item, quantidade)
            VALUES (p_id_player, r_item.id_item, r_item.quantidade)
            ON CONFLICT (id_inventario, id_item)
            DO UPDATE SET quantidade = item_armazenado.quantidade + EXCLUDED.quantidade;
        END LOOP;
    END;
    $$;

    ```

</details>

## Não utilizados
Abaixo se encontram as procedures que não foram utilizadas quanto ao controle de integralidade pois faltou refatoramento

<details>

    ```sql
    CREATE OR REPLACE PROCEDURE inserir_item(
        IN p_tipo_item enum_tipo_item,
        IN p_nome VARCHAR,
        IN p_preco_venda INT DEFAULT NULL,
        IN p_descricao VARCHAR DEFAULT NULL,
        IN p_id_parte_corpo enum_parte_corpo DEFAULT NULL,
        IN p_raridade_armadura VARCHAR DEFAULT NULL,
        IN p_defesa_magica INT DEFAULT NULL,
        IN p_defesa_fisica INT DEFAULT NULL,
        IN p_ataque_magico INT DEFAULT NULL,
        IN p_ataque_fisico INT DEFAULT NULL,
        IN p_durabilidade_max INT DEFAULT NULL,
        IN p_saude_restaurada INT DEFAULT NULL, 
        IN p_magia_restaurada INT DEFAULT NULL, 
        IN p_saude_maxima INT DEFAULT NULL, 
        IN p_magia_maxima INT DEFAULT NULL, 
        IN p_id_habilidade INT DEFAULT NULL 
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_id_item INT;
    BEGIN
        
        INSERT INTO tipo_item (tipo_item) VALUES (p_tipo_item) RETURNING id_item INTO v_id_item;

        
        CASE p_tipo_item
            WHEN 'm' THEN 
                INSERT INTO material (id_material, nome, preco_venda, descricao) 
                VALUES (v_id_item, p_nome, p_preco_venda, p_descricao);
            
            WHEN 'a' THEN 
                INSERT INTO armadura (id_armadura, id_parte_corpo, nome, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max, preco_venda, descricao) 
                VALUES (v_id_item, p_id_parte_corpo, p_nome, p_raridade_armadura, p_defesa_magica, p_defesa_fisica, p_ataque_magico, p_ataque_fisico, p_durabilidade_max, p_preco_venda, p_descricao);
            
            WHEN 'i' THEN 
                INSERT INTO item_missao (id_item, nome, descricao) 
                VALUES (v_id_item, p_nome, p_descricao);
            
            WHEN 'c' THEN 
                INSERT INTO consumivel (id_item, nome, descricao, preco_venda, saude_restaurada, magia_restaurada, saude_maxima, magia_maxima) 
                VALUES (v_id_item, p_nome, p_descricao, p_preco_venda, p_saude_restaurada, p_magia_restaurada, p_saude_maxima, p_magia_maxima);
            
            WHEN 'l' THEN 
                INSERT INTO livro (id_item, id_habilidade, nome, descricao, preco_venda) 
                VALUES (v_id_item, p_id_habilidade, p_nome, p_descricao, p_preco_venda);
            
            ELSE 
                RAISE EXCEPTION 'Tipo de item inválido!';
        END CASE;

        RAISE NOTICE 'Item inserido com sucesso! ID: %', v_id_item;
    END;
    $$;
    ```

</details>

## Referência Bibliográfica

> [1] ELMASRI, Ramez; NAVATHE, Shamkant B. Sistemas de banco de dados. Tradução: Daniel Vieira. Revisão técnica: Enzo Seraphim; Thatyana de Faria Piola Seraphim. 6. ed. São Paulo: Pearson Addison Wesley, 2011. Capítulo 7. Modelagem de dados usando o modelo Entidade-Relacionamento (ER), páginas 131 e 146.

## Bibliografia
> Triggers e Stored Procedure Prison Trading. Disponível em: https://sbd1.github.io/2024.1-Prison-Trading/#/Modulo-3/Triggers Acesso em 13 de fevereiro de 2025.

> Triggers e Stored Procedure Ben 10. Disponível em: https://sbd1.github.io/2024.1-Ben10/modulo3/triggers/ Acesso em 13 de fevereiro de 2025.

## Histórico de Versões

| Versão | Data       | Modificação                                              | Autor                                       |
| ------ | ---------- | -------------------------------------------------------- | ------------------------------------------- |
| 0.1    | 10/02/2025 | Criação do Documento                                     | Vinícius Rufino                             |
| 1.0    | 10/02/2025 | Atualização dos Procedures                               | Vinícius Rufino                             |
| 2.0    | 13/02/2025 | Atualização e refatoração do documento para versão final | [Pedro Lucas](https://github.com/lucasdray) |