INSERT INTO Elemento (id_elemento, nome, descricao)
VALUES
  (1, 'Fogo', 'Controla o calor e as chamas, usado frequentemente para atacar com intensidade.'),
  (2, 'Água', 'Flui e adapta-se, frequentemente usada para defesa e restrição de movimentos.'),
  (3, 'Terra', 'Sólido e confiável, usado para defesa e ataques físicos.'),
  (4, 'Vento', 'Rápido e inconstante, usado para movimentação rápida e ataques evasivos.'),
  (5, 'Trovão', 'Poderoso e chocante, usado para ataques elétricos rápidos e devastadores.');


UPDATE Elemento SET fraco_contra = 2, forte_contra = 3 WHERE id_elemento = 1;  -- Fogo fraco contra Água, forte contra Terra
UPDATE Elemento SET fraco_contra = 3, forte_contra = 1 WHERE id_elemento = 2;  -- Água fraca contra Terra, forte contra Fogo
UPDATE Elemento SET fraco_contra = 4, forte_contra = 5 WHERE id_elemento = 3; -- Terra fraca contra Vento, forte contra Trovão
UPDATE Elemento SET fraco_contra = 1, forte_contra = 3 WHERE id_elemento = 4; -- Vento fraco contra Fogo, forte contra Terra
UPDATE Elemento SET fraco_contra = 3, forte_contra = 2 WHERE id_elemento = 5; -- Trovão fraco contra Terra, forte contra Água

INSERT INTO Classe (nome, descricao)
VALUES
  ('Tank', 'O Tank é a muralha inabalável do grupo, projetado para absorver dano e proteger seus aliados. Com armaduras robustas e habilidades de provocação, ele garante que os inimigos mantenham o foco nele, permitindo que o restante do time lute em segurança.'),
  ('DPS', 'O DPS é o principal responsável por causar dano aos inimigos. Seja com ataques rápidos e precisos ou habilidades devastadoras, sua função é derrotar oponentes o mais rápido possível enquanto explora pontos fracos.'),
  ('Healer', 'O Healer é o sustentáculo do grupo, focado em manter os aliados vivos e fortalecidos. Suas habilidades de cura, purificação e suporte fazem dele uma classe essencial para enfrentar longas batalhas e chefes difíceis.');
