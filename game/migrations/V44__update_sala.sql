UPDATE public.sala 
SET id_sala_norte = NULL, 
    id_sala_sul = NULL, 
    id_sala_leste = NULL, 
    id_sala_oeste = NULL;

UPDATE public.sala SET id_sala_norte = 2 WHERE id_sala = 1;
UPDATE public.sala SET id_sala_sul = 1 WHERE id_sala = 2;

UPDATE public.sala SET id_sala_norte = 1 WHERE id_sala = 3;
UPDATE public.sala SET id_sala_sul = 3 WHERE id_sala = 1;

UPDATE public.sala SET id_sala_norte = 5 WHERE id_sala = 4;
UPDATE public.sala SET id_sala_sul = 4 WHERE id_sala = 5;

UPDATE public.sala SET id_sala_norte = 8 WHERE id_sala = 7;
UPDATE public.sala SET id_sala_sul = 7 WHERE id_sala = 8;

UPDATE public.sala SET id_sala_oeste = 5 WHERE id_sala_leste = 6;
UPDATE public.sala SET id_sala_leste = 6 WHERE id_sala_oeste = 5;

UPDATE public.sala SET id_sala_oeste = 5 WHERE id_sala_leste = 7;
UPDATE public.sala SET id_sala_leste = 7 WHERE id_sala_oeste = 5;
