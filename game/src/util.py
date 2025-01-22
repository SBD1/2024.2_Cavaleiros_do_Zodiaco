from pyfiglet import Figlet
from termcolor import colored
import os

def limpar_terminal(console):
    os.system('cls' if os.name == 'nt' else 'clear')
    logo_print()


def logo_print():
    figlet = Figlet(font='slant')
    text = "Cavaleiros do Zodiaco"
    ascii_art = figlet.renderText(text)

    # Alterna as cores vermelho e amarelo
    colored_ascii_art = ''.join(
        colored(char, 'red') if i % 2 == 0 else colored(char, 'yellow')
        for i, char in enumerate(ascii_art)
    )

    print(colored_ascii_art)

def executar_com_interface(console,func, *args, **kwargs):
    """Limpa o terminal, executa a função passada como argumento e aguarda input para continuar."""
    limpar_terminal()
    func(*args, **kwargs)
    console.print("[bold green]Pressione ENTER para continuar...[/bold green]")
    input()
