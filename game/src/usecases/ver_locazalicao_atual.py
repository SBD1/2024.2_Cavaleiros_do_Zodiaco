from rich.console import Console
from rich.panel import Panel
from ..database import obter_cursor

def ver_localizacao_atual(console, selected_player_id):
    """🏰 Exibe a localização do jogador (Saga atual, Casa atual e Sala atual) com estilo e feedback visual."""

    if selected_player_id is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🛑",
            title="⚠️ Aviso",
            border_style="red"
        ))
        return

    try:
        with obter_cursor() as cursor:
            # Iniciar uma transação explícita para gerenciar os cursores
            cursor.execute("BEGIN;")
            
            # Buscar a Saga atual
            cursor.execute("CALL get_saga_atual(%s, 'saga_cursor');", (selected_player_id,))
            cursor.execute("FETCH ALL FROM saga_cursor;")
            saga_resultado = cursor.fetchone()  # Retorna uma linha
            cursor.execute("CLOSE saga_cursor;")
            
            saga_atual = saga_resultado[1] if saga_resultado else "Desconhecida"

            # Buscar a Casa atual
            cursor.execute("CALL get_casa_atual(%s, 'casa_cursor');", (selected_player_id,))
            cursor.execute("FETCH ALL FROM casa_cursor;")
            casa_resultado = cursor.fetchone()  # Retorna uma linha
            cursor.execute("CLOSE casa_cursor;")
            
            casa_atual = casa_resultado[1] if casa_resultado else "Desconhecida"

            # Buscar a Sala atual
            cursor.execute("SELECT * FROM get_sala_atual(%s);", (selected_player_id,))
            sala_resultado = cursor.fetchone()  # Retorna (id_sala, nome_sala)

            if sala_resultado:
                sala_atual_id, sala_atual_nome = sala_resultado
                sala_atual = sala_atual_nome  
            else:
                sala_atual = "Desconhecida"

            # Buscar a Sala Segura
            cursor_name = "get_saga_safe"
            cursor.connection.autocommit = False  
            cursor.execute("CALL get_saga_segura(%s, %s);", (selected_player_id, cursor_name))
            cursor.execute(f"FETCH ALL FROM {cursor_name};")
            sala_segura_result = cursor.fetchone()
            cursor.execute(f"CLOSE {cursor_name};")
            cursor.connection.commit()
            saga_segura = sala_segura_result[1] if sala_segura_result else None

            # Commit da transação
            cursor.execute("COMMIT;")

            # Exibir a localização completa, apenas se a sala atual não for a segura
            if saga_atual != saga_segura:
                console.print(Panel.fit(
                    f"📖 [bold]Saga Atual:[/bold] {saga_atual}\n"
                    f"🏠 [bold]Casa Atual:[/bold] {casa_atual}\n"
                    f"📍 [bold]Sala Atual:[/bold] {sala_atual}",
                    title="🌍 Localização do Jogador",
                    border_style="cyan"
                ))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao buscar a localização do jogador:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
