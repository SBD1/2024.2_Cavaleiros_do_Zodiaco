/* brModelo: */

CREATE TABLE Parte_Corpo_Boss (
    id_boss INTEGER,
    parte_corpo enum_parte_corpo,
    defesa_fisica INTEGER NOT NULL,
    defesa_magica INTEGER NOT NULL,
    chance_acerto INTEGER NOT NULL,
    chance_acerto_critico INTEGER NOT NULL,
    PRIMARY KEY (id_boss, parte_corpo)
);
 
ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_2
    FOREIGN KEY (id_boss)
    REFERENCES Boss (id_boss);
 
ALTER TABLE Parte_Corpo_Boss ADD CONSTRAINT FK_Parte_Corpo_Boss_3
    FOREIGN KEY (parte_corpo)
    REFERENCES Parte_Corpo (id_parte_corpo);

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

