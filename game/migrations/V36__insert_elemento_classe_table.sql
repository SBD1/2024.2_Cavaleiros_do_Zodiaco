INSERT INTO Elemento (id_elemento, nome, descricao)
VALUES
  (1, 'Água', 'Flui e adapta-se, frequentemente usada para defesa e restrição de movimentos.'),
  (2, 'Fogo', 'Controla o calor e as chamas, usado frequentemente para atacar com intensidade.'),
  (3, 'Luz', 'Sólido e confiável, usado para defesa e ataques físicos.'),
  (4, 'Terra', 'Sólido e confiável, usado para defesa e ataques físicos.'),
  (5, 'Trevas', 'Sólido e confiável, usado para defesa e ataques físicos.'),
  (6, 'Trovão', 'Poderoso e chocante, usado para ataques elétricos rápidos e devastadores.'),
  (7, 'Vento', 'Rápido e inconstante, usado para movimentação rápida e ataques evasivos.');



UPDATE Elemento SET fraco_contra = 4, forte_contra = 2 WHERE id_elemento = 1;  -- Agua fraco contra Terra, forte contra Fogo
UPDATE Elemento SET fraco_contra = 1, forte_contra = 7 WHERE id_elemento = 2;  -- Fogo fraco contra Água, forte contra Vento
UPDATE Elemento SET fraco_contra = 0, forte_contra = 5 WHERE id_elemento = 3; -- Luz forte contra trevas mas sem desvantagens
UPDATE Elemento SET fraco_contra = 6, forte_contra = 1 WHERE id_elemento = 4; -- Terra fraco contra Trovão, forte contra Água
UPDATE Elemento SET fraco_contra = 3, forte_contra = 0 WHERE id_elemento = 5; -- Trevas fraco contra Luz, forte contra nada
UPDATE Elemento SET fraco_contra = 7, forte_contra = 4 WHERE id_elemento = 6; -- Trovão fraco contra Vento, forte contra Terra
UPDATE Elemento SET fraco_contra = 2, forte_contra = 6 WHERE id_elemento = 7; -- Vento fraco contra Fogo, forte contra Trovão

INSERT INTO Classe (nome, descricao)
VALUES
  ('Tank', 'O Tank é a muralha inabalável do grupo, projetado para absorver dano e proteger seus aliados. Com armaduras robustas e habilidades de provocação, ele garante que os inimigos mantenham o foco nele, permitindo que o restante do time lute em segurança.'),
  ('DPS', 'O DPS é o principal responsável por causar dano aos inimigos. Seja com ataques rápidos e precisos ou habilidades devastadoras, sua função é derrotar oponentes o mais rápido possível enquanto explora pontos fracos.'),
  ('Healer', 'O Healer é o sustentáculo do grupo, focado em manter os aliados vivos e fortalecidos. Suas habilidades de cura, purificação e suporte fazem dele uma classe essencial para enfrentar longas batalhas e chefes difíceis.');
