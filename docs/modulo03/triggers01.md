## Introdução
De acordo com Sistemas de Banco de Dados de Elmasri e Navathe (2011), regras ativas podem ser disparadas automaticamente por eventos que ocorrem, como atualizações no banco de dados ou certos momentos sendo alcançados, e podem iniciar ações especificadas na declaração da regra, desde que determinadas condições sejam atendidas. 

Diante da necessidade de garantir automação, integridade e consistência nos sistemas de gerenciamento de banco de dados, os triggers se tornaram um mecanismo essencial. Eles permitem a execução de ações automáticas em resposta a eventos específicos, reduzindo a necessidade de intervenção manual e garantindo a aplicação de regras de negócio de maneira eficiente.

## Objetivo
Este documento apresenta a implementação e utilização de triggers no sistema, detalhando suas funcionalidades, benefícios e aplicabilidades dentro do contexto do gerenciamento de dados.

## Triggers

### Instanciar Parte do Corpo de Boss
O trigger trigger_gerar_partes_corpo_boss e sua função associada gerar_partes_corpo_boss são responsáveis pela criação automática das partes do corpo de um boss assim que ele é inserido na tabela boss.

<details>

    ```sql

    CREATE OR REPLACE FUNCTION gerar_partes_corpo_boss()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.parte_corpo_boss (id_boss, parte_corpo, defesa_fisica, defesa_magica, chance_acerto, chance_acerto_critico)
        SELECT 
            NEW.id_boss,                     
            pc.id_parte_corpo,               
            pc.defesa_fisica * 2,           
            pc.defesa_magica * 2,           
            pc.chance_acerto * 2,            
            pc.chance_acerto_critico * 2     
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER trigger_gerar_partes_corpo_boss
    AFTER INSERT ON public.boss
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_boss();

    ```


</details>


### Instanciar Parte do Corpo de Cavaleiro
O trigger trigger_gerar_partes_corpo_cavaleiro e sua função associada gerar_partes_corpo_cavaleiro são responsáveis por criar automaticamente as partes do corpo de um cavaleiro assim que ele é inserido na tabela instancia_cavaleiro.
<details>

    ```sql

    CREATE OR REPLACE FUNCTION gerar_partes_corpo_cavaleiro()
    RETURNS TRIGGER AS $$
    BEGIN
    
        INSERT INTO public.parte_corpo_cavaleiro (
            id_cavaleiro, 
            parte_corpo,  
            id_player, 
            defesa_fisica, 
            defesa_magica, 
            chance_acerto, 
            chance_acerto_critico
        )
        SELECT 
            NEW.id_cavaleiro,        
            pc.id_parte_corpo,        
            NEW.id_player,            
            pc.defesa_fisica,          
            pc.defesa_magica,         
            pc.chance_acerto,          
            pc.chance_acerto_critico   
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_gerar_partes_corpo_cavaleiro
    AFTER INSERT ON public.instancia_cavaleiro
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_cavaleiro();

    ```


</details>

### Instanciar Parte do Corpo de Player
O trigger trigger_gerar_partes_corpo_player e sua função associada gerar_partes_corpo_player têm a função de criar automaticamente as partes do corpo do jogador assim que ele é inserido na tabela player.
<details>

    ```sql

    CREATE OR REPLACE FUNCTION gerar_partes_corpo_player()
    RETURNS TRIGGER AS $$
    BEGIN
        
        INSERT INTO public.parte_corpo_player (
            id_player, 
            parte_corpo, 
            defesa_fisica, 
            defesa_magica, 
            chance_acerto, 
            chance_acerto_critico
        )
        SELECT 
            NEW.id_player,   
            pc.id_parte_corpo, 
            pc.defesa_fisica,          
            pc.defesa_magica,         
            pc.chance_acerto,          
            pc.chance_acerto_critico 
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_gerar_partes_corpo_player
    AFTER INSERT ON public.player
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_player();

    ```


</details>

### Instanciar Parte do Corpo de Inimigo
O trigger trigger_gerar_partes_corpo_inimigo e sua função associada gerar_partes_corpo_inimigo são responsáveis por criar automaticamente as partes do corpo de um inimigo assim que ele é inserido na tabela instancia_inimigo.
<details>

    ```sql

    CREATE OR REPLACE FUNCTION gerar_partes_corpo_inimigo()
    RETURNS TRIGGER AS $$
    BEGIN
    
        INSERT INTO public.parte_corpo_inimigo (
            id_instancia, 
            id_inimigo,
            parte_corpo, 
            defesa_fisica, 
            defesa_magica, 
            chance_acerto, 
            chance_acerto_critico
        )
        SELECT 
            NEW.id_instancia,      
            NEW.id_inimigo,        
            pc.id_parte_corpo,     
            pc.defesa_fisica,      
            pc.defesa_magica,     
            pc.chance_acerto,      
            pc.chance_acerto_critico  
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER trigger_gerar_partes_corpo_inimigo
    AFTER INSERT ON public.instancia_inimigo
    FOR EACH ROW
    EXECUTE FUNCTION gerar_partes_corpo_inimigo();

    ```

