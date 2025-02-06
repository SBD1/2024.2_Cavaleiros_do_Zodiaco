import time
import psycopg2
import os
from dotenv import load_dotenv
from rich.console import Console
from rich.panel import Panel
from src.usecases.obter_acoes_disponiveis import obter_acoes_disponiveis
from src.usecases.obter_status_jogador import obter_status_jogador
from src.usecases.listar_jogadores import listar_jogadores
from src.usecases.selecionar_jogador import selecionar_jogador
from src.usecases.ver_locazalicao_atual import ver_localizacao_atual
from src.usecases.iniciar_jogo import iniciar_jogo
from src.usecases.criar_jogador import criar_jogador
from src.usecases.verificar_inimigos import verificar_inimigos
from src.usecases.verificar_boss import verificar_boss
from .util import limpar_terminal
from src.usecases.tocar_tema_encerramento import tocar_tema_encerramento



jogador_selecionado_id = None

def executar_com_interface(console, func, *args, **kwargs):

    limpar_terminal(console)
    func(console, *args, **kwargs)
    console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
    input()


def mostrar_menu_acoes(console):

    global jogador_selecionado_id

    

    while True:
        limpar_terminal(console)

        if verificar_inimigos(console,jogador_selecionado_id):
            # batalhar(console,jogador_selecionado_id)
            limpar_terminal(console)
        elif verificar_boss(console,jogador_selecionado_id):
            limpar_terminal(console)
        


        ver_localizacao_atual(console, jogador_selecionado_id)

        opcoes = obter_acoes_disponiveis(jogador_selecionado_id)
        
        console.print(Panel("[bold cyan]⚔ Menu de Ações ⚔[/bold cyan]", expand=False))

        for opcao in opcoes:
            console.print(f"{opcoes.index(opcao) + 1}. {opcao[0]}")


        escolha = int(input("\n🎯 Escolha uma ação: ").strip())

        if 1 <= int(escolha) < len(opcoes):
            executar_com_interface(console, opcoes[escolha - 1][1], jogador_selecionado_id)
        elif escolha == len(opcoes):
            console.print(Panel("[bold red]👋 Saindo do Menu de Ações...[/bold red]", expand=False))
            input("\n[💾 Pressione ENTER para continuar...]")
            break
        else:
            console.print("[bold red]⚠ Opção inválida! Tente novamente.[/bold red]")
            time.sleep(1)


def run():
    """Menu principal do jogo."""
    global jogador_selecionado_id
    console = Console()
    
    while True:
        limpar_terminal(console)
        console.print(Panel("[bold cyan]🛡 Cavaleiros do Zodíaco 🛡[/bold cyan]", title="✨ ✨ ✨ ✨", expand=False))

        console.print("1️⃣ [bold yellow]Adicionar Novo Jogador[/bold yellow] ")
        console.print("2️⃣ [bold blue]Listar Jogadores[/bold blue]")
        console.print("3️⃣ [bold green]Selecionar Jogador[/bold green]")
        console.print("4️⃣ [bold magenta]Mostrar Status do Jogador[/bold magenta]")
        console.print("5️⃣ [bold cyan]Iniciar Jogo[/bold cyan] 🚀")
        console.print("6️⃣ [bold red]Sair[/bold red] 🚪➡️🚶‍♂️ ")

        escolha = input("\n🎮 Escolha uma opção: ").strip()
        
        if escolha == "1":
            executar_com_interface(console, lambda c: criar_jogador(console))
        elif escolha == "2":
            executar_com_interface(console, lambda c: listar_jogadores())
        elif escolha == "3":
            limpar_terminal(console)
            jogador_selecionado = selecionar_jogador()
            if jogador_selecionado != None:
                jogador_selecionado_id = jogador_selecionado[1]
                executar_com_interface(console, lambda c: c.print(f"[bold cyan]👤 Jogador selecionado: {jogador_selecionado[0]}[/bold cyan]"))
        elif escolha == "4":
            executar_com_interface(console, lambda c: obter_status_jogador(jogador_selecionado_id))
        elif escolha == "5":
            executar_com_interface(console, iniciar_jogo, jogador_selecionado_id)
            if jogador_selecionado_id != None:
                mostrar_menu_acoes(console)
        elif escolha == "6":
            console.print(Panel("[bold red]❌ Saindo do jogo...[/bold red]", expand=False))
            executar_com_interface(console,lambda c: tocar_tema_encerramento())
            break
        else:
            console.print("[bold red]⚠ Opção inválida! Tente novamente.[/bold red]")

def main():
    run()

if __name__ == "__main__":
    main()
