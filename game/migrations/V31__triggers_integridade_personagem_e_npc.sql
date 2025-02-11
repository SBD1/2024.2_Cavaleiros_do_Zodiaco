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



-- Criar a função para inserir em Tipo_NPC antes de inserir em Ferreiro, Mercador ou Quest
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
