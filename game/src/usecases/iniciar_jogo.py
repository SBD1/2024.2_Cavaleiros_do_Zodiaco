from .exibir_introducao import exibir_introducao
from .setar_sala_incial import setar_sala_inicial
from .tocar_musica import tocar_musica
from rich.panel import Panel
from rich.console import Console

def iniciar_jogo(console: Console, selected_player_id):
    """🚀 Inicia o jogo com o jogador selecionado."""
    
    if selected_player_id is None:
        console.print(Panel.fit(
            "[bold red]❌ Nenhum jogador selecionado![/bold red]\n\n"
            "[bold yellow]⚔️ Escolha um Cavaleiro antes de iniciar a aventura![/bold yellow]",
            title="🚨 ERRO 🚨",
            border_style="red"
        ))
        return


    # Exibir introdução do jogo
    console.print(Panel.fit(
        "[bold cyan]✨ Preparando sua jornada... ✨[/bold cyan]\n"
        "[bold yellow]🔮 Sentimos o cosmo se elevar...[/bold yellow]",
        title="🏹 Cavaleiros do Zodíaco 🛡",
        border_style="bright_magenta"
    ))
    
    setar_sala_inicial(selected_player_id)

    exibir_introducao(console)

    # Toca a música-tema
    console.print(Panel.fit(
        "[bold green]🎵 Tocando: 'Faça elevar o Cosmo em seu coração' 🎶[/bold green]",
        border_style="green"
    ))
    tocar_musica("Tema de Abertura",5)

    input("\n[🔙 Pressione ENTER para voltar ao menu]")
