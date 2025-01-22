from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from ..database import obter_cursor
from .listar_jogadores import listar_jogadores  

console = Console()

def selecionar_jogador():
    """🎮 Permite ao usuário selecionar um jogador pelo nome e retorna o ID."""
    
    listar_jogadores()
    
    nome_jogador = Prompt.ask("\n🛡️ Digite o nome do jogador que deseja selecionar").strip()

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT id_player FROM player WHERE nome = %s;", (nome_jogador,))
            resultado = cursor.fetchone()
            
            if resultado:
                console.print(Panel.fit(
                    f"✅ [bold green]Jogador [cyan]{nome_jogador}[/cyan] selecionado com sucesso![/bold green] 🏆",
                    title="🎯 Sucesso",
                    border_style="green"
                ))
                return resultado[0]  # Retorna o ID do jogador selecionado
            else:
                console.print(Panel.fit(
                    f"⚠️ [bold yellow]Jogador '{nome_jogador}' não encontrado.[/bold yellow] 🛑",
                    title="🔍 Erro",
                    border_style="yellow"
                ))
                return None

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao selecionar jogador:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
        return None
