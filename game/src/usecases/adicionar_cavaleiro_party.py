from rich.console import Console
from rich.panel import Panel
from src.util import limpar_terminal
from .listar_cavaleiros_party import listar_cavaleiros_party

def adicionar_cavaleiro_party(cursor, console, player_id):
    """Permite ao jogador adicionar um cavaleiro na party, removendo um existente se necessário."""
    
    while True:  # Loop para manter a interação até o jogador sair
        # Obtém os cavaleiros disponíveis diretamente da função listar_cavaleiros_party
        limpar_terminal(console)
        party_options, fora_party_options = listar_cavaleiros_party(console, player_id)

        if not fora_party_options:
            console.print(Panel.fit("[bold red]❌ Não há cavaleiros disponíveis para adicionar![/bold red]", border_style="red"))
            return

        # Exibir cavaleiros fora da party
        console.print("\n[bold cyan]Escolha um cavaleiro para adicionar à party:[/bold cyan]")
        for idx, (_, id_cavaleiro) in enumerate(fora_party_options, 1):
            console.print(f"{idx}. Cavaleiro ID: {id_cavaleiro}")

        try:
            # Escolha do cavaleiro para adicionar
            adicionar = int(input("\n🎯 Escolha o número do cavaleiro para adicionar: ").strip())

            if 1 <= adicionar <= len(fora_party_options):
                cavaleiro_adicionado = fora_party_options[adicionar - 1][1]

                # Atualiza a lista para verificar se a party já está cheia
                if len(party_options) > 1:  # Verifica se há limite para a party
                    console.print("\n[bold red]Escolha um cavaleiro para remover da party:[/bold red]")
                    for idx, (_, id_cavaleiro) in enumerate(party_options, 1):
                        console.print(f"{idx}. Cavaleiro ID: {id_cavaleiro}")

                    remover = int(input("\n🎯 Escolha o número do cavaleiro para remover: ").strip())

                    if 1 <= remover <= len(party_options):
                        cavaleiro_removido = party_options[remover - 1][1]
                        cursor.execute("CALL trocar_cavaleiro_party(%s, %s, %s);", (player_id, cavaleiro_adicionado, cavaleiro_removido))
                        console.print(Panel.fit("[bold green]✅ Cavaleiro trocado com sucesso![/bold green]", border_style="green"))
                else:
                    # Adiciona o cavaleiro diretamente, sem remoção
                    cursor.execute("CALL adicionar_cavaleiro_party(%s, %s);", (player_id, cavaleiro_adicionado))
                    console.print(Panel.fit("[bold green]✅ Cavaleiro adicionado à party com sucesso![/bold green]", border_style="green"))

                # Atualiza a exibição após a modificação
                limpar_terminal(console)
                listar_cavaleiros_party(console, player_id)
                break  # Sai do loop após adicionar
            else:
                console.print(Panel.fit("[bold red]❌ Escolha inválida![/bold red]", border_style="red"))

        except ValueError:
            console.print(Panel.fit("[bold red]❌ Entrada inválida! Digite um número válido.[/bold red]", border_style="red"))