</details>

### Integridade de Personagem
O trigger de integridade trigger_inserir_tipo_personagem e sua função associada inserir_tipo_personagem são responsáveis por registrar automaticamente o tipo de personagem ao inserir um novo player, cavaleiro, inimigo ou boss no banco de dados.

<details>

    ```sql

    CREATE OR REPLACE FUNCTION inserir_tipo_personagem()
    RETURNS TRIGGER AS $$
    DECLARE
        v_id_personagem INTEGER;
    BEGIN
        IF TG_TABLE_NAME = 'player' THEN
            INSERT INTO Tipo_Personagem (tipo_personagem)
            VALUES ('p')
            RETURNING id_personagem INTO v_id_personagem;
            NEW.id_player := v_id_personagem;

        ELSIF TG_TABLE_NAME = 'cavaleiro' THEN
            INSERT INTO Tipo_Personagem (tipo_personagem)
            VALUES ('c')
            RETURNING id_personagem INTO v_id_personagem;
            NEW.id_cavaleiro := v_id_personagem;

        ELSIF TG_TABLE_NAME = 'inimigo' THEN
            INSERT INTO Tipo_Personagem (tipo_personagem)
            VALUES ('i')
            RETURNING id_personagem INTO v_id_personagem;
            NEW.id_inimigo := v_id_personagem;

        ELSIF TG_TABLE_NAME = 'boss' THEN
            INSERT INTO Tipo_Personagem (tipo_personagem)
            VALUES ('b')
            RETURNING id_personagem INTO v_id_personagem;
            NEW.id_boss:= v_id_personagem;
        ELSE
            RAISE EXCEPTION 'Tabela desconhecida para a trigger inserir_tipo_personagem';
        END IF;


        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER trigger_inserir_tipo_personagem_personagem
    BEFORE INSERT ON Player
    FOR EACH ROW
    EXECUTE FUNCTION inserir_tipo_personagem();

    CREATE TRIGGER trigger_inserir_tipo_personagem_cavaleiro
    BEFORE INSERT ON Cavaleiro
    FOR EACH ROW
    EXECUTE FUNCTION inserir_tipo_personagem();

    CREATE TRIGGER trigger_inserir_tipo_personagem_inimigo
    BEFORE INSERT ON Inimigo
    FOR EACH ROW
    EXECUTE FUNCTION inserir_tipo_personagem();

    CREATE TRIGGER trigger_inserir_tipo_personagem_boss
    BEFORE INSERT ON Boss
    FOR EACH ROW
    EXECUTE FUNCTION inserir_tipo_personagem();

    ```
</details>

