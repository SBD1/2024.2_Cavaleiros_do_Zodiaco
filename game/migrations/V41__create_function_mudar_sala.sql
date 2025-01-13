CREATE OR REPLACE FUNCTION public.mudar_sala(id_player_input INTEGER, direcao TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $function$
DECLARE
    nova_sala_id INTEGER;
BEGIN
    -- Verifica a sala conectada na direção especificada
    SELECT CASE LOWER(direcao)
        WHEN 'norte' THEN s.id_sala_norte
        WHEN 'sul'   THEN s.id_sala_sul
        WHEN 'leste' THEN s.id_sala_leste
        WHEN 'oeste' THEN s.id_sala_oeste
        ELSE NULL
    END INTO nova_sala_id
    FROM public.sala s
    JOIN public.party p ON p.id_sala = s.id_sala
    WHERE p.id_player = id_player_input;

    -- Verifica se a sala existe e atualiza a localização da party
    IF nova_sala_id IS NOT NULL THEN
        UPDATE public.party
        SET id_sala = nova_sala_id
        WHERE id_player = id_player_input;
    ELSE
        RAISE NOTICE 'Movimento inválido: Não há sala conectada nessa direção.';
    END IF;
END;
$function$;