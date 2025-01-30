from ..database import obter_cursor

def verificar_se_esta_no_orfanato(jogador_selecionado_id):
    """Verifica se o jogador está atualmente na sala segura (Orfanato)."""
    if jogador_selecionado_id is None:
        return False  # Nenhum jogador selecionado

    try:
        with obter_cursor() as cursor:
            # Obter a sala atual do jogador
            cursor.execute("SELECT id_sala FROM public.party WHERE id_player = %s;", (jogador_selecionado_id,))
            sala_atual = cursor.fetchone()

            # Obter a sala segura (Orfanato)
            cursor.execute("SELECT id_sala FROM public.sala_segura LIMIT 1;")
            sala_segura = cursor.fetchone()

            if sala_atual and sala_segura and sala_atual[0] == sala_segura[0]:
                return True  # Jogador está no Orfanato
            return False
    except Exception as e:
        print(f"Erro ao verificar sala segura: {e}")
        return False