### Integridade de NPC
O trigger de integridade trigger_inserir_tipo_npc e sua função associada inserir_tipo_npc têm a função de registrar automaticamente o tipo de NPC ao inserir um novo ferreiro, mercador ou NPC de missão no banco de dados.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION inserir_tipo_npc()
    RETURNS TRIGGER AS $$
    DECLARE
        v_id_npc INTEGER;
        v_tipo_npc enum_tipo_npc;
    BEGIN
        -- Determinar o tipo do NPC com base na tabela de origem
        IF TG_TABLE_NAME = 'ferreiro' THEN
            v_tipo_npc := 'f';
        ELSIF TG_TABLE_NAME = 'mercador' THEN
            v_tipo_npc := 'm';
        ELSIF TG_TABLE_NAME = 'quest' THEN
            v_tipo_npc := 'q';
        ELSE
            RAISE EXCEPTION 'Tipo de NPC desconhecido';
        END IF;

        -- Inserir na tabela Tipo_NPC e capturar o id_npc gerado
        INSERT INTO Tipo_NPC (tipo_npc)
        VALUES (v_tipo_npc)
        RETURNING id_npc INTO v_id_npc;

        -- Atribuir o ID gerado ao campo id_npc da tabela específica
        NEW.id_npc := v_id_npc;

        -- Retornar a nova linha para completar a inserção na tabela de destino
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    -- Criar triggers para garantir a integridade referencial em cada tabela
    CREATE TRIGGER trigger_inserir_tipo_npc_ferreiro
    BEFORE INSERT ON Ferreiro
    FOR EACH ROW
    EXECUTE FUNCTION inserir_tipo_npc();

    CREATE TRIGGER trigger_inserir_tipo_npc_mercador
    BEFORE INSERT ON Mercador
    FOR EACH ROW
    EXECUTE FUNCTION inserir_tipo_npc();

    CREATE TRIGGER trigger_inserir_tipo_npc_quest
    BEFORE INSERT ON Quest
    FOR EACH ROW
    EXECUTE FUNCTION inserir_tipo_npc();
    ```

</details>

### Integridade de Itens
O trigger de interidade before_insert_generic e sua função associada são responsáveis por classificar automaticamente os itens inseridos no banco de dados, garantindo que cada um seja corretamente categorizado como craftável ou não-craftável antes da inserção.

<details>

    ```sql

    CREATE OR REPLACE FUNCTION before_insert_generic()
    RETURNS TRIGGER AS $$
    DECLARE
        new_id_item INTEGER;
        table_name TEXT := TG_TABLE_NAME; -- Obtém o nome da tabela
    BEGIN

        IF table_name = 'livro' THEN
            INSERT INTO tipo_item (tipo_item)
            VALUES ('nc')  
            RETURNING id_item INTO new_id_item;

            INSERT INTO Nao_Craftavel (id_nao_craftavel, tipo_nao_craftavel)
            VALUES (new_id_item, 'l');
            NEW.id_item := new_id_item;
            
        ELSIF table_name = 'item_missao' THEN
            INSERT INTO tipo_item (tipo_item)
            VALUES ('nc')  
            RETURNING id_item INTO new_id_item;

            INSERT INTO Nao_Craftavel (id_nao_craftavel, tipo_nao_craftavel)
            VALUES (new_id_item, 'i');
            NEW.id_item := new_id_item;

        ELSIF table_name = 'consumivel' THEN
            INSERT INTO tipo_item (tipo_item)
            VALUES ('nc')  
            RETURNING id_item INTO new_id_item;

            INSERT INTO Nao_Craftavel (id_nao_craftavel, tipo_nao_craftavel)
            VALUES (new_id_item, 'c');
            NEW.id_item := new_id_item;
            
        ELSIF table_name = 'armadura' THEN
            INSERT INTO tipo_item (tipo_item)
            VALUES ('c')  
            RETURNING id_item INTO new_id_item;

            INSERT INTO Craftavel (id_craftavel, tipo_craftavel)
            VALUES (new_id_item, 'a');
            NEW.id_armadura := new_id_item;

        ELSIF table_name = 'material' THEN
            INSERT INTO tipo_item (tipo_item)
            VALUES ('c')  
            RETURNING id_item INTO new_id_item;

            INSERT INTO Craftavel (id_craftavel, tipo_craftavel)
            VALUES (new_id_item, 'm');
            NEW.id_material := new_id_item;
            
        END IF;

        

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;



    CREATE TRIGGER before_insert_consumivel_trigger
    BEFORE INSERT ON consumivel
    FOR EACH ROW
    EXECUTE FUNCTION before_insert_generic();

    CREATE TRIGGER before_insert_livro_trigger
    BEFORE INSERT ON livro
    FOR EACH ROW
    EXECUTE FUNCTION before_insert_generic();

    CREATE TRIGGER before_insert_item_missao_trigger
    BEFORE INSERT ON item_missao
    FOR EACH ROW
    EXECUTE FUNCTION before_insert_generic();

    CREATE TRIGGER before_insert_material_trigger
    BEFORE INSERT ON material
    FOR EACH ROW
    EXECUTE FUNCTION before_insert_generic();

    CREATE TRIGGER before_insert_armadura_trigger
    BEFORE INSERT ON armadura
    FOR EACH ROW
    EXECUTE FUNCTION before_insert_generic();

    ```


</details>

### Criar Party
O trigger de trigger_insert_party e sua função associada insert_party_trigger_function são responsáveis por criar automaticamente um registro na tabela Party sempre que um novo jogador (Player) for inserido no banco de dados.

<details>

    ```sql

    CREATE OR REPLACE FUNCTION insert_party_trigger_function()
    RETURNS TRIGGER AS $$
    BEGIN

        INSERT INTO Party (id_player, id_sala) VALUES (NEW.id_player, listar_sala_segura());
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_insert_party
    AFTER INSERT ON Player
    FOR EACH ROW
    EXECUTE FUNCTION insert_party_trigger_function();

    ```

</details>

### Instanciar Player Missao 
O trigger instanciar_player_missao e sua função associada instanciar_player_missao_procedure são responsáveis por associar automaticamente todas as missões disponíveis a um novo jogador assim que ele é inserido no banco de dados.
<details>

    ```sql

    CREATE OR REPLACE FUNCTION instanciar_player_missao_procedure()
    RETURNS TRIGGER AS $$
    DECLARE
        missao RECORD;
    BEGIN

        FOR missao IN SELECT id_missao FROM Missao LOOP
            INSERT INTO Player_missao (id_player, id_missao, status_missao)
            VALUES (NEW.id_player, missao.id_missao, 'ni');
        END LOOP;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER instanciar_player_missao
    AFTER INSERT ON Player
    FOR EACH ROW
    EXECUTE FUNCTION instanciar_player_missao_procedure();

    ```

</details>


### Instanciar Player Missao 2
O trigger instancia_player_missao_new_missoes e sua função associada instanciar_player_missao_new_missao são responsáveis por garantir que toda nova missão adicionada ao banco de dados seja automaticamente associada a todos os jogadores existentes.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION instanciar_player_missao_new_missao()
    RETURNS TRIGGER AS $$
    DECLARE
        player RECORD;
    BEGIN
        FOR player IN SELECT id_player FROM Player LOOP
            INSERT INTO Player_missao (id_player, id_missao, status_missao)
            VALUES (player.id_player, NEW.id_missao, 'ni');
        END LOOP;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER instancia_player_missao_new_missoes
    AFTER INSERT ON Missao
    FOR EACH ROW
    EXECUTE FUNCTION instanciar_player_missao_new_missao();
    ```

