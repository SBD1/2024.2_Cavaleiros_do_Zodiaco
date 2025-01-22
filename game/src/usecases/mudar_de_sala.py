from rich.panel import Panel
from ..database import obter_cursor
from .ver_salas_disponiveis import ver_salas_disponiveis
from ..database import obter_conexao
from .obter_nome_sala import obter_nome_sala

def mudar_de_sala(console, selected_player_id):
    """🚪 Permite ao jogador mudar de sala no jogo."""

    if selected_player_id is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🚫",
            title="⚠️ Ação Inválida",
            border_style="red"
        ))
        return

    # Exibir as salas disponíveis
    ver_salas_disponiveis(console, selected_player_id)
    console.print("\n📌 [bold cyan]Digite o ID da sala para a qual deseja se mover:[/bold cyan] ", end="")
    id_sala = input().strip()

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT mudar_sala(%s, %s);", (selected_player_id, int(id_sala)))
            obter_conexao().commit()  # Confirma a transação

            # Buscar o nome da sala para exibir no feedback
            nome_sala = obter_nome_sala(id_sala)
            if nome_sala:
                console.print(Panel.fit(
                    f"✅ [bold green]Movido com sucesso para a sala:[/bold green] [bold yellow]{nome_sala}[/bold yellow] 🏰",
                    title="🚀 Transição Concluída",
                    border_style="green"
                ))
            else:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Movido para a sala, mas o nome não foi encontrado.[/bold yellow]",
                    title="🔍 Sala Desconhecida",
                    border_style="yellow"
                ))

    except ValueError:
        console.print(Panel.fit(
            "❌ [bold red]O ID da sala deve ser um número válido![/bold red]",
            title="⛔ Entrada Inválida",
            border_style="red"
        ))
        return None
