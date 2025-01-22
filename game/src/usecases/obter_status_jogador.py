from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from ..database import obter_cursor

console = Console()

def obter_status_jogador(player_id):
    """📜 Obtém e exibe o status do jogador com formatação aprimorada."""
    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT get_player_info(%s);", (player_id,))
            result = cursor.fetchone()
            
            if result and result[0]:
                status_linhas = result[0].split("\n")  # Divide os atributos por linha

                # Monta o painel estilizado com cada atributo formatado
                detalhes = "\n".join([f"🔹 {linha}" for linha in status_linhas])

                console.print(Panel.fit(
                    Text(detalhes, style="bold cyan"),
                    title=f"⚔️ Status do Jogador {player_id} ⚔️",
                    border_style="blue",
                ))

            else:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Não foi possível recuperar o status do jogador.[/bold yellow]",
                    title="⛔ Erro",
                    border_style="yellow"
                ))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao obter status do jogador:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