</details>

### Criar Inventário
O trigger after_player_insert e sua função associada after_player_insert_function têm a função de criar automaticamente um inventário inicial para cada novo jogador que é criado no jogo.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION after_player_insert_function()
    RETURNS TRIGGER AS $$
    BEGIN

        INSERT INTO inventario (id_player, dinheiro, alma_armadura)
        VALUES (NEW.id_player, 200, 200);
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER after_player_insert
    AFTER INSERT ON player
    FOR EACH ROW
    EXECUTE FUNCTION after_player_insert_function();
    ```

</details>

### Check dinheiro suficiente
O trigger trg_verificar_dinheiro e sua função associada verificar_dinheiro garantem que um jogador não possa ter um saldo negativo de dinheiro no inventário.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION verificar_dinheiro()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.dinheiro < 0 THEN
            RAISE EXCEPTION 'O jogador não pode ter dinheiro negativo.';
        END IF;
        RETURN NEW;
    END $$;

    CREATE TRIGGER trg_verificar_dinheiro
    BEFORE UPDATE ON inventario
    FOR EACH ROW
    EXECUTE FUNCTION verificar_dinheiro();
    ```

</details>

### Subir de nível
Os triggers trigger_subir_de_nivel_player e trigger_subir_de_nivel_instancia_cavaleiro, juntamente com a função subir_de_nivel, são responsáveis por gerenciar automaticamente a progressão de nível tanto do jogador (player) quanto dos cavaleiros (instancia_cavaleiro) quando acumulam experiência suficiente.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION subir_de_nivel()
    RETURNS TRIGGER AS $$
    DECLARE
        xp_prox_nivel INTEGER;
    BEGIN
        LOOP
            SELECT xp_necessaria INTO xp_prox_nivel
            FROM xp_necessaria 
            WHERE nivel = NEW.nivel + 1;

            IF xp_prox_nivel IS NULL OR NEW.xp_atual < xp_prox_nivel THEN
                EXIT;
            END IF;

            NEW.xp_atual := NEW.xp_atual - xp_prox_nivel;
            NEW.nivel := NEW.nivel + 1;
        END LOOP;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_subir_de_nivel_player
    BEFORE UPDATE OF xp_atual ON player
    FOR EACH ROW
    WHEN (OLD.xp_atual <> NEW.xp_atual) 
    EXECUTE FUNCTION subir_de_nivel();

    CREATE TRIGGER trigger_subir_de_nivel_instancia_cavaleiro
    BEFORE UPDATE OF xp_atual ON instancia_cavaleiro
    FOR EACH ROW
    WHEN (OLD.xp_atual <> NEW.xp_atual) 
    EXECUTE FUNCTION subir_de_nivel();
    ```

</details>

### Missão Concluida
O trigger trigger_atualizar_status_missao e sua função associada atualizar_status_missao_ao_drop_item são responsáveis por atualizar automaticamente o status de missões do jogador quando ele conclui uma missão adquirindo o item da missão.

<details>

    ```sql

    CREATE OR REPLACE FUNCTION atualizar_status_missao_ao_drop_item()
    RETURNS TRIGGER AS $$
    DECLARE
        tipo_do_item TEXT;
        missao_id INTEGER;
    BEGIN
        -- Verificar o tipo do item usando a tabela Tipo_item
        SELECT nc.tipo_nao_craftavel INTO tipo_do_item 
        FROM tipo_item ti
        JOIN nao_craftavel nc on  ti.id_item = nc.id_nao_craftavel
        WHERE id_item = NEW.id_item;

        -- Verificar se o tipo do item é "i" (item missao)
        IF tipo_do_item = 'i' THEN
            -- Verifica se o item é necessário para alguma missão
            SELECT id_missao INTO missao_id
            FROM missao
            WHERE item_necessario = NEW.id_item;

            -- Se o item for necessário para uma missão, atualiza o status da missão do jogador
            IF missao_id IS NOT NULL THEN
                UPDATE player_missao
                SET status_missao = 'c'
                WHERE id_player = NEW.id_inventario
                AND id_missao = missao_id
                AND status_missao = 'i'; -- Apenas atualiza se não estiver concluída
            END IF;
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_atualizar_status_missao
    AFTER INSERT ON item_armazenado
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_status_missao_ao_drop_item();
    ```
</details>

### Remove Item do inventario 
O trigger trg_remover_item_se_zero e sua função associada remover_item_se_zero são responsáveis por remover automaticamente um item do inventário do jogador quando sua quantidade chega a zero.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION remover_item_se_zero()
    RETURNS TRIGGER AS $$
    BEGIN
        
        IF NEW.quantidade = 0 THEN
            DELETE FROM item_armazenado
            WHERE id_inventario = NEW.id_inventario
            AND id_item = NEW.id_item;
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_remover_item_se_zero
    AFTER UPDATE OF quantidade
    ON item_armazenado
    FOR EACH ROW
    WHEN (NEW.quantidade = 0) 
    EXECUTE FUNCTION remover_item_se_zero();

    ```

