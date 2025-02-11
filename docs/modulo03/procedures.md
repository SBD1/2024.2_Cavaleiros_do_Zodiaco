## Stored Procedures

Uma Stored Procedure é um bloco de código SQL armazenado no banco de dados, que pode ser executado várias vezes sem precisar ser reescrito. As procedures permitem realizar operações mais complexas, como manipulação de dados e lógica de negócios, aceitando parâmetros de entrada e podendo modificar dados do banco.

### Get Saga Atual

Obtém a saga atual em que o jogador se encontra.

<details>
    <sumary>Migrações</sumary>

    ```sql
    CREATE OR REPLACE PROCEDURE get_saga_atual(IN p_id_player INT, INOUT cur REFCURSOR)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        OPEN cur FOR
            SELECT c.id_saga, sa.nome 
            FROM Party as p
            JOIN Sala AS s ON p.id_sala = s.id_sala
            JOIN Casa as c ON c.id_casa = s.id_casa
            JOIN Saga as sa ON sa.id_saga = c.id_saga
            WHERE p.id_player = p_id_player;
    END;
    $$;

    ```
</details>

### Get Grupo Cursos

Obtém o grupo do jogador.

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

### Trocar Cavaleiro da Party

Substitui um cavaleiro da party do jogador por um novo.

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
        FROM instancia_cavaleiro 
        WHERE id_party = id_sala_var;

        IF total_cavaleiros >= 3 THEN
            IF NOT EXISTS (SELECT 1 FROM instancia_cavaleiro WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido) THEN
                RAISE EXCEPTION 'O cavaleiro escolhido para remoção não está na party.';
            END IF;

            UPDATE instancia_cavaleiro 
            SET id_party = NULL 
            WHERE id_party = id_sala_var AND id_cavaleiro = p_id_cavaleiro_removido;
        END IF;

        INSERT INTO instancia_cavaleiro (id_player, id_cavaleiro, id_party, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico)
        SELECT 
            p_id_player, p_id_cavaleiro_novo, id_sala_var, nivel, 0, hp_max, magia_max, hp_max, magia_max, velocidade_base, ataque_fisico_base, ataque_magico_base
        FROM cavaleiro
        WHERE id_cavaleiro = p_id_cavaleiro_novo;
    END;
    $$;
    ```
</details>

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 10/02/2025 | Criação do Documento | Vinícius Rufino |