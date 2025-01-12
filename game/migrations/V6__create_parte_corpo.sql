DROP TYPE parte_corpo;
DROP TYPE tipo_item;

CREATE TYPE enum_tipo_item as ENUM ('a', 'm', 'i', 'c', 'l'); /* a = armadura, m = material, i = item_missao, c = consumivel, l = livro */
CREATE TYPE enum_parte_corpo as ENUM ('c', 't', 'b', 'p'); /* c = cabeça, t = tronco, b = braços, p = pernas */

CREATE TABLE Parte_Corpo (
    id_parte_corpo enum_parte_corpo PRIMARY KEY,
    nome VARCHAR NOT NULL,
    defesa_magica INTEGER NOT NULL,
    defesa_fisica INTEGER NOT NULL,
    chance_acerto INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL
);