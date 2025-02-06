-- Criar a função para inserir em Tipo_Personagem antes de inserir em Player
CREATE OR REPLACE FUNCTION inserir_tipo_personagem()
RETURNS TRIGGER AS $$
DECLARE
    v_id_personagem INTEGER;
BEGIN
    -- Inserir em Tipo_Personagem e capturar o id_personagem gerado
    INSERT INTO Tipo_Personagem (tipo_personagem)
    VALUES ('p') -- Aqui pode ser alterado para dinamizar conforme o tipo
    RETURNING id_personagem INTO v_id_personagem;

    -- Atribuir o ID gerado ao campo id_player de Player
    NEW.id_player := v_id_personagem;

    -- Retornar a nova linha para completar a inserção em Player
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar a trigger associada
CREATE TRIGGER trigger_inserir_tipo_personagem
BEFORE INSERT ON Player
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