</details>


### Desbloquear Cavaleiro
O trigger trigger_liberar_cavaleiro e sua função associada instanciar_cavaleiro são responsáveis por desbloquear e instanciar automaticamente um cavaleiro para um jogador quando ele conclui uma missão específica que concede um cavaleiro como recompensa.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION instanciar_cavaleiro()
    RETURNS TRIGGER AS $$
    DECLARE
        p_id_cavaleiro INTEGER;
        p_id_player INTEGER := NEW.id_player;
        p_id_party INTEGER := NEW.ID_player; -- Defina a lógica correta para a party, se necessário
        p_id_classe INTEGER;
        p_id_elemento INTEGER;
        p_nome TEXT;
        p_nivel INTEGER;
        p_hp_max INTEGER;
        p_magia_max INTEGER;
        p_velocidade INTEGER;
        p_ataque_fisico INTEGER;
        p_ataque_magico INTEGER;
    BEGIN
        -- Obtém o cavaleiro desbloqueado pela missão concluída
        SELECT m.id_cavaleiro_desbloqueado
        INTO p_id_cavaleiro
        FROM missao m
        WHERE m.id_missao = NEW.id_missao;
        
        -- Se não houver cavaleiro a ser desbloqueado, não faz nada
        IF p_id_cavaleiro IS NULL THEN
            RETURN NEW;
        END IF;

        -- Obtém as informações do cavaleiro
        SELECT c.id_classe, c.id_elemento, c.nome, c.nivel, c.hp_max, c.magia_max, 
            c.velocidade, c.ataque_fisico, c.ataque_magico
        INTO p_id_classe, p_id_elemento, p_nome, p_nivel, p_hp_max, p_magia_max, 
            p_velocidade, p_ataque_fisico, p_ataque_magico
        FROM cavaleiro c
        WHERE c.id_cavaleiro = p_id_cavaleiro;

        -- Verifica se o jogador já tem este cavaleiro para evitar duplicatas
        IF NOT EXISTS (
            SELECT 1 FROM instancia_cavaleiro 
            WHERE id_player = p_id_player AND id_cavaleiro = p_id_cavaleiro
        ) THEN
            -- Insere o cavaleiro na instância do jogador
            INSERT INTO instancia_cavaleiro (
                id_cavaleiro, id_player, nivel, tipo_armadura, xp_atual, 
                hp_max, magia_max, hp_atual, magia_atual, velocidade, 
                ataque_fisico, ataque_magico
            ) VALUES (
                p_id_cavaleiro, p_id_player, p_nivel, 0, 0, 
                p_hp_max, p_magia_max, p_hp_max, p_magia_max, p_velocidade, 
                p_ataque_fisico, p_ataque_magico
            );
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_liberar_cavaleiro
    AFTER UPDATE ON player_missao
    FOR EACH ROW
    WHEN (NEW.status_missao = 'c' AND old.status_missao != 'c')
    EXECUTE FUNCTION instanciar_cavaleiro();
    ```
</details>

### Mover de Sala ao Morrer
O trigger trigger_player_morreu e sua função associada mover_sala_segura_pos_morte são responsáveis por mover automaticamente o jogador para uma sala segura ao ser derrotado, reduzindo seu dinheiro como penalidade e restaurando parcialmente sua vida.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION mover_sala_segura_pos_morte()
    RETURNS TRIGGER AS $$
    BEGIN

        UPDATE inventario
        SET dinheiro = dinheiro / 2
        WHERE inventario.id_player = OLD.id_player;

        RAISE NOTICE '% foi derrotado, Saori Kido o resgata mas com um custo...', OLD.nome;


        UPDATE party
        SET id_sala = (SELECT id_sala FROM public.sala_segura LIMIT 1)  -- Usar parênteses no SELECT
        WHERE party.id_player = NEW.id_player;

        NEW.hp_atual := NEW.hp_max / 2;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER trigger_player_morreu
    BEFORE UPDATE ON player
    FOR EACH ROW
    WHEN (NEW.hp_atual <= 0) 
    EXECUTE FUNCTION mover_sala_segura_pos_morte();
    ```

