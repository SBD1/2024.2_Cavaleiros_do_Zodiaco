## Triggers



### Inserir uma Party

Automatiza a criação de uma Party para cada novo jogador, garantindo que ele seja alocado em uma sala segura

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

Garante que todos os jogadores tenham acesso a todas as missões disponíveis no momento de sua criação

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

### Sempre que for adicionada uma missão, todos os players terão uma instância nela

Mantém a consistência do sistema, garantindo que todos os jogadores tenham acesso às novas missões adicionadas.

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

Automatiza a criação de um inventário para cada novo jogador, garantindo que ele comece com recursos básicos.

Garante que todos os jogadores tenham acesso a todas as missões disponíveis no momento de sua criação.

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

Garante que cada item de missão tenha um tipo de item associado, mantendo a integridade dos dados.

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

### Resumo dos Triggers

| Trigger                          | Tabela Afetada   | Evento         | Função                                                                 |
|----------------------------------|------------------|----------------|------------------------------------------------------------------------|
| `trigger_insert_party`           | `Party`          | `AFTER INSERT` | Cria uma `Party` para um novo jogador.                                |
| `instanciar_player_missao`       | `Player_missao`  | `AFTER INSERT` | Associa todas as missões existentes a um novo jogador.                |
| `instancia_player_missao_new_missoes` | `Player_missao`  | `AFTER INSERT` | Associa uma nova missão a todos os jogadores existentes.              |
| `after_player_insert`            | `inventario`     | `AFTER INSERT` | Cria um inventário para um novo jogador.                              |
| `before_insert_item_missao_trigger` | `item_missao`    | `BEFORE INSERT`| Cria um tipo de item e o associa a um novo item de missão.            |

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 02/02/2025 | Criação do Documento | Vinícius Rufino |
| 1.0 | 03/02/2025 | Atualização do Módulo 03 | Vinícius Rufino |