CREATE TABLE public.parte_corpo_inimigo (
	id_inimigo int4 NOT NULL,
	parte_corpo public."enum_parte_corpo" NOT NULL,
	defesa_fisica int4 NOT NULL,
	defesa_magica int4 NOT NULL,
	chance_acerto_base int4 NOT NULL,
	chance_acerto_critico int4 NOT NULL,
	CONSTRAINT parte_corpo_inimigo_pkey PRIMARY KEY (id_inimigo, parte_corpo)
);


-- public.parte_corpo_inimigo foreign keys

ALTER TABLE public.parte_corpo_inimigo ADD CONSTRAINT fk_parte_corpo_inimigo_2 FOREIGN KEY (id_inimigo) REFERENCES public.inimigo(id_inimigo);
ALTER TABLE public.parte_corpo_inimigo ADD CONSTRAINT fk_parte_corpo_inimigo_3 FOREIGN KEY (parte_corpo) REFERENCES public.parte_corpo(id_parte_corpo);