## Função

Uma Função (Function) em SQL é um bloco reutilizável de código que retorna um único valor ou conjunto de valores. Diferente das procedures, as funções são usadas dentro de consultas SQL e não podem modificar dados diretamente (ou seja, não podem executar INSERT, UPDATE ou DELETE).

### Get ID Sala Atual

Obtém a sala em que o jogador está atualmente.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION get_id_sala_atual(id_player_input INT)
    RETURNS INT AS $$
    DECLARE
        v_id_sala INT;
    BEGIN
        SELECT s.id_sala INTO v_id_sala
        FROM sala s
        INNER JOIN party p ON s.id_sala = p.id_sala
        WHERE p.id_player = id_player_input
        LIMIT 1;  

        RETURN v_id_sala;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### Player Tem Inimigos

Verifica se há inimigos na sala onde o jogador está.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION player_tem_inimigos(id_player_input INT)
    RETURNS BOOLEAN AS $$
    DECLARE
        v_id_sala INT;
        v_tem_inimigos BOOLEAN;
    BEGIN
        v_id_sala := get_id_sala_atual(id_player_input);

        IF v_id_sala IS NULL THEN
            RETURN FALSE;
        END IF;

        v_tem_inimigos := sala_tem_inimigos(v_id_sala);

        RETURN v_tem_inimigos;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### Get Player Info

Retorna as informações do jogador formatadas em um texto.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION public.get_player_info(player_id integer)
    RETURNS text
    LANGUAGE plpgsql
    AS $function$
    BEGIN
        RETURN (
            SELECT STRING_AGG(
                FORMAT(
                    'Nome: %s Nível: %s XP: %s HP: %s/%s Magia: %s/%s Velocidade: %s Ataque Físico: %s Ataque Mágico: %s Elemento: %s',
                    p.nome, p.nivel, p.xp_atual, p.hp_atual, p.hp_max, p.magia_atual, p.magia_max, p.velocidade, 
                    p.ataque_fisico_base, p.ataque_magico_base, e.nome
                ),
                E'\n'
            )
            FROM player p
            INNER JOIN elemento e ON e.id_elemento = p.id_elemento
            WHERE p.id_player = player_id
        );
    END;
    $function$;
    ```
</details>

### Listar Sagas

Retorna todas as sagas disponíveis para um jogador.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE FUNCTION listar_sagas(player_id INT)
    RETURNS TABLE (
        id_saga INT,
        nome_saga TEXT
    ) AS $$  
    DECLARE
        player_exists INT;
    BEGIN
        SELECT COUNT(*) INTO player_exists FROM player WHERE id_player = player_id;
        IF player_exists = 0 THEN
            RAISE EXCEPTION 'O jogador com ID % não existe.', player_id;
        END IF;

        RETURN QUERY
        SELECT s.id_saga, s.nome FROM Saga s;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### Gerar Partes Corpo Cavaleiro

Insere automaticamente as partes do corpo para um novo cavaleiro associado ao jogador, com atributos iniciais.

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
    ```
</details>

### Gerar Partes Corpo Player

Gera automaticamente as partes do corpo para um novo jogador com slots vazios para armaduras.

<details>
    <sumary>Migrações</sumary>

    ```sql
   CREATE OR REPLACE FUNCTION gerar_partes_corpo_player()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.parte_corpo_player (
            id_player, 
            parte_corpo, 
            armadura_equipada, 
            instancia_armadura_equipada
        )
        SELECT 
            NEW.id_player,   
            pc.id_parte_corpo, 
            NULL,             
            NULL              
        FROM public.parte_corpo pc;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### Gerar Partes Corpo Inimigo

Gera automaticamente as partes do corpo para um inimigo recém-criado, com base em atributos gerais.

<details>
    <sumary>Migrações</sumary>

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
            chance_acerto_base, 
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
    ```
</details>

### Insert Party Trigger Function

Insere uma nova party associada a uma sala segura quando um jogador é criado.

<details>
    <sumary>Migrações</sumary>

    ```sql
   CREATE OR REPLACE FUNCTION insert_party_trigger_function()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Party (id_player, id_sala) 
        VALUES (NEW.id_player, listar_sala_segura());
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### Instanciar Player Missão Procedure

Cria instâncias de missões para um jogador recém-criado.

<details>
    <sumary>Migrações</sumary>

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
    ```
</details>

### Instaciar Player Missão New Missão

Gera novas instâncias de missões para todos os jogadores quando uma nova missão é criada.

<details>
    <sumary>Migrações</sumary>

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
    ```
</details>

### After Player Insert Function

Cria um inventário com dinheiro inicial quando um novo jogador é criado.

<details>
    <sumary>Migrações</sumary>

    ```sql
   CREATE OR REPLACE FUNCTION after_player_insert_function()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO inventario (id_player, dinheiro)
        VALUES (NEW.id_player, 200);
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### Verificar Dinheiro

Previne que o dinheiro de um jogador seja negativo.

<details>
    <sumary>Migrações</sumary>

    ```sql
   CREATE OR REPLACE FUNCTION verificar_dinheiro()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.dinheiro < 0 THEN
            RAISE EXCEPTION 'O jogador não pode ter dinheiro negativo.';
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 0/02/2025 | Criação do Documento | Vinícius Rufino |