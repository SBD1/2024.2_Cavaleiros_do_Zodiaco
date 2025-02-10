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

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 0/02/2025 | Criação do Documento | Vinícius Rufino |