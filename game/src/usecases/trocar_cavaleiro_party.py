from rich.console import Console
from rich.panel import Panel
from src.util import limpar_terminal
from .listar_cavaleiros_party import listar_cavaleiros_party

def trocar_cavaleiro_party(cursor, console, player_id):
    """Permite ao jogador trocar cavaleiros na party, garantindo o limite de 3 cavaleiros."""
    
    while True:  # Loop para manter a interação até o jogador sair
        # Obtém as informações sobre a party e os cavaleiros disponíveis
        limpar_terminal(console)
        party_options, fora_party_options = listar_cavaleiros_party(console, player_id)

        if not party_options or not fora_party_options:
            console.print(Panel.fit("[bold red]❌ Não há cavaleiros disponíveis para trocar![/bold red]", border_style="red"))
            return

        # Exibir cavaleiros da party
        console.print("\n[bold cyan]Escolha um cavaleiro para remover da party:[/bold cyan]")
        for idx, (_, _, nome) in enumerate(party_options, 1):
            console.print(f"{idx}. {nome}")

        try:
            # Escolha do cavaleiro para remover
            remover = int(input("\n🎯 Escolha o número do cavaleiro para remover: ").strip())

            if 1 <= remover <= len(party_options):
                cavaleiro_removido = party_options[remover - 1][1]

                # Exibir cavaleiros fora da party
                console.print("\n[bold cyan]Escolha um cavaleiro para adicionar à party:[/bold cyan]")
                for idx, (_, _, nome) in enumerate(fora_party_options, 1):
                    console.print(f"{idx}. {nome}")

                adicionar = int(input("\n🎯 Escolha o número do cavaleiro para adicionar: ").strip())

                if 1 <= adicionar <= len(fora_party_options):
                    cavaleiro_adicionado = fora_party_options[adicionar - 1][1]

                    # Chamar a procedure para trocar os cavaleiros
                    cursor.execute("CALL trocar_cavaleiro_party(%s, %s, %s);", (player_id, cavaleiro_adicionado, cavaleiro_removido))
                    cursor.connection.commit()

                    console.print(Panel.fit("[bold green]✅ Cavaleiro trocado com sucesso![/bold green]", border_style="green"))
                    console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
                    input()

                    # Atualiza a exibição após a modificação
                    break  # Sai do loop após a troca
                else:
                    console.print(Panel.fit("[bold red]❌ Escolha inválida![/bold red]", border_style="red"))
            else:
                console.print(Panel.fit("[bold red]❌ Escolha inválida![/bold red]", border_style="red"))

        except ValueError:
            console.print(Panel.fit("[bold red]❌ Entrada inválida! Digite um número válido.[/bold red]", border_style="red"))
            console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
            input()
