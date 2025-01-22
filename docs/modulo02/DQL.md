## DQL

### Versionamento

| Versão | Data | Modificação | Autor |
| --- | --- | --- | --- |
| 0.1 | 11/12/2023 | Criação do Documento | Vinícius Rufino |

```sql
-- 1. Listar informações do play
SELECT * FROM Player;
-- 2. Listar todos os items no inventár
SELECT * FROM Inventario;
-- 3. Listar todos os cavaleiros desbloquead
SELECT * FROM Cavaleiro;
-- 4. Escolher qual cavaleiro desbloqueado quer ver e listar todas
informações do cavaleiro
SELECT *
FROM Cavaleiro
WHERE id_cavaleiro = {id_cavaleiro};
-- 5. Mostrar em que sala o player es
SELECT id_sala
FROM Party
WHERE id_player = {id_player};
-- 6. Listar pras quais salas a partir da sala que o player está ele pode
SELECT id_sala_norte, id_sala_sul, id_sala_leste, id_sala_oeste
FROM Sala
WHERE id_sala = (SELECT id_sala FROM Party WHERE id_player
{id_player});
-- 7. Listar as habilidades do play
SELECT Habilidade.*
FROM Habilidade_Player
JOIN Habilidade ON Habilidade_Player.id_habilidade
Habilidade.id_habilidade
WHERE id_player = {id_player};
-- 8. Listar as habilidades dos cavaleiros desbloquead
SELECT Habilidade.*
SELECTs e Procedure to Insert 2
FROM Habilidade
JOIN Cavaleiro ON Habilidade.classe_habilidade Cavaleiro.id_classe
-- 9. Listar os cavaleiros na par
SELECT Cavaleiro.*
FROM Cavaleiro
JOIN Party ON Party.id_player = {id_player};
-- 10. Listar os items à ven
SELECT * FROM Item_a_venda;
-- 11. Listar as armaduras equipadas nas partes do corpo do play
SELECT Parte_Corpo_Player.
, Armadura.
FROM Parte_Corpo_Player
JOIN Armadura ON Parte_Corpo_Player.armadura_equipada
Armadura.id_armadura
WHERE id_player = {id_player};
-- 12. Listar qual cavaleiro é desbloqueado ao derrotar certo bo
SELECT Progresso_Player.id_cavaleiro, Boss.nome
FROM Progresso_Player
JOIN Boss ON Progresso_Player.id_boss Boss.id_bos
WHERE Progresso_Player.status_derrotado TRUE
-- 13. Listar quais os inimigos que estão no grupo_inimigo e em qual sa
SELECT Inimigo., Grupo_inimigo.id_sala
FROM Grupo_inimigo
JOIN Inimigo ON Grupo_inimigo.id_grupo Inimigo.id_classe
-- 14. Listar habilidades do bo
SELECT Habilidade.
FROM Habilidade_Boss
JOIN Habilidade ON Habilidade_Boss.id_habilidade Habilidade.id_habilidad
WHERE Habilidade_Boss.id_boss = {id_boss};
-- 15. Listar habilidades disponíveis para cavaleiro aprender de acordo c
seu nível, classe e elemento
SELECT Habilidade.*
FROM Habilidade
SELECTs e Procedure to Insert 3
JOIN Cavaleiro ON Habilidade.classe_habilidade Cavaleiro.id_classe AN
Habilidade.elemento_habilidade Cavaleiro.id_element
WHERE Habilidade.nivel_necessario = Cavaleiro.nive
-- 16. Listar todos os Boss de um santuário escolhido pelo jogador e o stat
(se está derrotado ou não)
SELECT Boss.*, Progresso_Player.status_derrotado
FROM Boss
JOIN Sala ON Boss.id_sala Sala.id_sal
JOIN Casa ON Sala.id_casa Casa.id_cas
JOIN Santuario ON Casa.id_santuario Santuario.id_santuari
WHERE Santuario.id_santuario = {id_santuario};
CREATE OR REPLACE PROCEDURE insert_item(
id_item INTEGER,
tipo_item ENUM_tipo_item
) AS $
BEGIN
INSERT INTO Tipo_Item (id_item, tipo_item) VALUES (id_item, tipo_item);
END;
$$ LANGUAGE plpgsql;
-- Exemplo de uso
CALL insert_item(1, 'a');
```