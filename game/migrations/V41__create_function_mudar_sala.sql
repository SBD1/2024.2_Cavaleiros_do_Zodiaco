CREATE OR REPLACE FUNCTION public.mudar_sala(id_player_input INTEGER, id_sala_destino INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS $function$
DECLARE
    salas_conectadas INTEGER[];
BEGIN
    -- Obtém as salas conectadas
    SELECT ARRAY[
        s.id_sala_norte, 
        s.id_sala_sul, 
        s.id_sala_leste, 
        s.id_sala_oeste
    ]
    INTO salas_conectadas
    FROM public.sala s
    WHERE s.id_sala = (
        SELECT p.id_sala
        FROM public.party p
        WHERE p.id_player = id_player_input
        LIMIT 1
    );

    -- Verifica se a sala destino está nas salas conectadas
    IF id_sala_destino = ANY(salas_conectadas) THEN
        -- Atualiza a localização da party
        UPDATE public.party
        SET id_sala = id_sala_destino
        WHERE id_player = id_player_input;
    ELSE
        RAISE EXCEPTION 'Movimento inválido: A sala destino (%s) não está conectada.', id_sala_destino;
    END IF;
    
END;
$function$;
