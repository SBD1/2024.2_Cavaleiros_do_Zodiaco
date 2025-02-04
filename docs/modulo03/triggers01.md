## Triggers

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 02/02/2025 | Criação do Documento | Vinícius Rufino |

### Inserir uma Party

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

### Instanciar uma Missão para o Player

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

    Sempre que for adicionada uma missão, todos os players terão uma instância nela

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

### Criar Inventário

```sql

CREATE OR REPLACE FUNCTION after_player_insert_function()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO inventario (id_player, dinheiro)
    VALUES (NEW.id_player, 200);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_player_insert
AFTER INSERT ON player
FOR EACH ROW
EXECUTE FUNCTION after_player_insert_function();

```

### Inserir o tipo de item e o tipo de missão

```sql

CREATE OR REPLACE FUNCTION before_insert_item_missao()
RETURNS TRIGGER AS $$
DECLARE
    new_id_item INTEGER;
BEGIN
    INSERT INTO tipo_item (tipo_item)
    VALUES ('i')
    RETURNING id_item INTO new_id_item;

    NEW.id_item := new_id_item;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER  before_insert_item_missao_trigger
BEFORE INSERT ON item_missao
FOR EACH ROW
EXECUTE FUNCTION  before_insert_item_missao();

```