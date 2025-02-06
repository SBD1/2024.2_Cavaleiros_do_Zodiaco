from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

console = Console()

def obter_status_jogador(player_id):
    """📜 Obtém e exibe o status do jogador com formatação aprimorada."""

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT * FROM get_player_info_v2(%s);", (player_id,))
            result = cursor.fetchone()
            
            if result:
                # Desempacotamento dos dados
                (nome, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual,
                 velocidade, ataque_fisico, ataque_magico, elemento) = result

                # Criando a tabela estilizada para os atributos do jogador
                table = Table(title=f"⚔️ Status de {nome}", border_style="blue")

                table.add_column("Atributo", style="bold cyan")
                table.add_column("Valor", style="bold yellow")

                table.add_row("📛 Nome", f"{nome}")
                table.add_row("📊 Nível", f"{nivel}")
                table.add_row("✨ XP Atual", f"{xp_atual}")
                table.add_row("❤️ HP Máximo", f"{hp_max}")
                table.add_row("🔮 Magia Máxima", f"{magia_max}")
                table.add_row("💖 HP Atual", f"{hp_atual}")
                table.add_row("🌀 Magia Atual", f"{magia_atual}")
                table.add_row("⚡ Velocidade", f"{velocidade}")
                table.add_row("💥 Ataque Físico ", f"{ataque_fisico}")
                table.add_row("🔥 Ataque Mágico ", f"{ataque_magico}")
                table.add_row("🌟 Elemento", f"{elemento}")

                console.print(table)

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