</details>

### Verificar Slot Único
O trigger impedir_slots_repetidos e sua função associada verificar_slots_unicos garantem que um jogador não possa atribuir duas habilidades ao mesmo slot na tabela Habilidade_Player.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION verificar_slots_unicos() 
    RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM Habilidade_Player
            WHERE id_player = NEW.id_player 
            AND slot = NEW.slot
        ) THEN
            RAISE EXCEPTION '❌ Esse slot já está ocupado! Escolha outro.';
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER impedir_slots_repetidos
    BEFORE INSERT OR UPDATE ON Habilidade_Player
    FOR EACH ROW
    EXECUTE FUNCTION verificar_slots_unicos();
    ```

</details>

### Remover cavaleiro da party
O trigger trigger_remover_cavaleiro_party e sua função associada remover_cavaleiro_da_party são responsáveis por remover automaticamente um cavaleiro da party do jogador quando seu HP chega a 0.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION remover_cavaleiro_da_party()
    RETURNS TRIGGER AS $$
    BEGIN
        
        IF NEW.hp_atual <= 0 AND OLD.hp_atual > 0 AND OLD.id_party IS NOT NULL THEN
            
            UPDATE instancia_cavaleiro 
            SET id_party = NULL
            WHERE id_cavaleiro = NEW.id_cavaleiro AND id_player = NEW.id_player;

            
            RAISE NOTICE 'O cavaleiro % foi removido da party do player % porque seu HP chegou a 0.', NEW.id_cavaleiro, NEW.id_player;
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_remover_cavaleiro_party
    BEFORE UPDATE OF hp_atual
    ON public.instancia_cavaleiro
    FOR EACH ROW
    EXECUTE FUNCTION remover_cavaleiro_da_party();
    ```

</details>

### Remover livro apos aprender habilidade
Os triggers trigger_reduzir_item_habilidade_player e trigger_reduzir_item_habilidade_cavaleiro, juntamente com a função reduzir_item_armazenado, são responsáveis por remover automaticamente um livro do inventário do jogador quando uma habilidade é aprendida.

<details>

    ```sql
    CREATE OR REPLACE FUNCTION reduzir_item_armazenado()
    RETURNS TRIGGER AS $$
    DECLARE
        id_livro INT;
        player_id INT;
    BEGIN
        -- Obtém o ID do livro relacionado à habilidade aprendida
        SELECT id_item INTO id_livro 
        FROM livro 
        WHERE id_habilidade = NEW.id_habilidade;

        -- Obtém o ID do player (caso seja um cavaleiro, pegamos do cavaleiro correspondente)
        IF TG_TABLE_NAME = 'habilidade_player' THEN
            player_id := NEW.id_player;
        ELSIF TG_TABLE_NAME = 'habilidade_cavaleiro' THEN
            SELECT id_player INTO player_id
            FROM instancia_cavaleiro
            WHERE id_cavaleiro = NEW.id_cavaleiro;
        END IF;

        -- Atualiza a quantidade do item no inventário do jogador
        UPDATE item_armazenado
        SET quantidade = quantidade - 1
        WHERE id_inventario = player_id
        AND id_item = id_livro;

        -- Remove o item do inventário se a quantidade for 0
        DELETE FROM item_armazenado
        WHERE id_inventario= player_id
        AND id_item = id_livro
        AND quantidade <= 0;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;



    CREATE TRIGGER trigger_reduzir_item_habilidade_player
    AFTER INSERT ON habilidade_player
    FOR EACH ROW
    EXECUTE FUNCTION reduzir_item_armazenado();


    CREATE TRIGGER trigger_reduzir_item_habilidade_cavaleiro
    AFTER INSERT ON habilidade_cavaleiro
    FOR EACH ROW
    EXECUTE FUNCTION reduzir_item_armazenado();
    ```

</details>


## Triggers não utilizados
Abaixo se encontram triggers que não foram utilizadas quanto ao controle de integralidade pois faltou refatoramento:

<details>

