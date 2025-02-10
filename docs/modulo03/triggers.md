## Triggers



### Atualizar Status da Missão

Atualiza o status de uma missão quando um item de missão é adicionado ao inventário.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION atualizar_status_missao_ao_drop_item()
    RETURNS TRIGGER AS $$
    DECLARE
        tipo_do_item TEXT;
        missao_id INTEGER;
    BEGIN
        SELECT tipo_item INTO tipo_do_item 
        FROM tipo_item
        WHERE id_item = NEW.id_item;

        IF tipo_do_item = 'i' THEN
            SELECT id_missao INTO missao_id
            FROM missao
            WHERE item_necessario = NEW.id_item;

            IF missao_id IS NOT NULL THEN
                UPDATE player_missao
                SET status_missao = 'c'
                WHERE id_player = NEW.id_inventario
                AND id_missao = missao_id
                AND status_missao = 'i';
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

### Remover um Item se Zero

Remove automaticamente um item do inventário se a quantidade for reduzida a zero.

<details>
    <sumary>Migrações</sumary>

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

### Reviver Inimigos

Revive inimigos em uma sala quando um jogador entra nela.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION reviver_inimigos_sala()
    RETURNS TRIGGER AS $$
    BEGIN
        UPDATE instancia_inimigo ii
        SET hp_atual = i.hp_max
        FROM inimigo i
        WHERE ii.id_inimigo = i.id_inimigo
        AND ii.id_grupo IN (
            SELECT gi.id_grupo
            FROM grupo_inimigo gi
            WHERE gi.id_sala = NEW.id_sala
        )
        AND ii.hp_atual = 0;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_reviver_inimigos
    AFTER UPDATE OF id_sala ON party
    FOR EACH ROW
    EXECUTE FUNCTION reviver_inimigos_sala();
    ```
</details>

### Libertar Cavaleiro

Instancia um novo cavaleiro para o jogador quando ele completa uma missão específica.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION instanciar_cavaleiro()
    RETURNS TRIGGER AS $$
    DECLARE
        p_id_cavaleiro INTEGER;
        p_id_player INTEGER := NEW.id_player;
    BEGIN
        SELECT id_cavaleiro_desbloqueado INTO p_id_cavaleiro
        FROM missao
        WHERE id_missao = NEW.id_missao;

        IF p_id_cavaleiro IS NOT NULL THEN
            INSERT INTO instancia_cavaleiro (
                id_cavaleiro, id_player, id_party, nivel, tipo_armadura, xp_atual, 
                hp_max, magia_max, hp_atual, magia_atual, velocidade, 
                ataque_fisico, ataque_magico
            ) VALUES (
                p_id_cavaleiro, p_id_player, p_id_player, 1, 0, 0, 
                100, 50, 100, 50, 10, 
                20, 30
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

### Player Morreu

Move um jogador para um local seguro e reduz seu dinheiro pela metade ao morrer.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION mover_sala_segura_pos_morte()
    RETURNS TRIGGER AS $$  
    BEGIN  
        UPDATE inventario  
        SET dinheiro = dinheiro / 2  
        WHERE inventario.id_player = OLD.id_player;  

        RAISE NOTICE '% foi derrotado, Saori Kido o resgata mas com um custo.', OLD.id_player;  

        UPDATE party  
        SET id_sala = (SELECT id_sala FROM public.sala_segura LIMIT 1)  
        WHERE party.id_player = OLD.id_player;  

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

### Gerar Partes do Corpo do Cavaleiro

Garante que um cavaleiro instanciado tenha suas partes do corpo registradas corretamente.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION gerar_partes_corpo_cavaleiro()
    RETURNS TRIGGER AS $$  
    BEGIN  
        INSERT INTO public.parte_corpo_cavaleiro (  
            id_cavaleiro,   
            parte_corpo,    
            id_player,   
            defesa_fisica_bonus,   
            defesa_magico_bonus,   
            chance_acerto_base,   
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

### Subir de Nível

Verifica se um jogador ou cavaleiro atingiu experiência suficiente para subir de nível.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION subir_de_nivel()
    RETURNS TRIGGER AS $$  
    DECLARE  
        nivel_atual INTEGER;  
        xp_atual INTEGER;  
    BEGIN  
        nivel_atual := OLD.nivel;  
        xp_atual := OLD.xp_atual;  

        IF xp_atual >= (SELECT xp_necessaria FROM xp_necessaria WHERE nivel = nivel_atual + 1) THEN  
            NEW.xp_atual := xp_atual - xp_necessaria;  
            NEW.nivel := nivel_atual + 1;  
        END IF;  

        RETURN NEW;  
    END;  
    $$ LANGUAGE plpgsql;  

    CREATE TRIGGER trigger_subir_de_nivel_player  
    BEFORE UPDATE OF xp_atual ON Player  
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

### Resumo dos Triggers

| Trigger                                | Tabela Afetada            | Evento         | Função                                                                 |
|----------------------------------------|---------------------------|----------------|------------------------------------------------------------------------|
| `trigger_atualizar_status_missao`      | `item_armazenado`         | `AFTER INSERT` | Atualiza o status de uma missão quando um item de missão é armazenado. |
| `trg_remover_item_se_zero`             | `item_armazenado`         | `AFTER UPDATE` | Remove um item do inventário se a quantidade chegar a zero.            |
| `trigger_reviver_inimigos`             | `party`                   | `AFTER UPDATE` | Revive inimigos na sala quando um jogador entra nela.                  |
| `trigger_liberar_cavaleiro`            | `player_missao`           | `AFTER UPDATE` | Adiciona um cavaleiro ao jogador ao completar uma missão específica.   |
| `trigger_player_morreu`                | `player`                  | `BEFORE UPDATE`| Move o jogador para um local seguro e reduz seu dinheiro ao morrer.    |
| `trigger_gerar_partes_corpo_cavaleiro`  | `instancia_cavaleiro`      | `AFTER INSERT` | Garante que um cavaleiro instanciado tenha suas partes do corpo registradas. |
| `trigger_subir_de_nivel_player`        | `player`                  | `BEFORE UPDATE`| Atualiza o nível do jogador ao atingir experiência suficiente.         |
| `trigger_subir_de_nivel_instancia_cavaleiro` | `instancia_cavaleiro` | `BEFORE UPDATE` | Atualiza o nível do cavaleiro instanciado ao atingir experiência suficiente. |
      |

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 02/02/2025 | Criação do Documento | Vinícius Rufino |
| 1.0 | 03/02/2025 | Atualização dos Triggers | Vinícius Rufino |
| 1.1 | 10/02/2025 | Atualização dos Triggers e Adição da Toggle List | Vinícius Rufino |