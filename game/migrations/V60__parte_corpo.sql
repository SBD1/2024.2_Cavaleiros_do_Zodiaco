CREATE OR REPLACE FUNCTION gerar_partes_corpo_boss()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.parte_corpo_boss (id_boss, parte_corpo, defesa_fisica, defesa_magica, chance_acerto_base, chance_acerto_critico)
    SELECT 
        NEW.id_boss,                     
        pc.id_parte_corpo,               
        pc.defesa_fisica * 2,           
        pc.defesa_magica * 2,           
        pc.chance_acerto * 2,            
        pc.chance_acerto_critico * 2     
    FROM public.parte_corpo pc;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_gerar_partes_corpo_boss
AFTER INSERT ON public.boss
FOR EACH ROW
EXECUTE FUNCTION gerar_partes_corpo_boss();

CREATE OR REPLACE FUNCTION gerar_partes_corpo_cavaleiro()
RETURNS TRIGGER AS $$
BEGIN
   
    INSERT INTO public.parte_corpo_cavaleiro (
        id_cavaleiro, 
        parte_corpo, 
        id_instancia_cavaleiro, 
        id_player, 
        defesa_fisica_bonus, 
        defesa_magico_bonus, 
        chance_acerto_base, 
        chance_acerto_critico
    )
    SELECT 
        NEW.id_cavaleiro,        
        pc.id_parte_corpo,        
        NEW.id_instancia_cavaleiro, 
        NEW.id_player,            
        pc.defesa_fisica,          
        pc.defesa_magica,         
        pc.chance_acerto,          
        pc.chance_acerto_critico   
    FROM public.parte_corpo pc;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gerar_partes_corpo_cavaleiro
AFTER INSERT ON public.instancia_cavaleiro
FOR EACH ROW
EXECUTE FUNCTION gerar_partes_corpo_cavaleiro();

CREATE OR REPLACE FUNCTION gerar_partes_corpo_player()
RETURNS TRIGGER AS $$
BEGIN
    
    INSERT INTO public.parte_corpo_player (
        id_player, 
        parte_corpo, 
        armadura_equipada, 
        instancia_armadura_equipada
    )
    SELECT 
        NEW.id_player,   
        pc.id_parte_corpo, 
        NULL,             
        NULL              
    FROM public.parte_corpo pc;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gerar_partes_corpo_player
AFTER INSERT ON public.player
FOR EACH ROW
EXECUTE FUNCTION gerar_partes_corpo_player();

INSERT INTO public.parte_corpo_player (id_player, parte_corpo, armadura_equipada, instancia_armadura_equipada)
SELECT 
    p.id_player,        
    pc.id_parte_corpo,   
    NULL,                
    NULL                 
FROM public.player p
CROSS JOIN public.parte_corpo pc
WHERE NOT EXISTS (
    SELECT 1 FROM public.parte_corpo_player pp WHERE pp.id_player = p.id_player AND pp.parte_corpo = pc.id_parte_corpo
);
