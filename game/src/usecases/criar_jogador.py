from rich.console import Console
from rich.panel import Panel
from ..database import obter_cursor

def criar_jogador(nome_cdz: str):
    """🎮 Cria um novo jogador no banco de dados."""

    console = Console()

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT insert_cdz_player(%s);", (nome_cdz,))
            
            console.print(Panel.fit(
                f"✅ [bold green]Jogador '{nome_cdz}' criado com sucesso![/bold green] 🎉",
                title="🏆 Novo Cavaleiro Criado!",
                border_style="green"
            ))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao criar jogador:[/bold red] {e}",
            title="⚠️ Erro",
            border_style="red"
        ))
from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from ..database import obter_cursor

def criar_jogador(console: Console):
    """🎮 Cria um novo jogador no banco de dados solicitando o nome ao usuário."""

    # Exibe painel de entrada
    console.print(Panel(
        Text("Digite o nome do novo cavaleiro:", style="bold cyan"),
        title="📝 Criação de Jogador",
        border_style="blue",
        expand=False
    ))

    nome_cdz = input("🎭 Nome do cavaleiro: ").strip()

    if not nome_cdz:
        console.print(Panel(
            Text("❌ Nome inválido! O nome do cavaleiro não pode estar vazio.", style="bold red"),
            title="⚠️ Erro",
            border_style="red",
            expand=False
        ))
        return

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT insert_cdz_player(%s);", (nome_cdz,))

        console.print(Panel(
            Text(f"✅ Jogador '{nome_cdz}' criado com sucesso! 🎉", style="bold green"),
            title="🏆 Novo Cavaleiro Criado!",
            border_style="green",
            expand=False
        ))

    except Exception as e:
        console.print(Panel(
            Text(f"❌ Erro ao criar jogador: {e}", style="bold red"),
            title="⚠️ Erro",
            border_style="red",
            expand=False
        ))
