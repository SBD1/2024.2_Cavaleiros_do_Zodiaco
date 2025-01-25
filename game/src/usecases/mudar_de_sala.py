from rich.panel import Panel
from ..database import obter_cursor
from .ver_salas_disponiveis import ver_salas_disponiveis
from ..database import obter_conexao
from .obter_nome_sala import obter_nome_sala

def mudar_de_sala(console, selected_player_id):
    """🚪 Permite ao jogador mudar de sala com base na direção (Norte, Sul, Leste, Oeste)."""

    if selected_player_id is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🚫",
            title="⚠️ Ação Inválida",
            border_style="red"
        ))
        return

    # Exibir as salas disponíveis
    ver_salas_disponiveis(console, selected_player_id)

    console.print("\n📌 [bold cyan]Digite a direção para a qual deseja se mover (Norte, Sul, Leste, Oeste):[/bold cyan] ", end="")
    direcao = input().strip().capitalize()

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT id_sala FROM get_salas_conectadas(%s) WHERE direcao = %s;", 
                           (selected_player_id, direcao))
            sala_destino = cursor.fetchone()

            if sala_destino is None:
                console.print(Panel.fit(
                    "❌ [bold red]Direção inválida! Escolha uma das direções disponíveis.[/bold red]",
                    title="⛔ Movimento Inválido",
                    border_style="red"
                ))
                return

            id_sala_destino = sala_destino[0]

            cursor.execute("SELECT mudar_sala(%s, %s);", (selected_player_id, id_sala_destino))
            obter_conexao().commit()  # Confirma a transação

            # Buscar o nome da sala para exibir no feedback
            nome_sala = obter_nome_sala(id_sala_destino)
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

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao tentar mudar de sala:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
