import psycopg2
import os
from dotenv import load_dotenv
from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from src.usecases.obter_status_jogador import obter_status_jogador
from src.usecases.listar_jogadores import listar_jogadores
from src.usecases.selecionar_jogador import selecionar_jogador
from src.usecases.exibir_introducao import exibir_introducao
from src.usecases.ver_salas_disponiveis import ver_salas_disponiveis
from src.usecases.mudar_de_sala import mudar_de_sala
from src.usecases.ver_sala_atual import ver_sala_atual
from src.usecases.iniciar_jogo import iniciar_jogo
from src.usecases.criar_jogador import criar_jogador
from src.usecases.ver_mapa import ver_mapa
from .util import limpar_terminal
from src.usecases.tocar_tema_encerramento import tocar_tema_encerramento
# Variável global para armazenar o ID do jogador selecionado
jogador_selecionado_id = None

def executar_com_interface(console, func, *args, **kwargs):
    """Limpa o terminal, executa a função passada como argumento e aguarda input para continuar."""
    limpar_terminal(console)
    func(console, *args, **kwargs)
    console.print("\n[bold green]✅ Pressione ENTER para continuar...[/bold green]")
    input()

def mostrar_menu_acoes(console):
    """Exibe o menu de ações disponíveis para o jogador."""
    global jogador_selecionado_id
    opcoes = {
        "1": ver_salas_disponiveis,
        "2": mudar_de_sala,
        "3": ver_mapa
    }
    while True:
        limpar_terminal(console)
        console.print(Panel("[bold cyan]⚔ Menu de Ações ⚔[/bold cyan]", title="🎮 Aventura Iniciada!", expand=False))

        console.print("1️⃣ [bold yellow]Ver Salas Disponíveis [/bold yellow]")
        console.print("2️⃣ [bold green]Mudar de Sala[/bold green]")
        console.print("3️⃣ [bold purple]Ver Mapa[/bold purple] 🗺")
        console.print("4️⃣ [bold red]Sair do Menu de Ações[/bold red]")

        ver_sala_atual(console, jogador_selecionado_id)

        escolha = input("\n🎯 Escolha uma ação: ").strip()
        
        if escolha in opcoes:
            executar_com_interface(console, opcoes[escolha], jogador_selecionado_id)
        elif escolha == "4":
            console.print(Panel("[bold red]👋 Saindo do Menu de Ações...[/bold red]", expand=False))
            input("\n[💾 Pressione ENTER para continuar...]")
            break
        else:
            console.print("[bold red]⚠ Opção inválida! Tente novamente.[/bold red]")

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
