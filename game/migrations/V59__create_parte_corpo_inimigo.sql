CREATE TABLE public.parte_corpo_inimigo (
    id_instancia INT NOT NULL,
    id_inimigo INT NOT NULL,
    parte_corpo public."enum_parte_corpo" NOT NULL,
    defesa_fisica INT NOT NULL,
    defesa_magica INT NOT NULL,
    chance_acerto INT NOT NULL,
    chance_acerto_critico INT NOT NULL,
    PRIMARY KEY (id_instancia, id_inimigo, parte_corpo), -- Agora a chave primária é correta
    FOREIGN KEY (id_instancia, id_inimigo) REFERENCES public.instancia_inimigo(id_instancia, id_inimigo),
    FOREIGN KEY (parte_corpo) REFERENCES public.parte_corpo(id_parte_corpo)
);

