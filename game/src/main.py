from services.personagem_service import PersonagemService
from rich.console import Console
from rich.table import Table
import random

def main():
    service = PersonagemService()
    console = Console()

    personagens = service.listar_personagens()

    if not personagens:
        console.print("[bold red]Nenhum personagem cadastrado![/bold red]")
        return

    table = Table(title="Personagens e Golpes dos Cavaleiros do Zodíaco", style="bold blue")
    table.add_column("ID", justify="center", style="cyan", no_wrap=True)
    table.add_column("Nome", style="magenta")
    table.add_column("Golpe", style="green")
    table.add_column("Elemento", style="yellow")

    golpes_cdz = [
        {"golpe": "Meteoro de Pegasus", "elemento": "⚡ Raio"},
        {"golpe": "Pó de Diamante", "elemento": "❄️ Gelo"},
    ]

    for id_personagem, nome in personagens:
        if id_personagem == 1:
            golpe = golpes_cdz[0]
        else:
            golpe = golpes_cdz[1]
            
        table.add_row(str(id_personagem), nome, golpe["golpe"], golpe["elemento"])

    console.print(table)

if __name__ == "__main__":
    main()