```sql
    CREATE OR REPLACE FUNCTION enforce_tipo_item_exclusivo()
    RETURNS TRIGGER AS $$
    DECLARE
        v_id_item INT;
        total_subclasses INT;
    BEGIN
        CASE TG_TABLE_NAME
            WHEN 'material' THEN v_id_item := NEW.id_material;
            WHEN 'armadura' THEN v_id_item := NEW.id_armadura;
            WHEN 'item_missao' THEN v_id_item := NEW.id_item;
            WHEN 'consumivel' THEN v_id_item := NEW.id_item;
            WHEN 'livro' THEN v_id_item := NEW.id_item;
            ELSE 
                RAISE EXCEPTION 'Trigger chamada em uma tabela desconhecida!';
        END CASE;

        SELECT COUNT(*) INTO total_subclasses FROM (
            SELECT id_material FROM material WHERE id_material = v_id_item
            UNION ALL
            SELECT id_armadura FROM armadura WHERE id_armadura = v_id_item
            UNION ALL
            SELECT id_item FROM item_missao WHERE id_item = v_id_item
            UNION ALL
            SELECT id_item FROM consumivel WHERE id_item = v_id_item
            UNION ALL
            SELECT id_item FROM livro WHERE id_item = v_id_item
        ) AS sub_tabelas;

        IF total_subclasses > 1 THEN
            RAISE EXCEPTION 'O item deve pertencer a apenas uma subclasse!';
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER check_tipo_item_exclusivo_material
    BEFORE INSERT OR UPDATE ON material
    FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    CREATE TRIGGER check_tipo_item_exclusivo_armadura
    BEFORE INSERT OR UPDATE ON armadura
    FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    CREATE TRIGGER check_tipo_item_exclusivo_item_missao
    BEFORE INSERT OR UPDATE ON item_missao
    FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    CREATE TRIGGER check_tipo_item_exclusivo_consumivel
    BEFORE INSERT OR UPDATE ON consumivel
    FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    CREATE TRIGGER check_tipo_item_exclusivo_livro
    BEFORE INSERT OR UPDATE ON livro
    FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();


```

</details>

## Resumo dos Triggers

### Utilizados

| Trigger                                       | Tabela Afetada        | Evento          | Função                                                                        |
| --------------------------------------------- | --------------------- | --------------- | ----------------------------------------------------------------------------- |
| `trigger_gerar_partes_corpo_boss`             | `boss`                | `AFTER INSERT`  | Cria automaticamente as partes do corpo do boss ao ser inserido.              |
| `trigger_gerar_partes_corpo_cavaleiro`        | `instancia_cavaleiro` | `AFTER INSERT`  | Gera automaticamente as partes do corpo dos cavaleiros ao serem instanciados. |
| `trigger_gerar_partes_corpo_player`           | `player`              | `AFTER INSERT`  | Cria automaticamente as partes do corpo do jogador ao ser inserido.           |
| `trigger_gerar_partes_corpo_inimigo`          | `instancia_inimigo`   | `AFTER INSERT`  | Gera automaticamente as partes do corpo dos inimigos ao serem instanciados.   |
| `trigger_inserir_tipo_personagem_player`      | `player`              | `BEFORE INSERT` | Registra automaticamente o tipo de personagem ao inserir um novo jogador.     |
| `trigger_inserir_tipo_personagem_cavaleiro`   | `cavaleiro`           | `BEFORE INSERT` | Registra automaticamente o tipo de personagem ao inserir um novo cavaleiro.   |
| `trigger_inserir_tipo_personagem_inimigo`     | `inimigo`             | `BEFORE INSERT` | Registra automaticamente o tipo de personagem ao inserir um novo inimigo.     |
| `trigger_inserir_tipo_personagem_boss`        | `boss`                | `BEFORE INSERT` | Registra automaticamente o tipo de personagem ao inserir um novo boss.        |
| `trigger_inserir_tipo_npc_ferreiro`           | `ferreiro`            | `BEFORE INSERT` | Registra automaticamente o tipo do NPC ao inserir um ferreiro.                |
| `trigger_inserir_tipo_npc_mercador`           | `mercador`            | `BEFORE INSERT` | Registra automaticamente o tipo do NPC ao inserir um mercador.                |
| `trigger_inserir_tipo_npc_quest`              | `quest`               | `BEFORE INSERT` | Registra automaticamente o tipo do NPC ao inserir um NPC de missão.           |
| `trigger_before_insert_consumivel`            | `consumivel`          | `BEFORE INSERT` | Classifica automaticamente o item como não-craftável antes da inserção.       |
| `trigger_before_insert_livro`                 | `livro`               | `BEFORE INSERT` | Classifica automaticamente o item como não-craftável antes da inserção.       |
| `trigger_before_insert_item_missao`           | `item_missao`         | `BEFORE INSERT` | Classifica automaticamente o item como não-craftável antes da inserção.       |
| `trigger_before_insert_material`              | `material`            | `BEFORE INSERT` | Classifica automaticamente o item como craftável antes da inserção.           |
| `trigger_before_insert_armadura`              | `armadura`            | `BEFORE INSERT` | Classifica automaticamente o item como craftável antes da inserção.           |
| `trigger_insert_party`                        | `player`              | `AFTER INSERT`  | Cria automaticamente uma party para o jogador ao ser inserido.                |
| `trigger_instanciar_player_missao`            | `player`              | `AFTER INSERT`  | Associa todas as missões ao jogador quando ele é criado.                      |
| `trigger_instanciar_player_missao_new_missao` | `missao`              | `AFTER INSERT`  | Associa uma nova missão a todos os jogadores existentes.                      |
| `trigger_after_player_insert`                 | `player`              | `AFTER INSERT`  | Cria automaticamente um inventário inicial para o jogador.                    |
| `trigger_verificar_dinheiro`                  | `inventario`          | `BEFORE UPDATE` | Impede que o jogador tenha dinheiro negativo.                                 |
| `trigger_subir_de_nivel_player`               | `player`              | `BEFORE UPDATE` | Gerencia a progressão de nível do jogador com base no XP acumulado.           |
| `trigger_subir_de_nivel_instancia_cavaleiro`  | `instancia_cavaleiro` | `BEFORE UPDATE` | Gerencia a progressão de nível dos cavaleiros com base no XP acumulado.       |
| `trigger_atualizar_status_missao`             | `item_armazenado`     | `AFTER INSERT`  | Atualiza automaticamente o status da missão ao coletar um item necessário.    |
| `trigger_remover_item_se_zero`                | `item_armazenado`     | `AFTER UPDATE`  | Remove um item do inventário se sua quantidade chegar a zero.                 |
| `trigger_liberar_cavaleiro`                   | `player_missao`       | `AFTER UPDATE`  | Adiciona um cavaleiro ao jogador ao completar uma missão específica.          |
| `trigger_player_morreu`                       | `player`              | `BEFORE UPDATE` | Move o jogador para uma sala segura e reduz seu dinheiro ao morrer.           |
| `impedir_slots_repetidos`                     | `habilidade_player`   | `BEFORE INSERT/UPDATE` | Impede que o jogador atribua duas habilidades ao mesmo slot.           |
| `trigger_remover_cavaleiro_party`             | `instancia_cavaleiro` | `BEFORE UPDATE` | Remove um cavaleiro da party se seu HP chegar a zero.                         |
| `trigger_reduzir_item_habilidade_player`      | `habilidade_player`   | `AFTER INSERT`  | Reduz a quantidade do livro de habilidade no inventário ao aprender uma nova. |
| `trigger_reduzir_item_habilidade_cavaleiro`   | `habilidade_cavaleiro`| `AFTER INSERT`  | Reduz a quantidade do livro de habilidade ao ensinar uma a um cavaleiro.      |


