CREATE TYPE enum_tipo_item as ENUM ('c','nc'); /* c = craftavel, nc = nao craftavel */
CREATE TYPE enum_craftavel as ENUM ('a', 'm'); /* a = armadura, m = material */
CREATE TYPE enum_nao_craftavel as ENUM ('i', 'c', 'l'); /* i = item_missao, c = consumivel, l = livro */
CREATE TYPE enum_parte_corpo as ENUM ('c', 't', 'b', 'p'); /* c = cabeça, t = tronco, b = braços, p = pernas */
CREATE TYPE enum_status_missao as ENUM ('c','i','ni'); /* c = completo, i=iniciado,ni=não iniciado*/
CREATE TYPE enum_tipo_npc as ENUM ('f','m','q'); /* f = ferreiro , m = mercaador , q = quest */
