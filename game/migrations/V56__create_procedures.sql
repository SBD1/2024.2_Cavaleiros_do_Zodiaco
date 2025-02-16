CREATE OR REPLACE PROCEDURE get_inventario_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN cur FOR
        SELECT * FROM inventario_view
        WHERE id_player = p_id_player;
END;
$$;

CREATE OR REPLACE PROCEDURE get_missoes_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
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


CREATE OR REPLACE PROCEDURE get_grupo_cursor(IN p_id_player INT, INOUT cur REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN cur FOR
        SELECT * FROM grupo_view
        WHERE id_player = p_id_player;
END;
$$;


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
    -- Obtém o ID da sala (party) do jogador
    SELECT id_sala INTO id_sala_var
    FROM party
    WHERE id_player = p_id_player
    LIMIT 1;

    -- Se a party não existir, sair com erro
    IF id_sala_var IS NULL THEN
        RAISE EXCEPTION 'O jogador não tem uma party.';
    END IF;

    -- Conta quantos cavaleiros já estão na party
    SELECT COUNT(*) INTO total_cavaleiros
    FROM instancia_cavaleiro
    WHERE id_party = id_sala_var;

    -- Se a party já tiver 3 cavaleiros
    IF total_cavaleiros >= 3 THEN
        -- Verifica se o cavaleiro escolhido para remoção está na party
        IF NOT EXISTS (
            SELECT 1
            FROM instancia_cavaleiro
            WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido
        ) THEN
            RAISE EXCEPTION 'O cavaleiro escolhido para remoção não está na party.';
        END IF;

        -- Remove o cavaleiro da party
        UPDATE instancia_cavaleiro
        SET id_party = NULL
        WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido;

        RAISE NOTICE 'Cavaleiro % foi removido da party.', p_id_cavaleiro_removido;
    END IF;

    -- Adiciona o novo cavaleiro à party
    UPDATE instancia_cavaleiro
    SET id_party = id_sala_var
    WHERE id_cavaleiro = p_id_cavaleiro_novo;

    RAISE NOTICE 'Cavaleiro % foi adicionado à party.', p_id_cavaleiro_novo;
END;
$$;


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
    -- Verificar o dinheiro disponível do jogador
    SELECT dinheiro, id_player INTO v_dinheiro_atual, v_id_inventario
    FROM inventario
    WHERE id_player = p_id_player;

    IF v_dinheiro_atual IS NULL THEN
        RAISE EXCEPTION 'Jogador não encontrado.';
    END IF;

    -- Verificar o preço e o nível mínimo do item
    SELECT preco_compra, nivel_minimo INTO v_preco_item, v_level_minimo
    FROM item_a_venda
    WHERE id_item = p_id_item;

    IF v_preco_item IS NULL THEN
        RAISE EXCEPTION 'Item não encontrado.';
    END IF;

    -- Verificar o nível do jogador
    SELECT nivel INTO v_jogador_level
    FROM player
    WHERE id_player = p_id_player;

    IF v_jogador_level IS NULL THEN
        RAISE EXCEPTION 'Jogador não encontrado.';
    END IF;

    IF v_jogador_level < v_level_minimo THEN
        RAISE EXCEPTION 'Você precisa ser nível % para comprar este item.', v_level_minimo;
    END IF;

    -- Verificar se o jogador tem dinheiro suficiente
    IF v_dinheiro_atual < v_preco_item THEN
        RAISE EXCEPTION 'Dinheiro insuficiente para comprar o item.';
    END IF;

    -- Subtrair o preço do item do dinheiro do jogador
    UPDATE inventario
    SET dinheiro = dinheiro - v_preco_item
    WHERE id_player = v_id_inventario;

    -- Verificar se o item já existe no inventário do jogador
    SELECT quantidade INTO v_quantidade_atual
    FROM item_armazenado
    WHERE id_inventario = v_id_inventario
      AND id_item = p_id_item;

    -- Se o item não existir, adicioná-lo ao inventário com quantidade 1
    IF NOT FOUND THEN
        INSERT INTO item_armazenado (id_inventario, id_item, quantidade)
        VALUES (v_id_inventario, p_id_item, 1);
    ELSE
        -- Caso contrário, incrementar a quantidade do item existente
        UPDATE item_armazenado
        SET quantidade = quantidade + 1
        WHERE id_inventario = v_id_inventario
          AND id_item = p_id_item;
    END IF;

    RAISE NOTICE 'Item comprado com sucesso!';

END $$;

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
    -- Verificar o preço de venda e a quantidade atual do item no inventário do jogador
    SELECT preco_venda, quantidade
    INTO v_preco_venda, v_quantidade_atual
    FROM inventario_view
    WHERE id_player = p_id_player
      AND id_item = p_id_item;

    -- Verificar se o item existe no inventário
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Você não possui este item no inventário.';
    END IF;

    -- Verificar se o item tem quantidade suficiente para ser vendido
    IF v_quantidade_atual <= 0 THEN
        RAISE EXCEPTION 'Quantidade insuficiente para vender.';
    END IF;

    -- Atualizar a quantidade do item no inventário
    IF v_quantidade_atual > 1 THEN
        UPDATE item_armazenado
        SET quantidade = quantidade - 1
        WHERE id_inventario = p_id_player
          AND id_item = p_id_item;
    ELSE
        -- Remover o item do inventário se a quantidade for zero após a venda
        DELETE FROM item_armazenado
        WHERE id_inventario = p_id_player
          AND id_item = p_id_item;
    END IF;

    -- Adicionar o valor do item ao dinheiro do jogador
    UPDATE inventario
    SET dinheiro = dinheiro + v_preco_venda
    WHERE id_player = p_id_player;

    RAISE NOTICE 'Item vendido com sucesso!';
END $$;

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
    SELECT id_armadura, id_armadura_instanciada
    INTO v_armadura_atual, v_instancia_atual
    FROM Armadura_Equipada
    WHERE id_player = p_id_player
      AND id_parte_corpo_armadura = v_id_parte_corpo_armadura;

    -- Se o jogador já tem uma armadura equipada, removê-la e devolvê-la ao inventário
    IF FOUND THEN
        -- Atualiza a armadura antiga para voltar ao inventário do jogador
        UPDATE Armadura_Instancia
        SET id_inventario = p_id_player
        WHERE id_instancia = v_instancia_atual
          AND id_armadura = v_armadura_atual;

        -- Remove a armadura equipada
        DELETE FROM Armadura_Equipada
        WHERE id_player = p_id_player
          AND id_parte_corpo_armadura = v_id_parte_corpo_armadura;
    END IF;

    -- Equipar a nova armadura
    INSERT INTO Armadura_Equipada (id_player, id_armadura, id_armadura_instanciada, id_parte_corpo_armadura)
    VALUES (p_id_player, v_id_armadura, p_id_instancia, v_id_parte_corpo_armadura);


    RAISE NOTICE 'A armadura foi equipada com sucesso!';
END;
$$;


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

    -- Buscar o custo de alma da restauração com  na durabilidade atual
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
        RAISE EXCEPTION 'Você não tem Almas de Armadura suficientes para restaurar a durabilidade! Custo: %, Disponível: %', v_custo_alma, COALESCE(v_almas_disponiveis, 0);
    END IF;

    -- Verificar materiais necessários na tabela material_necessario_ferreiro
    FOR v_material_id, v_quantidade_necessaria, v_nome_material IN
        SELECT mn.id_material, quantidade, m.nome
        FROM material_necessario_ferreiro mn
        JOIN material m
        ON mn.id_material = m.id_material
        WHERE id_custo_ferreiro = v_id_custo_ferreiro
    LOOP
        -- Verificar quantidade disponível do material no inventário
        SELECT quantidade INTO v_quantidade_disponivel
        FROM item_armazenado
        WHERE id_inventario = v_id_inventario AND id_item = v_material_id;

        -- Se não houver quantidade suficiente do material, retorna erro
        IF v_quantidade_disponivel IS NULL OR v_quantidade_disponivel < v_quantidade_necessaria THEN
            RAISE EXCEPTION 'Você não possui materiais suficientes para restaurar a durabilidade! Material: %, Necessário: %, Disponível: %', v_nome_material, v_quantidade_necessaria, COALESCE(v_quantidade_disponivel, 0);
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

    -- Restaurar a durabilidade da armadura
    UPDATE armadura_instancia
    SET durabilidade_atual = 100
    WHERE id_instancia = p_id_instancia;

    RAISE NOTICE 'Durabilidade restaurada para 100%%! Foram usadas % Almas e os materiais necessários foram consumidos.', v_custo_alma;
END;
$$;




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