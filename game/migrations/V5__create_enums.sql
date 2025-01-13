CREATE TYPE enum_tipo_item as ENUM ('a', 'm', 'i', 'c', 'l'); /* a = armadura, m = material, i = item_missao, c = consumivel, l = livro */
CREATE TYPE enum_parte_corpo as ENUM ('c', 't', 'b', 'p'); /* c = cabeça, t = tronco, b = braços, p = pernas */
CREATE TYPE enum_status_missao as ENUM ('c','i','ni'); /* c = completo, i=iniciado,ni=não iniciado*/