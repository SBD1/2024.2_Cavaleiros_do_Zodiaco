from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from ..database import obter_cursor

# Configuração de elementos visuais para exibição
elementos_config = {
    "Fogo": {"emoji": "🔥", "cor": "bold red"},
    "Água": {"emoji": "💧", "cor": "bold blue"},
    "Terra": {"emoji": "🌿", "cor": "bold green"},
    "Vento": {"emoji": "🌪️", "cor": "bold cyan"},
    "Trovão": {"emoji": "⚡", "cor": "bold yellow"},
    "Luz": {"emoji": "✨", "cor": "bold white"},
    "Trevas": {"emoji": "🌑", "cor": "bold magenta"},
}

def formatar_elemento(elemento):
    """Formata o elemento com cor e emoji."""
    config = elementos_config.get(elemento, {"emoji": "❓", "cor": "bold white"})
    return f"[{config['cor']}]{config['emoji']} {elemento}[/]"

def obter_xp_maximo(cursor, nivel):
    """Retorna a XP necessária para o próximo nível."""
    cursor.execute("SELECT xp_necessaria FROM xp_necessaria WHERE nivel = %s;", (nivel + 1,))
    resultado = cursor.fetchone()
    return resultado[0] if resultado else "N/A"

def listar_cavaleiros_party(console, player_id):
    """Lista os cavaleiros na party e fora da party, mantendo o player como o primeiro na party."""
    try:
        party_options = []
        fora_party_options = []

        with obter_cursor() as cursor:
            # Obtém informações do jogador
            cursor.execute("""
                SELECT nome, nivel, xp_atual, hp_max, hp_atual, magia_max, magia_atual,
                       velocidade, ataque_fisico, ataque_magico, elemento_nome
                FROM player_info_view WHERE id_player = %s;
            """, (player_id,))
            player = cursor.fetchone()

            if not player:
                console.print(Panel.fit("⛔ [bold red]Jogador não encontrado![/bold red]", border_style="red"))
                return [], []

            # Processa informações do jogador
            player_nome, player_nivel, player_xp_atual, player_hp_max, player_hp_atual, player_magia_max, \
            player_magia_atual, player_velocidade, player_ataque_fisico, player_ataque_magico, player_elemento = player

            player_xp_max = obter_xp_maximo(cursor, player_nivel)
            formatted_player_elemento = formatar_elemento(player_elemento)

            # Obtém todas as instâncias de cavaleiros (party e fora party)
            cursor.execute("""
                SELECT id_cavaleiro, nome_cavaleiro, elemento_nome, nivel, xp_atual, hp_max, magia_max,
                       hp_atual, magia_atual, velocidade, ataque_fisico, ataque_magico, id_party
                FROM instancia_cavaleiro_view
                WHERE id_player = %s;
            """, (player_id,))
            cavaleiros = cursor.fetchall()

            # Inicializa as tabelas para exibição
            tabela_party = Table(title=f"⚔️ Grupo de {player_nome}", show_lines=True)
            tabela_fora_party = Table(title="🛡️ Cavaleiros Fora da Party", show_lines=True)

            for tabela in [tabela_party, tabela_fora_party]:
                tabela.add_column("#", style="bold yellow", justify="center")
                tabela.add_column("Nome", style="cyan", justify="center", no_wrap=True)
                tabela.add_column("Elemento", style="blue", justify="center", no_wrap=True)
                tabela.add_column("Nível", style="green", justify="center", no_wrap=True)
                tabela.add_column("XP", style="yellow", justify="center", no_wrap=True)
                tabela.add_column("HP", style="red", justify="center", no_wrap=True)
                tabela.add_column("Magia", style="magenta", justify="center", no_wrap=True)
                tabela.add_column("Velocidade", style="white", justify="center", no_wrap=True)
                tabela.add_column("Ataque Físico", style="orange1", justify="center", no_wrap=True)
                tabela.add_column("Ataque Mágico", style="purple", justify="center", no_wrap=True)

            # Adiciona o jogador como o primeiro na tabela da party
            tabela_party.add_row(
                "—", player_nome, formatted_player_elemento, str(player_nivel),
                f"{player_xp_max} / {player_xp_atual}", f"{player_hp_max} / {player_hp_atual}",
                f"{player_magia_max} / {player_magia_atual}", str(player_velocidade),
                str(player_ataque_fisico), str(player_ataque_magico)
            )

            # Processa os cavaleiros e adiciona às tabelas e listas
            for index, cav in enumerate(cavaleiros, start=1):
                id_cavaleiro, nome, elemento, nivel, xp_atual, hp_max, magia_max, hp_atual, magia_atual, \
                velocidade, ataque_fisico, ataque_magico, id_party = cav

                # Formata os dados do cavaleiro
                xp_max = obter_xp_maximo(cursor, nivel)
                formatted_elemento = formatar_elemento(elemento)
                cavaleiro_data = [
                    str(index), nome, formatted_elemento, str(nivel), f"{xp_max} / {xp_atual}",
                    f"{hp_max} / {hp_atual}", f"{magia_max} / {magia_atual}",
                    str(velocidade), str(ataque_fisico), str(ataque_magico)
                ]

                if id_party:  # Está na party (mas não o jogador)
                    tabela_party.add_row(*cavaleiro_data)
                    party_options.append((index, id_cavaleiro))
                else:  # Fora da party
                    tabela_fora_party.add_row(*cavaleiro_data)
                    fora_party_options.append((index, id_cavaleiro))

        # Exibe as tabelas (fora do bloco "with")
        console.print(tabela_party)
        if fora_party_options:
            console.print(tabela_fora_party)
        else:
            console.print(Panel.fit(
                "🌌 Nenhum guerreiro está aguardando! Todos os cavaleiros estão na batalha, protegendo Atena!",
                border_style="red"
            ))

        # Retorna as listas de opções
        return party_options, fora_party_options

    except Exception as e:
        console.print(Panel.fit(f"⛔ [bold red]Erro ao listar cavaleiros: {e}[/bold red]", border_style="red"))
        return [], []
