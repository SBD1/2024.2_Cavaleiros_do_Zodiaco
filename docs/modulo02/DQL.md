## Data Query Language (DQL)

### Introdução

De acordo com Elmasri e Navathe (2011), DQL (Data Query Language) é um subconjunto da SQL utilizado para realizar consultas e recuperar dados armazenados em um banco de dados relacional. Ele permite a interação com os dados sem a necessidade de realizar alterações estruturais ou manipulações diretas nas tabelas. O principal comando do DQL é o SELECT, que possibilita a obtenção de informações filtradas e organizadas de maneira eficiente.

### Objetivos

O DQL tem como objetivo principal permitir a recuperação eficiente de dados, a filtragem e organização das informações, a consulta a múltiplas tabelas, o fácil acesso aos dados e o suporte à tomada de decisões sem a necessidade de modificar a estrutura do banco de dados.

### V30_parte_corpo

O objetivo desta migração é automatizar a criação das partes do corpo dos diferentes personagens do jogo (bosses, cavaleiros, jogadores e inimigos) ao serem inseridos no sistema. Isso garante que cada entidade tenha suas respectivas estatísticas atribuídas corretamente, mantendo a integridade e equilíbrio do jogo.

<details>
    <sumary> Migrações </sumary>

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

### V35_func_listar_sala_segura

Esta versão busca facilitar a localização de um local seguro no jogo, permitindo que os jogadores possam encontrar refúgios estrategicamente. Isso é essencial para a mecânica de regeneração e planejamento de estratégias durante o jogo.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION listar_sala_segura()
    RETURNS INT AS $$
    DECLARE
        sala_segura_id INT;
    BEGIN
        SELECT id_sala INTO sala_segura_id FROM Sala_Segura
        LIMIT 1;

    RETURN sala_segura_id;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V40_setup_inicial

