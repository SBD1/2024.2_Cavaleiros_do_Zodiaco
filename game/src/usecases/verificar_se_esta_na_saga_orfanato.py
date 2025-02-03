from ..database import obter_cursor

def verificar_se_esta_na_saga_orfanato(jogador_selecionado_id):
    """Verifica se o jogador está atualmente na saga segura (Orfanato)."""
    if jogador_selecionado_id is None:
        return False  # Nenhum jogador selecionado

    try:
        with obter_cursor() as cursor:
            # Obter a saga atual do jogador
            cursor_name = "get_saga_atual"
            cursor.connection.autocommit = False  
            cursor.execute("CALL get_saga_atual(%s, %s);", (jogador_selecionado_id, cursor_name))
            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            saga_atual = cursor.fetchone()
            cursor.execute(f"CLOSE {cursor_name};")
            cursor.connection.commit()
            


            cursor_name = "get_saga_safe"
            cursor.connection.autocommit = False  
            cursor.execute("CALL get_saga_segura(%s, %s);", (jogador_selecionado_id, cursor_name))
            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            saga_segura = cursor.fetchone()
            cursor.execute(f"CLOSE {cursor_name};")
            cursor.connection.commit()
            

            if saga_atual and saga_segura and saga_atual[0] == saga_segura[0]:
                return True  # Jogador está no Orfanato
            return False
    except Exception as e:
        print(f"Erro ao verificar saga segura: {e}")
        return False
