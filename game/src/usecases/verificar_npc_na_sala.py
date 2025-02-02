from ..database import obter_cursor

def verificar_npc_na_sala(jogador_id):
    """Verifica se há um NPC (Ferreiro, Mercador ou Quest) na sala atual do jogador."""
    if jogador_id is None:
        return None  # Nenhum jogador selecionado

    try:
        with obter_cursor() as cursor:
            # Chamar a função SQL para verificar NPC na sala
            cursor.execute("SELECT verificar_npc_na_sala(%s);", (jogador_id,))
            tipo_npc = cursor.fetchone()

            if tipo_npc and tipo_npc[0] is not None:
                return tipo_npc[0]  # Retorna o tipo do NPC encontrado
            return None  # Nenhum NPC encontrado
    except Exception as e:
        print(f"Erro ao verificar NPC na sala: {e}")
        return None