### Triggers não utilizados

| Trigger                                      | Tabela Afetada   | Evento                 | Função                                                             |
| -------------------------------------------- | ---------------- | ---------------------- | ------------------------------------------------------------------ |
| `check_tipo_item_exclusivo_material`        | `material`       | `BEFORE INSERT/UPDATE` | Impede que um item pertença a mais de uma categoria de tipo de item. |
| `check_tipo_item_exclusivo_armadura`        | `armadura`       | `BEFORE INSERT/UPDATE` | Impede que um item pertença a mais de uma categoria de tipo de item. |
| `check_tipo_item_exclusivo_item_missao`     | `item_missao`    | `BEFORE INSERT/UPDATE` | Impede que um item pertença a mais de uma categoria de tipo de item. |
| `check_tipo_item_exclusivo_consumivel`      | `consumivel`     | `BEFORE INSERT/UPDATE` | Impede que um item pertença a mais de uma categoria de tipo de item. |
| `check_tipo_item_exclusivo_livro`           | `livro`          | `BEFORE INSERT/UPDATE` | Impede que um item pertença a mais de uma categoria de tipo de item. |


## Referência Bibliográfica

> [1] ELMASRI, Ramez; NAVATHE, Shamkant B. Sistemas de banco de dados. Tradução: Daniel Vieira. Revisão técnica: Enzo Seraphim; Thatyana de Faria Piola Seraphim. 6. ed. São Paulo: Pearson Addison Wesley, 2011. Capítulo 26. Modelos de dados avançados para aplicações avançada, página 626.

> [2] SILBERSCHATZ, Abraham; KORTH, Henry F.; SUDARSHAN, S. Database system concepts. 6. ed. New York: McGraw-Hill, 2011. Capítulo 5 Advanced SQL, tópico 5.3 Triggers, página 180

## Bibliografia
> Triggers e Stored Procedure Prison Trading. Disponível em: https://sbd1.github.io/2024.1-Prison-Trading/#/Modulo-3/Triggers Acesso em 13 de fevereiro de 2025.

> Triggers e Stored Procedure Ben 10. Disponível em: https://sbd1.github.io/2024.1-Ben10/modulo3/triggers/ Acesso em 13 de fevereiro de 2025.

## Historico de Versões

| Versão | Data       | Modificação                                              | Autor                                       |
| ------ | ---------- | -------------------------------------------------------- | ------------------------------------------- |
| 0.1    | 02/02/2025 | Criação do Documento                                     | Vinícius Rufino                             |
| 1.0    | 03/02/2025 | Atualização dos Triggers                                 | Vinícius Rufino                             |
| 1.1    | 10/02/2025 | Atualização dos Triggers e Adição da Toggle List         | Vinícius Rufino                             |
| 2.0    | 13/02/2025 | Atualização e refatoração do documento para versão final | [Pedro Lucas](https://github.com/lucasdray) |