Aqui, foram implementadas funções para definir e modificar a sala inicial de um jogador no jogo. Isso possibilita a criação de um ponto de partida adequado e a movimentação controlada dos personagens no ambiente virtual.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION setar_sala_inicial(id_player_input INT)
    RETURNS VOID AS $$
    DECLARE
        sala_inicial_id INT;
        existe_na_party BOOLEAN;
    BEGIN
        -- Recupera o menor id_sala da tabela sala
        SELECT id_sala FROM public.sala_inicial;

        -- Verifica se existe uma sala
        IF sala_inicial_id IS NOT NULL THEN


            -- Verifica se o player já está na party
            SELECT EXISTS(
                SELECT 1 FROM public.party WHERE id_player = id_player_input
            ) INTO existe_na_party;

            -- Se já existir, apenas atualiza a sala
            IF existe_na_party THEN
                UPDATE public.party
                SET id_sala = sala_inicial_id
                WHERE id_player = id_player_input;
            ELSE
                -- Caso contrário, insere um novo registro na party
                INSERT INTO public.party (id_player, id_sala)
                VALUES (id_player_input, sala_inicial_id);
            END IF;
        ELSE
            RAISE EXCEPTION 'Nenhuma sala encontrada na tabela sala.';
        END IF;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION setar_nova_sala(id_player_input INT, id_sala_input INT)
    RETURNS VOID AS $$
    BEGIN
        -- Verifica se a sala existe
        IF EXISTS (SELECT 1 FROM public.sala WHERE id_sala = id_sala_input) THEN
            -- Atualiza o id_sala na tabela party para o jogador
            UPDATE public.party
            SET id_sala = id_sala_input
            WHERE id_player = id_player_input;

            -- Verifica se o jogador já está na tabela party, caso contrário, insere
            IF NOT FOUND THEN
                INSERT INTO public.party (id_player, id_sala)
                VALUES (id_player_input, id_sala_input);
            END IF;
        ELSE
            RAISE EXCEPTION 'Sala com id_sala % não encontrada.', id_sala_input;
        END IF;
    END;
    $$ LANGUAGE plpgsql;



    CREATE OR REPLACE FUNCTION get_salas_conectadas(id_player_input INT)
    RETURNS TABLE(id_sala INT, nome VARCHAR, direcao VARCHAR) AS $$
    BEGIN
        RETURN QUERY
        WITH salas_conectadas AS (
            SELECT s.id_sala_norte AS id_sala, CAST('Norte' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_norte IS NOT NULL
            UNION ALL
            SELECT s.id_sala_sul AS id_sala, CAST('Sul' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_sul IS NOT NULL
            UNION ALL
            SELECT s.id_sala_leste AS id_sala, CAST('Leste' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_leste IS NOT NULL
            UNION ALL
            SELECT s.id_sala_oeste AS id_sala, CAST('Oeste' AS VARCHAR) AS direcao FROM public.sala s WHERE s.id_sala = (
                SELECT p.id_sala FROM public.party p WHERE p.id_player = id_player_input LIMIT 1
            ) AND s.id_sala_oeste IS NOT NULL
        )
        SELECT sc.id_sala, s.nome, sc.direcao
        FROM salas_conectadas sc
        JOIN public.sala s ON sc.id_sala = s.id_sala;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION public.get_player_info(player_id integer)
    RETURNS text
    LANGUAGE plpgsql
    AS $function$
    BEGIN
        RETURN (
            SELECT STRING_AGG(
                FORMAT(
                    'Nome: %s %sNível: %s%sXP Acumulado: %s%sHP Máximo: %s%sMagia Máxima: %s%sHP Atual: %s%sMagia Atual: %s%sVelocidade: %s%sAtaque Físico : %s%sAtaque Mágico : %s%sElemento: %s',
                    p.nome, E'\n',
                    p.nivel, E'\n',
                    p.atual, E'\n',
                    p.hp_max, E'\n',
                    p.magia_max, E'\n',
                    p.hp_atual, E'\n',
                    p.magia_atual, E'\n',
                    p.velocidade, E'\n',
                    p.ataque_fisico, E'\n',
                    p.ataque_magico, E'\n',
                    e.nome
                ),
                E'\n'  -- Delimitador entre os registros (caso haja mais de um)
            )
            FROM player p
            INNER JOIN elemento e ON e.id_elemento = p.id_elemento
            WHERE p.id_player = player_id
        );
    END;
    $function$;


    CREATE OR REPLACE FUNCTION listar_jogadores_formatados()
    RETURNS TEXT AS $$
    BEGIN
        RETURN (
            SELECT STRING_AGG(
                FORMAT(
                    'Nome: %s Nível: %s Elemento: %s ',
                    p.nome,
                    p.nivel,
                    e.nome
                ),
                E'\n'  -- Delimitador entre as entradas
            )
            FROM 
                player p
            INNER JOIN 
                elemento e ON e.id_elemento = p.id_elemento
        );
    END;
    $$ LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION get_sala_atual(id_player_input INT)
    RETURNS TABLE(id_sala INT, nome_sala TEXT) AS $$
    BEGIN
        RETURN QUERY
        SELECT s.id_sala, s.nome::TEXT
        FROM sala s
        INNER JOIN party p ON s.id_sala = p.id_sala
        WHERE p.id_player = id_player_input;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION get_nome_sala(id_sala_input INT)
    RETURNS VARCHAR AS $$
    BEGIN
        RETURN (
            SELECT s.nome
            FROM sala s
            WHERE s.id_sala = id_sala_input
            LIMIT 1
        );
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V41_create_function_mudar_sala

Esta versão permite que os jogadores se movam entre salas dentro do jogo, desde que estejam conectadas. Essa funcionalidade melhora a navegação e promove um fluxo dinâmico no jogo.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION insert_cdz_player(p_nome_cdz TEXT) 
    RETURNS void AS
    $$
    DECLARE
        id_elemento_min INT;
        id_elemento_max INT;
        jogador_existente INT;
    BEGIN
        -- Verificar se já existe um jogador com esse nome
        SELECT COUNT(*) INTO jogador_existente FROM player WHERE nome = p_nome_cdz;
        
        IF jogador_existente > 0 THEN
            RAISE EXCEPTION 'Jogador com nome existente' USING ERRCODE = 'P0001';
        END IF;


        -- Inserir o registro com valores parcialmente aleatórios e outros fixos
        INSERT INTO player (
            id_elemento,
            nome,
            nivel,
            xp_atual,
            hp_max,
            magia_max,
            hp_atual,
            magia_atual,
            velocidade,
            ataque_fisico,
            ataque_magico     
        )
        VALUES (
            6, -- ID do elemento aleatório dentro do intervalo válido
            p_nome_cdz, -- Nome fornecido por parâmetro
            1, -- Nível fixo
            0, -- XP acumulado fixo
            1000, -- HP Máximo fixo
            500, -- Magia Máxima fixa
            1000, -- HP Atual fixo
            50, -- Magia Atual fixa
            70, -- Velocidade aleatória (0 a 60)
            100, -- Ataque físico  aleatório (0 a 60)
            100 -- Ataque mágico  aleatório (0 a 60)
        );

    END;
    $$
    LANGUAGE plpgsql;
    ```
</details>

### V41_create_cdz_player_function

Cria um jogador com atributos predefinidos e checa se já existe um com o mesmo nome.

<details>
    <sumary> Migrações </sumary>

    ```sql

    ```
</details>

### V43_create_get_mapa_function

Retorna todas as salas de uma casa específica.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION get_mapa(p_id_casa INT)
    RETURNS TABLE(
        id_sala INT,
        nome VARCHAR,
        norte INT,
        sul INT,
        leste INT,
        oeste INT
    ) AS $$
    BEGIN
        RETURN QUERY
        SELECT 
            s.id_sala, 
            s.nome, 
            s.id_sala_norte AS norte, 
            s.id_sala_sul AS sul, 
            s.id_sala_leste AS leste, 
            s.id_sala_oeste AS oeste
        FROM public.sala s
        WHERE s.id_casa = p_id_casa;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V44_func_saga_casas

Essa versão tem como objetivo fornecer informações sobre as sagas e casas disponíveis no jogo. Ela permite que os jogadores vejam quais sagas estão acessíveis com base em seu progresso e realizem mudanças entre sagas e casas conforme necessário, garantindo uma progressão fluida na experiência de jogo.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION listar_sagas(player_id INT)
    RETURNS TABLE (
        id_saga INT,
        nome_saga TEXT
    ) AS $$
    DECLARE
        player_exists INT;
        saga_count INT;
    BEGIN
        -- Verifica se o jogador existe
        SELECT COUNT(*) INTO player_exists FROM player WHERE id_player = player_id;
        IF player_exists = 0 THEN
            RAISE EXCEPTION 'O jogador com ID % não existe.', player_id;
        END IF;

        -- Conta quantas sagas estão disponíveis para o jogador
        SELECT COUNT(*) INTO saga_count
        FROM saga s
        LEFT JOIN missao m ON s.id_missao_requisito = m.id_missao
        LEFT JOIN player_missao pm ON pm.id_missao = m.id_missao AND pm.id_player = player_id
        WHERE s.id_saga <> 1 AND (s.id_missao_requisito IS NULL OR pm.status_missao = 'c');

        -- Se não houver sagas disponíveis, lança uma exceção específica
        IF saga_count = 0 THEN
            RAISE EXCEPTION 'Não existem sagas desbloqueadas para o jogador';
        END IF;

        -- Retorna as sagas disponíveis
        RETURN QUERY
        SELECT 
            s.id_saga, 
            s.nome :: TEXT
        FROM 
            saga s
        LEFT JOIN 
            missao m ON s.id_missao_requisito = m.id_missao
        LEFT JOIN 
            player_missao pm ON pm.id_missao = m.id_missao AND pm.id_player = player_id
        WHERE 
            s.id_saga <> 1 AND (s.id_missao_requisito IS NULL OR pm.status_missao = 'c');

    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION mudar_saga(player_id INT, nova_saga_id INT)
    RETURNS TEXT AS $$
    DECLARE
        saga_disponivel BOOLEAN;
        casa_inicial_da_saga INT;
        sala_inicial_da_saga INT;
    BEGIN
        -- Verifica se a saga está disponível para o jogador
        SELECT EXISTS(
            SELECT 1 
            FROM listar_sagas(player_id) 
            WHERE id_saga = nova_saga_id
        ) INTO saga_disponivel;

        IF NOT saga_disponivel THEN
            IF (SELECT 1 FROM Saga WHERE id_saga = nova_saga_id)  THEN
                RAISE EXCEPTION 'O jogador ainda não desbloqueou a saga selecionada.';
            END IF;
            RAISE EXCEPTION 'Insira um número de saga válido.';
        END IF;

        -- Verifica se o jogador existe
        IF NOT EXISTS (SELECT 1 FROM player WHERE id_player = player_id) THEN
            RAISE EXCEPTION 'Jogador não encontrado.';
        END IF;

        -- Verifica se a saga existe
        IF NOT EXISTS (SELECT 1 FROM saga WHERE id_saga = nova_saga_id) THEN
            RAISE EXCEPTION 'Insira uma saga válida.';
        END IF;

        -- Encontra a casa com o menor id_casa dentro da saga escolhida
        SELECT MIN(casa.id_casa) INTO casa_inicial_da_saga
        FROM casa
        WHERE casa.id_saga = nova_saga_id;

        -- Se nenhuma casa for encontrada, retorna erro
        IF casa_inicial_da_saga IS NULL THEN
            RAISE EXCEPTION 'Nenhuma casa inicial encontrada para esta saga.';
        END IF;

        -- Encontra a sala com o menor id_sala dentro da casa escolhida
        SELECT MIN(sala.id_sala) INTO sala_inicial_da_saga
        FROM sala
        WHERE sala.id_casa = casa_inicial_da_saga;

        -- Se nenhuma sala for encontrada, retorna erro
        IF sala_inicial_da_saga IS NULL THEN
        RAISE EXCEPTION 'Nenhuma sala inicial encontrada para esta casa.';
        END IF;

        UPDATE public.party
        SET id_sala = sala_inicial_da_saga
        WHERE id_player = player_id;

        RETURN 'Player mudou de saga com Sucesso';
    END;
    $$ LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION listar_casas(player_id INT)                    
    RETURNS TABLE (
        id_casa INT,
        nome_casa TEXT
    ) 
    AS $$
    DECLARE                                                                                                          
        player_exists INT;                                                                                         
    BEGIN
        -- Verifica se o jogador existe                                                                               
        SELECT COUNT(*) INTO player_exists 
        FROM player 
        WHERE id_player = player_id;                                  

        IF player_exists = 0 THEN                                                                                    
            RAISE EXCEPTION 'O jogador com ID % não existe.', player_id;
        END IF;                                                                                                       

        -- Retorna as casas disponíveis ordenadas por ID
        RETURN QUERY                                                                                                 
        SELECT 
            c.id_casa, 
            c.nome :: TEXT
        FROM 
            casa c
        LEFT JOIN 
            missao m ON c.id_missao_requisito = m.id_missao
        LEFT JOIN 
            player_missao pm ON pm.id_missao = m.id_missao AND pm.id_player = player_id
        WHERE 
            c.id_saga <> 1 
            AND (c.id_missao_requisito IS NULL OR pm.status_missao = 'c')
            AND c.id_saga = (
                SELECT sa.id_saga
                FROM party p
                JOIN sala s ON p.id_sala = s.id_sala
                JOIN casa ca ON ca.id_casa = s.id_casa
                JOIN saga sa ON sa.id_saga = ca.id_saga
                WHERE p.id_player = player_id
                LIMIT 1
            )
        ORDER BY c.id_casa; -- Ordena as casas pelo ID

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Nenhuma casa disponível foi encontrada para o jogador.';
        END IF;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION mudar_casa(player_id INT, nova_casa_id INT)
    RETURNS TEXT AS $$
    DECLARE
        casa_disponivel BOOLEAN;
        saga_da_casa INT;
        sala_inicial_da_casa INT;
    BEGIN
        SELECT id_saga INTO saga_da_casa FROM casa WHERE id_casa = nova_casa_id;

        IF saga_da_casa IS NULL THEN
            RAISE EXCEPTION 'A casa selecionada não existe.';
        END IF;

        SELECT EXISTS(
            SELECT 1 
            FROM listar_sagas(player_id) 
            WHERE id_saga = saga_da_casa
        ) INTO casa_disponivel;

        IF NOT casa_disponivel THEN
            RAISE EXCEPTION 'O jogador ainda não desbloqueou a saga desta casa.';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM player WHERE id_player = player_id) THEN
            RAISE EXCEPTION 'Jogador não encontrado.';
        END IF;

        SELECT MIN(sala.id_sala) INTO sala_inicial_da_casa
        FROM sala
        WHERE sala.id_casa = nova_casa_id;

        IF sala_inicial_da_casa IS NULL THEN
            RAISE EXCEPTION 'Nenhuma sala inicial encontrada para esta casa.';
        END IF;

        UPDATE public.party
        SET id_sala = sala_inicial_da_casa
        WHERE id_player = player_id;

        RETURN 'Player mudou de casa com sucesso';
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V45_create_listar_jogadores

Lista jogadores com atributos completos, incluindo dinheiro e elementos.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION listar_jogadores_formatados_v2()
    RETURNS TABLE (
        id_player INTEGER,
        nome TEXT,
        nivel INTEGER,
        elemento TEXT,
        hp_max INTEGER,
        magia_max INTEGER,
        hp_atual INTEGER,
        magia_atual INTEGER,
        ataque_fisico INTEGER,
        ataque_magico INTEGER,
        dinheiro INTEGER
    ) AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            p.id_player,  -- Adicionando o ID do jogador
            p.nome::TEXT AS nome,  -- Nome do jogador (de player)
            p.nivel,
            e.nome::TEXT AS elemento,  -- Nome do elemento (de elemento)
            p.hp_max,
            p.magia_max, 
            p.hp_atual, 
            p.magia_atual, 
            p.ataque_fisico, 
            p.ataque_magico,
            i.dinheiro
        FROM player p
        INNER JOIN elemento e ON e.id_elemento = p.id_elemento
        INNER JOIN inventario i on i.id_player = p.id_player
        ORDER BY p.id_player;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V46_replace_function_get_status

Retorna detalhes completos de um player.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION public.get_player_info_v2(player_id INTEGER)
    RETURNS TABLE (
        nome TEXT,
        nivel INTEGER,
        xp_atual INTEGER,
        hp_max INTEGER,
        magia_max INTEGER,
        hp_atual INTEGER,
        magia_atual INTEGER,
        velocidade INTEGER,
        ataque_fisico INTEGER,
        ataque_magico INTEGER,
        elemento TEXT
    ) AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            p.nome::TEXT,  -- Conversão explícita para TEXT
            p.nivel,
            p.xp_atual,
            p.hp_max,
            p.magia_max,
            p.hp_atual,
            p.magia_atual,
            p.velocidade,
            p.ataque_fisico,
            p.ataque_magico,
            e.nome::TEXT   -- Conversão explícita para TEXT
        FROM player p
        INNER JOIN elemento e ON e.id_elemento = p.id_elemento
        WHERE p.id_player = player_id;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V50_func_instanciar_inimigo

Cria uma instância de um inimigo com atributos baseados no original.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION criar_instancia_inimigo(p_id_inimigo INT, p_id_grupo INT DEFAULT NULL)
    RETURNS VOID AS $$
    DECLARE
        v_inimigo RECORD;
    BEGIN

        SELECT *
        INTO v_inimigo
        FROM inimigo
        WHERE id_inimigo = p_id_inimigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Inimigo com ID % não encontrado', p_id_inimigo;
        END IF;

        INSERT INTO instancia_inimigo (
            id_inimigo,
            id_grupo,
            hp_atual,
            magia_atual,
            ataque_fisico,
            ataque_magico,
            velocidade
        )
        VALUES (
            p_id_inimigo,              
            p_id_grupo,                
            v_inimigo.hp_max,         
            v_inimigo.magia_max,       
            10,                         
            10,
            10                          
        );

END;
$$ LANGUAGE plpgsql;
    ```
</details>

### V58_controle_total_exclusivo

As funções desta versão foram criadas para gerenciar os combates entre os personagens do jogo, levando em conta ataques físicos, habilidades mágicas e cálculo de dano. A mecânica de batalha é essencial para o desenvolvimento da jogabilidade, estratégia e progressão do jogador.

<details>
    <sumary> Migrações </sumary>

    ```sql
    -- CREATE OR REPLACE FUNCTION enforce_tipo_item_exclusivo()
    -- RETURNS TRIGGER AS $$
    -- DECLARE
    --     v_id_item INT;
    --     total_subclasses INT;
    -- BEGIN
    --     CASE TG_TABLE_NAME
    --         WHEN 'material' THEN v_id_item := NEW.id_material;
    --         WHEN 'armadura' THEN v_id_item := NEW.id_armadura;
    --         WHEN 'item_missao' THEN v_id_item := NEW.id_item;
    --         WHEN 'consumivel' THEN v_id_item := NEW.id_item;
    --         WHEN 'livro' THEN v_id_item := NEW.id_item;
    --         ELSE 
    --             RAISE EXCEPTION 'Trigger chamada em uma tabela desconhecida!';
    --     END CASE;

    --     SELECT COUNT(*) INTO total_subclasses FROM (
    --         SELECT id_material FROM material WHERE id_material = v_id_item
    --         UNION ALL
    --         SELECT id_armadura FROM armadura WHERE id_armadura = v_id_item
    --         UNION ALL
    --         SELECT id_item FROM item_missao WHERE id_item = v_id_item
    --         UNION ALL
    --         SELECT id_item FROM consumivel WHERE id_item = v_id_item
    --         UNION ALL
    --         SELECT id_item FROM livro WHERE id_item = v_id_item
    --     ) AS sub_tabelas;

    --     IF total_subclasses > 1 THEN
    --         RAISE EXCEPTION 'O item deve pertencer a apenas uma subclasse!';
    --     END IF;

    --     RETURN NEW;
    -- END;
    -- $$ LANGUAGE plpgsql;

    -- CREATE TRIGGER check_tipo_item_exclusivo_material
    -- BEFORE INSERT OR UPDATE ON material
    -- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    -- CREATE TRIGGER check_tipo_item_exclusivo_armadura
    -- BEFORE INSERT OR UPDATE ON armadura
    -- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    -- CREATE TRIGGER check_tipo_item_exclusivo_item_missao
    -- BEFORE INSERT OR UPDATE ON item_missao
    -- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    -- CREATE TRIGGER check_tipo_item_exclusivo_consumivel
    -- BEFORE INSERT OR UPDATE ON consumivel
    -- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    -- CREATE TRIGGER check_tipo_item_exclusivo_livro
    -- BEFORE INSERT OR UPDATE ON livro
    -- FOR EACH ROW EXECUTE FUNCTION enforce_tipo_item_exclusivo();

    -- CREATE OR REPLACE PROCEDURE inserir_item(
    --     IN p_tipo_item enum_tipo_item,
    --     IN p_nome VARCHAR,
    --     IN p_preco_venda INT DEFAULT NULL,
    --     IN p_descricao VARCHAR DEFAULT NULL,
    --     IN p_id_parte_corpo enum_parte_corpo DEFAULT NULL,
    --     IN p_raridade_armadura VARCHAR DEFAULT NULL,
    --     IN p_defesa_magica INT DEFAULT NULL,
    --     IN p_defesa_fisica INT DEFAULT NULL,
    --     IN p_ataque_magico INT DEFAULT NULL,
    --     IN p_ataque_fisico INT DEFAULT NULL,
    --     IN p_durabilidade_max INT DEFAULT NULL,
    --     IN p_saude_restaurada INT DEFAULT NULL, 
    --     IN p_magia_restaurada INT DEFAULT NULL, 
    --     IN p_saude_maxima INT DEFAULT NULL, 
    --     IN p_magia_maxima INT DEFAULT NULL, 
    --     IN p_id_habilidade INT DEFAULT NULL 
    -- )
    -- LANGUAGE plpgsql
    -- AS $$
    -- DECLARE
    --     v_id_item INT;
    -- BEGIN
        
    --     INSERT INTO tipo_item (tipo_item) VALUES (p_tipo_item) RETURNING id_item INTO v_id_item;

        
    --     CASE p_tipo_item
    --         WHEN 'm' THEN 
    --             INSERT INTO material (id_material, nome, preco_venda, descricao) 
    --             VALUES (v_id_item, p_nome, p_preco_venda, p_descricao);
            
    --         WHEN 'a' THEN 
    --             INSERT INTO armadura (id_armadura, id_parte_corpo, nome, raridade_armadura, defesa_magica, defesa_fisica, ataque_magico, ataque_fisico, durabilidade_max, preco_venda, descricao) 
    --             VALUES (v_id_item, p_id_parte_corpo, p_nome, p_raridade_armadura, p_defesa_magica, p_defesa_fisica, p_ataque_magico, p_ataque_fisico, p_durabilidade_max, p_preco_venda, p_descricao);
            
    --         WHEN 'i' THEN 
    --             INSERT INTO item_missao (id_item, nome, descricao) 
    --             VALUES (v_id_item, p_nome, p_descricao);
            
    --         WHEN 'c' THEN 
    --             INSERT INTO consumivel (id_item, nome, descricao, preco_venda, saude_restaurada, magia_restaurada, saude_maxima, magia_maxima) 
    --             VALUES (v_id_item, p_nome, p_descricao, p_preco_venda, p_saude_restaurada, p_magia_restaurada, p_saude_maxima, p_magia_maxima);
            
    --         WHEN 'l' THEN 
    --             INSERT INTO livro (id_item, id_habilidade, nome, descricao, preco_venda) 
    --             VALUES (v_id_item, p_id_habilidade, p_nome, p_descricao, p_preco_venda);
            
    --         ELSE 
    --             RAISE EXCEPTION 'Tipo de item inválido!';
    --     END CASE;

    --     RAISE NOTICE 'Item inserido com sucesso! ID: %', v_id_item;
    -- END;
    -- $$;
    ```
</details>

### V61_batalha

Essa funcionalidade foi criada para garantir que os bosses e inimigos sejam restaurados automaticamente após um determinado período, permitindo que os jogadores continuem enfrentando desafios sem interrupções prolongadas no jogo.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION calcular_dano(
        atacante_ataque INT,
        defensor_defesa INT,
        critico_chance FLOAT,
        atacante_elemento INT,
        defensor_elemento INT
    ) RETURNS INT AS $$
    DECLARE
        dano INT;
        critico BOOLEAN;
        vantagem BOOLEAN;
        fraqueza BOOLEAN;
    BEGIN
        -- Verifica se foi crítico
        critico := (random() <= critico_chance);

        -- Verifica vantagem de elemento
        SELECT COUNT(*)
        INTO vantagem
        FROM elemento e
        WHERE e.id_elemento = atacante_elemento
        AND e.forte_contra = defensor_elemento;

    -- Verifica fraqueza de elemento
        SELECT COUNT(*)
        INTO vantagem
        FROM elemento e
        WHERE e.id_elemento = atacante_elemento
        AND e.fraco_contra = defensor_elemento;

        -- Calcula o dano base
        dano := atacante_ataque - defensor_defesa;

        -- Aplica multiplicador para dano crítico
        IF critico THEN
            dano := dano * 1.5; -- Multiplica por 1.5 se for crítico
        END IF;

        -- Aplica multiplicador para vantagem de elementos
        IF vantagem THEN
            dano := dano * 1.25; -- Multiplica por 1.25 para vantagem de elementos
        END IF;

        IF fraqueza THEN
            dano := dano * 0.75; -- Multiplica por 0.75 para desvantagem 
        END IF;

        -- Garante que o dano não seja negativo
        RETURN GREATEST(dano, 0);
    END;
    $$ LANGUAGE plpgsql;



    CREATE OR REPLACE VIEW info_batalha AS
    -- Informações do Player
    SELECT
        p.id_player AS id,
        'player' AS tipo_personagem,
        p.player_velocidade AS velocidade,
        p.player_hp_atual AS hp_atual,
        p.player_hp_max AS hp_max,
        p.player_magia_atual AS magia_atual,
        p.player_magia_max AS magia_max,
        p.ataque_fisico_total AS ataque_fisico, -- Usa o total já calculado
        p.ataque_magico_total AS ataque_magico  -- Usa o total já calculado
    FROM
        player_info_view p

    UNION ALL

    -- Informações dos Cavaleiros na Party
    SELECT
        pcv.id_cavaleiro AS id,
        'cavaleiro' AS tipo_personagem,
        pcv.cavaleiro_velocidade AS velocidade,
        pcv.cavaleiro_hp_atual AS hp_atual,
        pcv.cavaleiro_hp_max AS hp_max,
        pcv.cavaleiro_magia_atual AS magia_atual,
        pcv.cavaleiro_magia_max AS magia_max,
        pcv.cavaleiro_ataque_fisico AS ataque_fisico,
        pcv.cavaleiro_ataque_magico AS ataque_magico
    FROM
        party_cavaleiros_view pcv

    UNION ALL

    -- Informações do Boss
    SELECT
        b.id_boss AS id,
        'boss' AS tipo_personagem,
        b.boss_velocidade AS velocidade,
        b.boss_hp_atual AS hp_atual,
        b.boss_hp_max AS hp_max,
        b.boss_magia_atual AS magia_atual,
        b.boss_magia_max AS magia_max,
        b.boss_ataque_fisico AS ataque_fisico,
        b.boss_ataque_magico AS ataque_magico
    FROM
        boss_info_view b;


    CREATE OR REPLACE FUNCTION boss_ataque_fisico(boss_id INT, player_id INT)
    RETURNS VOID AS $$
    DECLARE
        alvo RECORD;
        parte_alvo RECORD;
        dano_base INT;
        dano INT;
        critico BOOLEAN;
        vantagem BOOLEAN;
        fraqueza BOOLEAN;
        chance_critico INT;
    BEGIN
        -- 🔹 1. Buscar um alvo com fraqueza ao elemento do Boss (Player ou Cavaleiro)
        SELECT id_player AS id, 'player' AS tipo, player_nome AS nome, player_hp_atual AS hp, elemento_nome AS elemento
        INTO alvo
        FROM player_info_view
        WHERE id_player = player_id
        AND id_fraqueza = (SELECT id_vantagem FROM boss_info_view WHERE id_boss = boss_id)
        AND player_hp_atual > 0
        LIMIT 1;

        -- 🔹 2. Se não encontrou um alvo fraco, buscar um Cavaleiro do mesmo Player
        IF alvo.id IS NULL THEN
            SELECT id_cavaleiro AS id, 'cavaleiro' AS tipo, cavaleiro_nome AS nome, cavaleiro_hp_atual AS hp, cavaleiro_elemento_nome AS elemento
            INTO alvo
            FROM party_cavaleiros_view
            WHERE id_player = player_id
            AND id_fraqueza = (SELECT id_vantagem FROM boss_info_view WHERE id_boss = boss_id)
            AND cavaleiro_hp_atual > 0
            LIMIT 1;
        END IF;

        -- 🔹 3. Se ainda não encontrou, escolher aleatoriamente entre Player e Cavaleiro
        IF alvo.id IS NULL THEN
            SELECT id, tipo, nome, hp, elemento INTO alvo FROM (
                SELECT id_player AS id, 'player' AS tipo, player_nome AS nome, player_hp_atual AS hp, elemento_nome AS elemento
                FROM player_info_view
                WHERE id_player = player_id AND player_hp_atual > 0
                UNION ALL
                SELECT id_cavaleiro AS id, 'cavaleiro' AS tipo, cavaleiro_nome AS nome, cavaleiro_hp_atual AS hp, cavaleiro_elemento_nome AS elemento
                FROM party_cavaleiros_view
                WHERE id_player = player_id AND cavaleiro_hp_atual > 0
            ) AS alvos_possiveis
            ORDER BY random()
            LIMIT 1;
        END IF;

        -- 🔹 4. Escolher uma parte do corpo do alvo
        IF alvo.tipo = 'player' THEN
            SELECT parte_corpo_nome, parte_corpo_defesa_fisica_total AS defesa_fisica, parte_corpo_defesa_magica_total AS defesa_magica, parte_corpo_chance_acerto_critico AS chance_critico
            INTO parte_alvo
            FROM player_parte_corpo_info_view
            WHERE id_player = alvo.id
            ORDER BY random()
            LIMIT 1;
        ELSE
            SELECT cavaleiro_parte_corpo as parte_corpo_nome, cavaleiro_defesa_fisica AS defesa_fisica, cavaleiro_defesa_magica AS defesa_magica, cavaleiro_chance_acerto_critico AS chance_critico
            INTO parte_alvo
            FROM cavaleiro_parte_corpo_info_view
            WHERE id_cavaleiro = alvo.id
            ORDER BY random()
            LIMIT 1;
        END IF;

        -- 🔹 5. Definir dano base como ataque físico do Boss
        SELECT boss_ataque_fisico INTO dano_base FROM boss_info_view WHERE id_boss = boss_id;

        -- 🔹 6. Aplicar modificadores de dano
        dano := dano_base - parte_alvo.defesa_fisica;
        IF dano < 0 THEN dano := 1; END IF;

        critico := (random() * 100) < parte_alvo.chance_critico;
        IF critico THEN dano := dano * 1.5; END IF;

        -- 🔹 8. Log do ataque
        RAISE NOTICE 'Boss atacou % em % causando % de dano!', alvo.nome, parte_alvo.parte_corpo_nome, dano;
        
        -- 🔹 7. Aplicar dano ao alvo correto
        IF alvo.tipo = 'player' THEN
            UPDATE player SET hp_atual = hp_atual - dano WHERE id_player = alvo.id;
        ELSE
            UPDATE instancia_cavaleiro SET hp_atual = hp_atual - dano WHERE id_cavaleiro = alvo.id;
        END IF;

    
        

    END $$ LANGUAGE plpgsql;





    CREATE OR REPLACE FUNCTION player_ataque_fisico(player_id INT, boss_id INT, parte_alvo_escolhida enum_parte_corpo)
    RETURNS VOID AS $$
    DECLARE
        parte_alvo RECORD;
        dano_base INT;
        dano INT;
        critico BOOLEAN;
        vantagem BOOLEAN;
        fraqueza BOOLEAN;
        chance_critico INT;
        p_nome TEXT;
    BEGIN
        -- 🔹 1. Buscar a parte do corpo do Boss que o Player escolheu atacar
        SELECT parte_corpo, boss_defesa_fisica AS defesa_fisica, boss_defesa_magica AS defesa_magica, boss_chance_acerto_critico AS chance_critico, boss_parte_corpo as nome_parte_corpo
        INTO parte_alvo
        FROM boss_parte_corpo_info_view
        WHERE id_boss = boss_id
        AND parte_corpo = parte_alvo_escolhida
        LIMIT 1;

        -- 🔹 2. Verificar se a parte do corpo escolhida é válida
        IF parte_alvo.parte_corpo IS NULL THEN
            RAISE NOTICE 'Parte do corpo inválida! O ataque falhou.';
            RETURN;
        END IF;

        -- 🔹 3. Definir dano base como ataque físico do Player
        SELECT ataque_fisico_total, player_nome INTO dano_base, p_nome FROM player_info_view WHERE id_player = player_id;

        -- 🔹 4. Aplicar modificadores de dano baseados na defesa do Boss
        dano := dano_base - parte_alvo.defesa_fisica;
        IF dano < 0 THEN dano := 1; END IF;  -- Evita dano negativo

        -- 🔹 5. Calcular chance de acerto crítico
        critico := (random() * 100) < parte_alvo.chance_critico;
        IF critico THEN dano := dano * 1.5; END IF;

        -- 🔹 6. Verificar vantagem e fraqueza elementais
        vantagem := (SELECT id_elemento FROM player_info_view WHERE id_player = player_id) = (SELECT id_fraqueza FROM boss_info_view WHERE id_boss = boss_id);
        fraqueza := (SELECT id_elemento FROM player_info_view WHERE id_player = player_id) = (SELECT id_vantagem FROM boss_info_view WHERE id_boss = boss_id);

        -- 🔹 7. Aplicar multiplicadores de dano
        IF vantagem THEN
            dano := dano * 1.25;  -- Aumenta 25% se o Player tiver vantagem elemental
        END IF;

        IF fraqueza THEN
            dano := dano * 0.75;  -- Reduz 25% se o Player tiver fraqueza elemental
        END IF;

        -- 🔹 8. Exibir mensagem do ataque
        RAISE NOTICE '% atacou o Boss na % causando % de dano!', p_nome, parte_alvo.parte_corpo, dano;

        -- 🔹 9. Aplicar dano ao Boss
        UPDATE boss
        SET hp_atual = hp_atual - dano
        WHERE id_boss = boss_id;

        -- 🔹 10. Verificar se o Boss morreu
        IF (SELECT hp_atual FROM boss WHERE id_boss = boss_id) <= 0 THEN
            RAISE NOTICE 'O Boss foi derrotado!';
        END IF;

    END $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION cavaleiro_ataque_fisico(cavaleiro_id INT, boss_id INT, parte_alvo_escolhida enum_parte_corpo)
    RETURNS VOID AS $$
    DECLARE
        parte_alvo RECORD;
        dano_base INT;
        dano INT;
        critico BOOLEAN;
        vantagem BOOLEAN;
        fraqueza BOOLEAN;
        chance_critico INT;
        c_nome TEXT;
        nome_boss TEXT;  -- 🔹 Adicionamos uma variável para armazenar o nome do Boss
    BEGIN
        -- 🔹 1. Buscar o nome do Boss
        SELECT boss_nome INTO nome_boss FROM boss_info_view b WHERE id_boss = boss_id;

        -- 🔹 2. Buscar a parte do corpo do Boss que o Cavaleiro escolheu atacar
        SELECT parte_corpo, boss_defesa_fisica AS defesa_fisica, boss_defesa_magica AS defesa_magica, boss_chance_acerto_critico AS chance_critico, boss_parte_corpo AS nome_parte_corpo
        INTO parte_alvo
        FROM boss_parte_corpo_info_view
        WHERE id_boss = boss_id
        AND parte_corpo = parte_alvo_escolhida
        LIMIT 1;

        -- 🔹 3. Verificar se a parte do corpo escolhida é válida
        IF parte_alvo.parte_corpo IS NULL THEN
            RAISE NOTICE 'Parte do corpo inválida! O ataque falhou.';
            RETURN;
        END IF;

        -- 🔹 4. Definir dano base como ataque físico do Cavaleiro
        SELECT cavaleiro_ataque_fisico, cavaleiro_nome 
        INTO dano_base, c_nome
        FROM party_cavaleiros_view 
        WHERE id_cavaleiro = cavaleiro_id;

        -- 🔹 5. Aplicar modificadores de dano baseados na defesa do Boss
        dano := dano_base - parte_alvo.defesa_fisica;
        IF dano < 0 THEN dano := 1; END IF;

        -- 🔹 6. Calcular chance de acerto crítico
        critico := (random() * 100) < parte_alvo.chance_critico;
        IF critico THEN dano := dano * 1.5; END IF;

        -- 🔹 7. Verificar vantagem e fraqueza elementais
        vantagem := (SELECT id_vantagem FROM party_cavaleiros_view WHERE id_cavaleiro = cavaleiro_id) = 
                    (SELECT id_fraqueza FROM boss_info_view WHERE id_boss = boss_id);
        
        fraqueza := (SELECT id_fraqueza FROM party_cavaleiros_view WHERE id_cavaleiro = cavaleiro_id) = 
                    (SELECT id_vantagem FROM boss_info_view WHERE id_boss = boss_id);

        -- 🔹 8. Aplicar multiplicadores de dano
        IF vantagem THEN
            dano := dano * 1.25;  -- Aumenta 25% se o Cavaleiro tiver vantagem elemental
        END IF;

        IF fraqueza THEN
            dano := dano * 0.75;  -- Reduz 25% se o Cavaleiro tiver fraqueza elemental
        END IF;

        -- 🔹 9. Exibir mensagem do ataque incluindo o nome do Boss
        RAISE NOTICE '% atacou % na % causando % de dano!', c_nome, nome_boss, parte_alvo.nome_parte_corpo, dano;

        -- 🔹 10. Aplicar dano ao Boss
        UPDATE boss
        SET hp_atual = hp_atual - dano
        WHERE id_boss = boss_id;

        -- 🔹 11. Verificar se o Boss morreu
        IF (SELECT hp_atual FROM boss WHERE id_boss = boss_id) <= 0 THEN
            RAISE NOTICE '% foi derrotado!', nome_boss;
        END IF;

    END $$ LANGUAGE plpgsql;






    -- -- CREATE OR REPLACE FUNCTION player_ataca_inimigo(
    -- --     p_id_player INT,
    -- --     p_id_instancia_inimigo INT,
    -- --     p_parte_corpo enum_parte_corpo
    -- -- ) RETURNS TABLE(mensagem TEXT) AS $$
    -- -- DECLARE
    -- --     v_nome_player TEXT;
    -- --     v_nome_inimigo TEXT;
    -- --     v_ataque_fisico INT;
    -- --     v_defesa_fisica INT;
    -- --     v_hp_atual_antes INT;
    -- --     v_hp_atual_depois INT;
    -- --     v_dano INT;
    -- --     v_parte_corpo_extenso TEXT;
    -- -- BEGIN
    -- --     SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
    -- --     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
    -- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    -- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

    -- --     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM player WHERE id_player = p_id_player;
    -- --     SELECT pci.defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo pci
    -- --     WHERE pci.id_instancia = p_id_instancia_inimigo AND pci.parte_corpo = p_parte_corpo;

    -- --     SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    -- --     v_parte_corpo_extenso := CASE 
    -- --         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
    -- --         WHEN p_parte_corpo = 't' THEN 'Tronco'
    -- --         WHEN p_parte_corpo = 'b' THEN 'Braços'
    -- --         WHEN p_parte_corpo = 'p' THEN 'Pernas'
    -- --         ELSE 'Desconhecido' 
    -- --     END;

    -- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
    -- --         RETURN QUERY SELECT 'Erro: Player ou inimigo não encontrado!'::TEXT;
    -- --     END IF;

    -- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

    -- --     UPDATE instancia_inimigo 
    -- --     SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
    -- --     WHERE id_instancia = p_id_instancia_inimigo;

    -- --     SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    -- --     RETURN QUERY SELECT format(
    -- --         '🗡️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
    -- --         v_nome_player, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
    -- --     );
    -- -- END;
    -- -- $$ LANGUAGE plpgsql;

    -- -- CREATE OR REPLACE FUNCTION cavaleiro_ataca_inimigo(
    -- --     p_id_instancia_inimigo INT,
    -- --     p_parte_corpo enum_parte_corpo
    -- -- ) RETURNS TABLE(mensagem TEXT) AS $$
    -- -- DECLARE
    -- --     v_nome_cavaleiro TEXT;
    -- --     v_nome_inimigo TEXT;
    -- --     v_ataque_fisico INT;
    -- --     v_defesa_fisica INT;
    -- --     v_hp_atual_antes INT;
    -- --     v_hp_atual_depois INT;
    -- --     v_dano INT;
    -- --     v_parte_corpo_extenso TEXT;public.player
    -- -- BEGIN
    -- --     SELECT c.nome INTO v_nome_cavaleiro FROM instancia_cavaleiro ic 
    -- --     INNER JOIN cavaleiro c ON ic.id_cavaleiro = c.id_cavaleiro

    -- --     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
    -- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    -- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

    -- --     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM instancia_cavaleiro 

    -- --     SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_inimigo 
    -- --     WHERE id_instancia = p_id_instancia_inimigo AND parte_corpo = p_parte_corpo;

    -- --     SELECT hp_atual INTO v_hp_atual_antes FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    -- --     v_parte_corpo_extenso := CASE 
    -- --         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
    -- --         WHEN p_parte_corpo = 't' THEN 'Tronco'
    -- --         WHEN p_parte_corpo = 'b' THEN 'Braços'
    -- --         WHEN p_parte_corpo = 'p' THEN 'Pernas'
    -- --         ELSE 'Desconhecido' 
    -- --     END;

    -- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
    -- --         RETURN QUERY SELECT 'Erro: Cavaleiro ou inimigo não encontrado!'::TEXT;
    -- --     END IF;

    -- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

    -- --     UPDATE instancia_inimigo 
    -- --     SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
    -- --     WHERE id_instancia = p_id_instancia_inimigo;

    -- --     SELECT hp_atual INTO v_hp_atual_depois FROM instancia_inimigo WHERE id_instancia = p_id_instancia_inimigo;

    -- --     RETURN QUERY SELECT format(
    -- --         '⚔️ %s atacou %s na %s, causando %s de dano. HP: %s → %s',
    -- --         v_nome_cavaleiro, v_nome_inimigo, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
    -- --     );
    -- -- END;
    -- -- $$ LANGUAGE plpgsql;

    -- -- CREATE OR REPLACE FUNCTION inimigo_ataca_player(
    -- --     p_id_instancia_inimigo INT,
    -- --     p_id_player INT,
    -- --     p_parte_corpo enum_parte_corpo
    -- -- ) RETURNS TABLE(mensagem TEXT) AS $$
    -- -- DECLARE
    -- --     v_nome_inimigo TEXT;
    -- --     v_nome_player TEXT;
    -- --     v_ataque_fisico INT;
    -- --     v_defesa_fisica INT;
    -- --     v_hp_atual_antes INT;
    -- --     v_hp_atual_depois INT;
    -- --     v_dano INT;
    -- --     v_parte_corpo_extenso TEXT;
    -- -- BEGIN
    -- --     SELECT nome INTO v_nome_player FROM player WHERE id_player = p_id_player;
    -- --     SELECT i.nome INTO v_nome_inimigo FROM instancia_inimigo ii
    -- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    -- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

    -- --     SELECT ataque_fisico / 8 INTO v_ataque_fisico FROM instancia_inimigo ii
    -- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    -- --     WHERE ii.id_instancia = p_id_instancia_inimigo;


    -- --     SELECT defesa_fisica INTO v_defesa_fisica FROM parte_corpo_player 

    -- --     WHERE id_player = p_id_player AND parte_corpo = p_parte_corpo;

    -- --     SELECT hp_atual INTO v_hp_atual_antes FROM player WHERE id_player = p_id_player;

    -- --     v_parte_corpo_extenso := CASE 
    -- --         WHEN p_parte_corpo = 'c' THEN 'Cabeça'
    -- --         WHEN p_parte_corpo = 't' THEN 'Tronco'
    -- --         WHEN p_parte_corpo = 'b' THEN 'Braços'
    -- --         WHEN p_parte_corpo = 'p' THEN 'Pernas'
    -- --         ELSE 'Desconhecido' 
    -- --     END;

    -- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
    -- --         RETURN QUERY SELECT 'Erro: Inimigo ou player não encontrado!'::TEXT;
    -- --     END IF;

    -- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0);

    -- --     UPDATE player SET hp_atual = GREATEST(hp_atual - v_dano, 0) 
    -- --     WHERE id_player = p_id_player;

    -- --     SELECT hp_atual INTO v_hp_atual_depois FROM player WHERE id_player = p_id_player;

    -- --     RETURN QUERY SELECT format(
    -- --         '🔥 %s atacou %s na %s, causando %s de dano. HP: %s → %s',
    -- --         v_nome_inimigo, v_nome_player, v_parte_corpo_extenso, v_dano, v_hp_atual_antes, v_hp_atual_depois
    -- --     );
    -- -- END;
    -- -- $$ LANGUAGE plpgsql;

    -- -- TA COMENTADO POIS IA TER Q MEXER NA LOGICA INTEIRA 

    -- -- CREATE OR REPLACE FUNCTION inimigo_ataca_cavaleiro(
    -- --     p_id_instancia_inimigo INT,
    -- --     p_parte_corpo enum_parte_corpo
    -- -- ) RETURNS TABLE(mensagem TEXT) AS $$
    -- -- DECLARE
    -- --     v_ataque_fisico INT;
    -- --     v_defesa_fisica INT;
    -- --     v_hp_atual INT;
    -- --     v_dano INT;
    -- -- BEGIN
    -- --     -- Obtém o ataque físico do inimigo
    -- --     SELECT i.ataque_fisico INTO v_ataque_fisico
    -- --     FROM instancia_inimigo ii
    -- --     INNER JOIN inimigo i ON ii.id_inimigo = i.id_inimigo
    -- --     WHERE ii.id_instancia = p_id_instancia_inimigo;

    -- --     -- Obtém a defesa da parte do corpo do cavaleiro
    -- --     SELECT pcc.defesa_fisica INTO v_defesa_fisica
    -- --     FROM parte_corpo_cavaleiro pcc
    -- --     INNER JOIN instancia_cavaleiro ic 
    -- --         ON ic.id_instancia_cavaleiro = pcc.id_instancia_cavaleiro
    -- --     WHERE pcc.id_instancia_cavaleiro = p_id_instancia_cavaleiro
    -- --         AND pcc.parte_corpo = p_parte_corpo;

    -- --     -- Se ataque ou defesa não forem encontrados, retorna erro
    -- --     IF v_ataque_fisico IS NULL OR v_defesa_fisica IS NULL THEN
    -- --         RETURN QUERY SELECT 'Erro: Inimigo ou cavaleiro não encontrado!'::TEXT;
    -- --     END IF;

    -- --     -- Calcula o dano causado
    -- --     v_dano := GREATEST(v_ataque_fisico - v_defesa_fisica, 0); -- Garante que o dano não seja negativo

    -- --     -- Atualiza o HP do cavaleiro
    -- --     UPDATE instancia_cavaleiro
    -- --     SET hp_atual = GREATEST(hp_atual - v_dano, 0) -- Garante que o HP não seja negativo
    -- --     WHERE id_instancia_cavaleiro = p_id_instancia_cavaleiro;

    -- --     -- Obtém o novo HP do cavaleiro
    -- --     SELECT hp_atual INTO v_hp_atual
    -- --     FROM instancia_cavaleiro
    -- --     WHERE id_instancia_cavaleiro = p_id_instancia_cavaleiro;

    -- --     -- Retorna a mensagem do ataque
    -- --     RETURN QUERY SELECT format(
    -- --         '💀 Inimigo %s atacou o Cavaleiro %s na parte %s, causando %s de dano. HP Atual do Cavaleiro: %s',
    -- --         p_id_instancia_inimigo, p_id_instancia_cavaleiro, p_parte_corpo, v_dano, v_hp_atual
    -- --     );
    -- -- END;
    -- -- $$ LANGUAGE plpgsql;

    -- create or replace view info_batalha as		 
    -- select 
    -- 	c.nome,
    -- 	c.id_elemento,
    -- 	c.nivel,
    -- 	c.hp_max ,
    -- 	ic.hp_atual,
    -- 	c.magia_max ,
    -- 	ic.magia_atual,
    -- 	ic.velocidade,
    -- 	ic.ataque_fisico ,
    -- 	ic.ataque_magico ,
    -- 	pcc.defesa_magica ,
    -- 	pcc.defesa_fisica ,
    -- 	pcc.parte_corpo ,
    -- 	p.id_player, -- 
    -- 	'c' as tipo_personagem,
    -- 	ic.id_cavaleiro as id
    -- 	from 
    -- 	party p
    -- inner join instancia_cavaleiro ic on
    -- 	ic.id_player = p.id_player
    -- inner join cavaleiro c on
    -- 	c.id_cavaleiro = ic.id_cavaleiro
    -- inner join parte_corpo_cavaleiro pcc 
    -- on
    -- 	pcc.id_cavaleiro = ic.id_cavaleiro
    -- union all
    -- select
    -- 	   inim.nome,
    -- 	   inim.id_elemento,
    -- 	   inim.nivel ,
    -- 	   inim.hp_max,
    -- 	   ii.hp_atual ,
    -- 	   inim.magia_max,
    -- 	   ii.magia_atual,
    -- 	   ii.velocidade,
    -- 	   ii.ataque_fisico,
    -- 	   ii.ataque_magico,
    -- 	   ii.defesa_magica ,
    -- 	   ii.defesa_fisica ,
    -- 	   pci.parte_corpo ,
    -- 	   p.id_player, -- id_player que ta batalhando
    -- 	   'i' as tipo_personagem,
    -- 	   ii.id_instancia as id
    -- from
    -- 	grupo_inimigo gi
    -- inner join instancia_inimigo ii 
    -- 		 on
    -- 	ii.id_grupo = gi.id_grupo
    -- inner join inimigo inim
    -- 		 on
    -- 	ii.id_inimigo = inim.id_inimigo
    -- inner join party p 
    -- 		 on
    -- 	p.id_sala = gi.id_sala
    -- inner join parte_corpo_inimigo pci 
    -- 		 on
    -- 	pci.id_inimigo = ii.id_inimigo
    -- 	and pci.id_instancia = ii.id_instancia
    -- union all
    -- select
    -- 	p.nome,
    -- 	p.id_elemento,
    -- 	p.nivel,
    -- 	p.hp_max,
    -- 	p.hp_atual,
    -- 	p.magia_max,
    -- 	p.magia_atual,
    -- 	p.velocidade,
    -- 	p.ataque_fisico + aev.ataque_fisico as ataque_fisico_armadura,
    -- 	p.ataque_magico + aev.ataque_magico as ataque_magico_armadura,
    -- 	pcp.defesa_magica + aev.defesa_magica as defesa_magica,
    -- 	aev.defesa_fisica + pcp.defesa_fisica as defesa_fisica,
    -- 	aev.durabilidade_atual,
    -- 	pcp.parte_corpo,
    -- 	p.id_player, 
    -- 	'p' as tipo_personagem,
    -- 	p.id_player as id -- repeti essa coluna pois preciso que union traga colunas iguais
    -- from
    -- 	player p
    -- inner join armadura_equipada ae 
    -- on
    -- 	ae.id_player = p.id_player
    -- inner join armadura_equipada_view aev
    -- on
    -- 	aev.id_inventario = p.id_player
    -- inner join parte_corpo_player pcp 
    -- on
    -- 	pcp.id_player = p.id_player
    -- 	and pcp.parte_corpo = aev.id_parte_corpo_armadura;

    -- CREATE OR REPLACE VIEW fila AS
    -- WITH min_speed AS (
    --   SELECT MIN(velocidade) AS min_vel FROM info_batalha
    -- ),
    -- ataques AS (
    --   SELECT 
    --     i.id,
    --     i.tipo_personagem,
    --     i.velocidade,
    --     (i.velocidade / m.min_vel)::int AS num_attacks
    --   FROM info_batalha i
    --   CROSS JOIN min_speed m
    -- ),
    -- rounds AS (
    --   SELECT 
    --     a.id,
    --     a.tipo_personagem,
    --     a.velocidade,
    --     gs AS round_num
    --   FROM ataques a
    --   CROSS JOIN LATERAL generate_series(1, a.num_attacks) AS gs(round_num)
    -- )
    -- SELECT id, tipo_personagem
    -- FROM rounds
    -- ORDER BY round_num, velocidade DESC;

    -- -- como 
    -- -- como usar a view fila, voce filtro pelo id_player como where id_player = 'id do player que tá batalhando"


    -- -- select * from info_batalha where player_id = 1

    CREATE OR REPLACE FUNCTION inimigo_ataque_fisico(
        p_id_instancia INT,
        p_player INT
    )
    RETURNS VOID AS 
    $$
    DECLARE
        alvo RECORD;
        parte_alvo RECORD;
        dano_base INT;
        dano INT;
        critico BOOLEAN;
        current_hp INT;
        enemy_id INT;  
    BEGIN
        
        SELECT id, tipo, nome, hp, elemento
        INTO alvo
        FROM (
            SELECT id_player AS id,
                    'player' AS tipo,
                    player_nome AS nome,
                    COALESCE(player_hp_atual, 0) AS hp,
                    elemento_nome AS elemento
            FROM player_info_view
            WHERE id_player = p_player
                AND COALESCE(player_hp_atual, 0) > 0
            UNION ALL
            SELECT id_cavaleiro AS id,
                    'cavaleiro' AS tipo,
                    cavaleiro_nome AS nome,
                    COALESCE(cavaleiro_hp_atual, 0) AS hp,
                    cavaleiro_elemento_nome AS elemento
            FROM party_cavaleiros_view
            WHERE id_player = p_player
                AND COALESCE(cavaleiro_hp_atual, 0) > 0
        ) AS alvos_disponiveis
        ORDER BY random()
        LIMIT 1;

        IF alvo.id IS NULL THEN
            RAISE NOTICE 'Não há alvos disponíveis para o ataque.';
            RETURN;
        END IF;

        IF alvo.tipo = 'player' THEN
            SELECT parte_corpo_nome,
                COALESCE(parte_corpo_defesa_fisica_total, 0) AS defesa_fisica,
                COALESCE(parte_corpo_chance_acerto_critico, 0) AS chance_critico
            INTO parte_alvo
            FROM player_parte_corpo_info_view
            WHERE id_player = alvo.id
            ORDER BY random()
            LIMIT 1;
        ELSE
            SELECT cavaleiro_parte_corpo AS parte_corpo_nome,
                COALESCE(cavaleiro_defesa_fisica, 0) AS defesa_fisica,
                COALESCE(cavaleiro_chance_acerto_critico, 0) AS chance_critico
            INTO parte_alvo
            FROM cavaleiro_parte_corpo_info_view
            WHERE id_cavaleiro = alvo.id
            ORDER BY random()
            LIMIT 1;
        END IF;

        SELECT id_inimigo
        INTO enemy_id
        FROM instancia_inimigo
        WHERE id_instancia = p_id_instancia;

        SELECT COALESCE(ataque_fisico, 0)
        INTO dano_base
        FROM instancia_inimigo ii 
        WHERE id_inimigo = enemy_id;

        -- 5. Calcular o dano subtraindo a defesa física da parte atingida
        dano := dano_base - parte_alvo.defesa_fisica;
        IF dano < 0 THEN
            dano := 1;
        END IF;

        -- 6. Verificar se o ataque acerta de forma crítica
        critico := (random() * 100) < parte_alvo.chance_critico;
        IF critico THEN
            dano := dano * 1.5;
        END IF;

        RAISE NOTICE 'Inimigo (instância % ) atacou % na parte % de % causando % de dano!',
                    p_id_instancia, alvo.nome, parte_alvo.parte_corpo_nome, alvo.tipo, dano;

        -- 7. Depurar: mostrar o hp_atual do alvo antes do update
        IF alvo.tipo = 'player' THEN
            SELECT COALESCE(hp_atual, 0)
            INTO current_hp
            FROM player
            WHERE id_player = alvo.id;
            RAISE NOTICE 'DEBUG: Player % - hp_atual antes do update: %, dano a ser aplicado: %', 
                        alvo.nome, current_hp, dano;
            UPDATE player
            SET hp_atual = current_hp - dano
            WHERE id_player = alvo.id;
        ELSE
            SELECT COALESCE(hp_atual, 0)
            INTO current_hp
            FROM instancia_cavaleiro
            WHERE id_cavaleiro = alvo.id;
            RAISE NOTICE 'DEBUG: Cavaleiro % - hp_atual antes do update: %, dano a ser aplicado: %', 
                        alvo.nome, current_hp, dano;
            UPDATE instancia_cavaleiro
            SET hp_atual = current_hp - dano
            WHERE id_cavaleiro = alvo.id;
        END IF;
    END;
    $$ LANGUAGE plpgsql;

    CREATE EXTENSION IF NOT EXISTS pg_cron;

    CREATE OR REPLACE FUNCTION reviver_todos_boss()
    RETURNS VOID AS $$
    DECLARE
        num_updated INTEGER;
    BEGIN
        UPDATE boss
        SET hp_atual = hp_max
        WHERE hp_atual <= 0;
        
        GET DIAGNOSTICS num_updated = ROW_COUNT;
        
        RAISE NOTICE 'Todos os bosses foram ressuscitados (% registros atualizados).', num_updated;
    END;
    $$ LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION reviver_todas_instancia_inimigo()
    RETURNS VOID AS $$
    DECLARE
        num_updated INTEGER;
    BEGIN
        UPDATE instancia_inimigo AS ii
        SET hp_atual = i.hp_max
        FROM inimigo AS i
        WHERE i.id_inimigo = ii.id_inimigo and hp_atual <= 0;

        GET DIAGNOSTICS num_updated = ROW_COUNT;
        
        RAISE NOTICE 'Todas as instâncias de inimigo foram revividas (% registros atualizados).', num_updated;
    END;
    $$ LANGUAGE plpgsql;

    SELECT cron.schedule(
        'reviver_bosses_job',  
        '*/5 * * * *',        
        $$ SELECT reviver_todos_boss(); $$ ); 

    SELECT cron.schedule(
        'reviver_instancias_inimigo_job',
        '*/5 * * * *',
        $$ SELECT reviver_todas_instancia_inimigo(); $$
    );


    CREATE OR REPLACE FUNCTION usar_habilidade_player(
        p_id_player INTEGER,
        p_id_boss INTEGER,
        p_id_habilidade INTEGER
    ) RETURNS TEXT AS $$
    DECLARE
        v_custo_cosmo INTEGER;
        v_dano INTEGER;
        v_elemento INTEGER;
        v_hp_atual INTEGER;
        v_defesa_fisica_min INTEGER;
        v_defesa_magica_min INTEGER;
        v_cosmo_atual INTEGER;
        v_elemento_boss INTEGER;
        v_mensagem TEXT;
        v_multiplicador FLOAT := 1.0;
    BEGIN
        -- 📌 Buscar detalhes da habilidade
        SELECT custo, dano, elemento_habilidade
        INTO v_custo_cosmo, v_dano, v_elemento
        FROM habilidade
        WHERE id_habilidade = p_id_habilidade;

        -- 📌 Buscar o cosmo atual do player
        SELECT magia_atual INTO v_cosmo_atual
        FROM player
        WHERE id_player = p_id_player;

        -- ❌ Se não tiver cosmo suficiente, retorna erro
        IF v_cosmo_atual < v_custo_cosmo THEN
            RETURN '❌ Cosmo insuficiente para usar essa habilidade!';
        END IF;

        -- 📌 Buscar o elemento do boss
        SELECT id_elemento, hp_atual
        INTO v_elemento_boss, v_hp_atual
        FROM boss
        WHERE id_boss = p_id_boss;

        -- 📌 Buscar a menor defesa entre todas as partes do corpo do boss
        SELECT MIN(boss_defesa_fisica), MIN(boss_defesa_magica)
        INTO v_defesa_fisica_min, v_defesa_magica_min
        FROM boss_parte_corpo_info_view
        WHERE id_boss = p_id_boss;

        -- 📌 Ajustar dano baseado em fraqueza e vantagem elementar
        IF EXISTS (SELECT 1 FROM elemento WHERE id_elemento = v_elemento AND forte_contra = v_elemento_boss) THEN
            v_multiplicador := 1.5;  -- 🔥 Bônus por vantagem elemental
        ELSIF EXISTS (SELECT 1 FROM elemento WHERE id_elemento = v_elemento AND fraco_contra = v_elemento_boss) THEN
            v_multiplicador := 0.75; -- ❄️ Redução por fraqueza
        END IF;

        -- 📌 Calcular dano final com a menor defesa (habilidade mágica ou física)
        IF EXISTS (SELECT 1 FROM habilidade WHERE id_habilidade = p_id_habilidade AND classe_habilidade = 2) THEN
            v_dano := (v_dano - v_defesa_magica_min) * v_multiplicador;
        ELSE
            v_dano := (v_dano - v_defesa_fisica_min) * v_multiplicador;
        END IF;

        -- 🔥 Garante que o dano mínimo seja pelo menos 1
        IF v_dano < 1 THEN
            v_dano := 1;
        END IF;

        -- 📌 Atualiza o HP do boss após o dano
        UPDATE boss
        SET hp_atual = GREATEST(0, hp_atual - v_dano)
        WHERE id_boss = p_id_boss;

        -- 📌 Reduz o cosmo do player
        UPDATE player
        SET magia_atual = magia_atual - v_custo_cosmo
        WHERE id_player = p_id_player;

        -- 📌 Mensagem de retorno
        v_mensagem := FORMAT(
            '🔥 %s usou %s causando %s de dano! HP do Boss agora: %s',
            (SELECT nome FROM player WHERE id_player = p_id_player),
            (SELECT nome FROM habilidade WHERE id_habilidade = p_id_habilidade),
            v_dano, 
            (SELECT hp_atual FROM boss WHERE id_boss = p_id_boss)
        );

        -- 📌 Retornar mensagem para logs do jogo
        RETURN v_mensagem;
    END;
    $$ LANGUAGE plpgsql;


    CREATE OR REPLACE FUNCTION usar_habilidade_cavaleiro(
        p_id_cavaleiro INTEGER,
        p_id_boss INTEGER,
        p_id_habilidade INTEGER
    ) RETURNS TEXT AS $$
    DECLARE
        v_custo_cosmo INTEGER;
        v_dano INTEGER;
        v_elemento INTEGER;
        v_hp_atual INTEGER;
        v_defesa_fisica_min INTEGER;
        v_defesa_magica_min INTEGER;
        v_cosmo_atual INTEGER;
        v_elemento_boss INTEGER;
        v_mensagem TEXT;
        v_multiplicador FLOAT := 1.0;
    BEGIN
        -- 📌 Buscar detalhes da habilidade
        SELECT custo, dano, elemento_habilidade
        INTO v_custo_cosmo, v_dano, v_elemento
        FROM habilidade
        WHERE id_habilidade = p_id_habilidade;

        -- 📌 Buscar o cosmo atual do cavaleiro usando a view party_cavaleiros_view
        SELECT cavaleiro_magia_atual INTO v_cosmo_atual
        FROM party_cavaleiros_view
        WHERE id_cavaleiro = p_id_cavaleiro;

        -- ❌ Se não tiver cosmo suficiente, retorna erro
        IF v_cosmo_atual < v_custo_cosmo THEN
            RETURN '❌ Cosmo insuficiente para usar essa habilidade!';
        END IF;

        -- 📌 Buscar o elemento do boss e o HP atual
        SELECT id_elemento, hp_atual
        INTO v_elemento_boss, v_hp_atual
        FROM boss
        WHERE id_boss = p_id_boss;

        -- 📌 Buscar a menor defesa entre todas as partes do corpo do boss
        SELECT MIN(boss_defesa_fisica), MIN(boss_defesa_magica)
        INTO v_defesa_fisica_min, v_defesa_magica_min
        FROM boss_parte_corpo_info_view
        WHERE id_boss = p_id_boss;

        -- 📌 Ajustar dano baseado em fraqueza e vantagem elementar
        IF EXISTS (SELECT 1 FROM elemento WHERE id_elemento = v_elemento AND forte_contra = v_elemento_boss) THEN
            v_multiplicador := 1.5;  -- 🔥 Bônus por vantagem elemental
        ELSIF EXISTS (SELECT 1 FROM elemento WHERE id_elemento = v_elemento AND fraco_contra = v_elemento_boss) THEN
            v_multiplicador := 0.75; -- ❄️ Redução por fraqueza
        END IF;

        -- 📌 Calcular dano final utilizando a menor defesa
        IF EXISTS (SELECT 1 FROM habilidade WHERE id_habilidade = p_id_habilidade AND classe_habilidade = 2) THEN
            v_dano := (v_dano - v_defesa_magica_min) * v_multiplicador;
        ELSE
            v_dano := (v_dano - v_defesa_fisica_min) * v_multiplicador;
        END IF;

        -- 🔥 Garante que o dano mínimo seja pelo menos 1
        IF v_dano < 1 THEN
            v_dano := 1;
        END IF;

        -- 📌 Atualiza o HP do boss após o dano
        UPDATE boss
        SET hp_atual = GREATEST(0, hp_atual - v_dano)
        WHERE id_boss = p_id_boss;

        -- 📌 Reduz o cosmo do cavaleiro
        UPDATE instancia_cavaleiro
        SET magia_atual = magia_atual - v_custo_cosmo
        WHERE id_cavaleiro = p_id_cavaleiro;

        -- 📌 Cria a mensagem de retorno usando a view para obter o nome do cavaleiro
        v_mensagem := FORMAT(
            '🔥 %s usou %s causando %s de dano! HP do Boss agora: %s',
            (SELECT cavaleiro_nome FROM party_cavaleiros_view WHERE id_cavaleiro = p_id_cavaleiro),
            (SELECT nome FROM habilidade WHERE id_habilidade = p_id_habilidade),
            v_dano, 
            (SELECT hp_atual FROM boss WHERE id_boss = p_id_boss)
        );

        RETURN v_mensagem;
    END;
    $$ LANGUAGE plpgsql;
    ```
</details>

### V63_habilidade

Essa versão adiciona suporte ao uso de habilidades especiais pelos jogadores e cavaleiros. As funções permitem a execução de ataques mágicos ou físicos, adicionando maior profundidade estratégica às batalhas do jogo.

<details>
    <sumary> Migrações </sumary>

    ```sql
    CREATE OR REPLACE FUNCTION aprender_habilidade(player_id INT, cavaleiro_id INT, habilidade_id INT)
    RETURNS TEXT AS $$
    DECLARE
        classe_habilidade INT;
        elemento_habilidade INT;
        classe_cavaleiro INT;
        elemento_personagem INT;
        slots_ocupados INT;
    BEGIN
        -- Verifica se a habilidade existe
        SELECT h.classe_habilidade, h.elemento_habilidade INTO classe_habilidade, elemento_habilidade
        FROM habilidade h
        WHERE h.id_habilidade = habilidade_id;
        
        IF NOT FOUND THEN
            RETURN 'Habilidade não encontrada.';
        END IF;
        
        -- Verifica se está aprendendo para o player ou cavaleiro
        IF cavaleiro_id IS NULL THEN
            -- Player pode aprender qualquer habilidade do seu elemento
            SELECT id_elemento INTO elemento_personagem FROM player_info_view WHERE id_player = player_id;
            
            IF elemento_habilidade != elemento_personagem THEN
                RETURN 'O Player não pode aprender essa habilidade (elemento incompatível).';
            END IF;

            -- Verifica se já tem 4 habilidades
            SELECT COUNT(*) INTO slots_ocupados FROM habilidade_player WHERE id_player = player_id;
            
            IF slots_ocupados >= 4 THEN
                RAISE EXCEPTION 'O Player já tem 4 habilidades. Substitua uma para aprender.';
            END IF;
            
            -- Adiciona a nova habilidade
            INSERT INTO habilidade_player (id_player, id_habilidade, slot)
            VALUES (player_id, habilidade_id, slots_ocupados + 1);
            
            RETURN 'Habilidade aprendida com sucesso pelo Player.';
        
        ELSE
            -- Cavaleiro só pode aprender habilidades da sua classe e elemento
            SELECT elemento_id, classe_id INTO elemento_personagem, classe_cavaleiro
            FROM instancia_cavaleiro_view WHERE id_cavaleiro = cavaleiro_id;

            IF classe_habilidade != classe_cavaleiro OR elemento_habilidade != elemento_personagem THEN
                RAISE EXCEPTION 'O Cavaleiro não pode aprender essa habilidade (classe ou elemento incompatível).';
            END IF;
            
            -- Verifica se já tem 4 habilidades
            SELECT COUNT(*) INTO slots_ocupados FROM habilidade_cavaleiro WHERE id_cavaleiro = cavaleiro_id;
            
            IF slots_ocupados >= 4 THEN
                RAISE EXCEPTION 'O Cavaleiro já tem 4 habilidades. Substitua uma para aprender.';
            END IF;
            
            -- Adiciona a nova habilidade
            INSERT INTO habilidade_cavaleiro (id_cavaleiro, id_habilidade, slot)
            VALUES (cavaleiro_id, habilidade_id, slots_ocupados + 1);
            
            RETURN 'Habilidade aprendida com sucesso pelo Cavaleiro.';
        END IF;
    END $$ LANGUAGE plpgsql;


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

## Referência Bibliográfica

> [1] ELMASRI, Ramez; NAVATHE, Shamkant B. Sistemas de banco de dados. Tradução: Daniel Vieira. Revisão técnica: Enzo Seraphim; Thatyana de Faria Piola Seraphim. 6. ed. São Paulo: Pearson Addison Wesley, 2011.

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 11/12/2024 | Criação do Documento | [Vinícius Rufino](https://github.com/RufinoVfR) |
| 1.0 | 29/01/2025 | Melhoria do DQL | Lucas Dourado |
| 2.0 | 02/02/2025 | Atualização do Documento | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  2.0 | 03/02/2025 | Atualização do DQL | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  2.1 | 10/02/2025 | Atualização do DQL e Adição da Toggle List | [Vinícius Rufino](https://github.com/RufinoVfR) |
|  3.0 | 14/02/2025 | Atualização e refatoração do documento para versão final | [Vinícius Rufino](https://github.com/RufinoVfR) |