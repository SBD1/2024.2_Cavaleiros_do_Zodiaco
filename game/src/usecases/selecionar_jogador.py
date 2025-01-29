from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from ..database import obter_cursor
from .listar_jogadores import listar_jogadores  
import time

console = Console()

def selecionar_jogador():
    """🎮 Permite ao usuário selecionar um jogador pelo nome e retorna o ID."""
    
    listar_jogadores()
    
    id_jogador = Prompt.ask("\n🛡️ Digite o número do jogador que deseja selecionar").strip()

    try:
        with obter_cursor() as cursor:
            try:
                cursor.execute("SELECT nome,id_player FROM player WHERE id_player = %s;", (id_jogador,))
                nome_jogador = cursor.fetchone()
            except:
                console.print(Panel.fit(
                f"❌ [bold red]Digite um número de jogador válido[/bold red]\n",
                title="⛔ Número de jogador inválido.",
                border_style="red"
                ))
                time.sleep(2)
                return
                
            
            
            if nome_jogador:
                console.print(Panel.fit(
                    f"✅ [bold green]Jogador [cyan]{nome_jogador}[/cyan] selecionado com sucesso![/bold green] 🏆",
                    title="🎯 Sucesso",
                    border_style="green"
                ))
                return nome_jogador # Retorna o ID do jogador selecionado
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
