from ..database import obter_cursor

def verificar_se_esta_na_saga_orfanato(jogador_selecionado_id):
    """Verifica se o jogador está atualmente na saga segura (Orfanato)."""
    if jogador_selecionado_id is None:
        return False  # Nenhum jogador selecionado

    try:
        with obter_cursor() as cursor:
            # Obter a saga atual do jogador
            cursor.execute("""
                SELECT sa.id_saga
                FROM public.party AS p
                JOIN public.sala AS s ON p.id_sala = s.id_sala
                JOIN public.casa AS c ON s.id_casa = c.id_casa
                JOIN public.saga AS sa ON c.id_saga = sa.id_saga
                WHERE p.id_player = %s;
            """, (jogador_selecionado_id,))
            saga_atual = cursor.fetchone()


            cursor.execute("""
                SELECT sa.id_saga, c.id_casa
                FROM public.sala_segura AS ss
                JOIN public.sala AS s ON ss.id_sala = s.id_sala
                JOIN public.casa AS c ON s.id_casa = c.id_casa
                JOIN public.saga AS sa ON c.id_saga = sa.id_saga
                LIMIT 1;
            """)
            saga_segura = cursor.fetchone()

            if saga_atual and saga_segura and saga_atual[0] == saga_segura[0]:
                return True  # Jogador está no Orfanato
            return False
    except Exception as e:
        print(f"Erro ao verificar saga segura: {e}")
        return False
