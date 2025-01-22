from ..database import obter_cursor
from rich.panel import Panel
from rich.console import Console

def exibir_introducao(console: Console):
    """Exibe o texto da introdução do jogo buscando no banco de dados."""
    
    try:
        with obter_cursor() as cursor:
            # Consulta o texto com nome_texto = 'introducao'
            cursor.execute("SELECT texto FROM public.texto WHERE nome_texto = %s;", ('introducao',))
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                introducao = resultado[0]

                # Criando um painel estilizado para a introdução
                painel = Panel(
                    f"[bold yellow]📜 Introdução:[/bold yellow]\n\n[italic cyan]{introducao}[/italic cyan]",
                    title="✨ [bold magenta]Cavaleiros do Zodíaco[/bold magenta] ✨",
                    border_style="bright_magenta"
                )
                console.print(painel)
            else:
                console.print("[bold red]❌ Introdução não encontrada no banco de dados.[/bold red]")
    
    except Exception as e:
        console.print(f"[bold red]⚠️ Erro ao buscar introdução: {e}[/bold red]")
