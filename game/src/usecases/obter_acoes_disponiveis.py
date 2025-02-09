from .interagir_mercador import interagir_mercador
from .mudar_casa import mudar_casa
from .mudar_de_sala import mudar_de_sala
from .mudar_para_orfanato import mudar_para_orfanato
from .mudar_saga import mudar_saga
from .ver_mapa import ver_mapa
from .ver_salas_disponiveis import ver_salas_disponiveis
from .verificar_se_esta_na_saga_orfanato import verificar_se_esta_na_saga_orfanato
from .ver_inventario import ver_inventario
from .modificar_grupo import modificar_grupo
from .ver_missoes import ver_missoes
from .verificar_npc_na_sala import verificar_npc_na_sala
from .interagir_quest import interagir_quest
from .listar_todas_receitas import listar_todas_receitas
from .gerar_item import gerar_item
from .verificar_desbloqueio_ferreiro import verificar_desbloqueio_ferreiro
from .listar_equipamentos import listar_equipamentos
from .interagir_ferreiro import interagir_ferreiro
from .equipar_armadura import equipar_armadura
from .modificar_grupo import modificar_grupo


def obter_acoes_disponiveis(jogador_id):

    # Opções comuns a todos os jogadores
    opcoes = [
        ("[bold yellow]🛡️ Ver Salas Disponíveis [/bold yellow]", ver_salas_disponiveis),
        ("[bold green]🚪 Mudar de Sala[/bold green]", mudar_de_sala),
        ("[bold purple]🗺️ Ver Mapa[/bold purple]", ver_mapa),
        ("[bold orange]🪖 Ver Equipamento[/bold orange]", equipar_armadura),
        ("[bold cyan]🎒 Ver Inventário[/bold cyan]", ver_inventario),
        ("[light_pink4]📜 Ver Receitas [/light_pink4]", listar_todas_receitas),
        ("[bold green]⚒️ Craftar Item[/bold green]", gerar_item),
        ("[bold blue]⚔️ Ver Grupo[/bold blue]", modificar_grupo),
        ("[light_pink4]📜 Ver Missões[/light_pink4]", ver_missoes),

    ]

    # Opções que variam conforme o estado do jogador
    if verificar_se_esta_na_saga_orfanato(jogador_id):
        opcoes.append(("[bold blue]📖 Mudar de Saga[/bold blue]", mudar_saga))
    else:
        opcoes.append(("[bold magenta]🏠 Mudar de Casa[/bold magenta]", mudar_casa))
        opcoes.append(("[bold cyan]🌟 Voltar para o Orfanato[/bold cyan]", mudar_para_orfanato))

    check_npc = verificar_npc_na_sala(jogador_id)

    if check_npc == "Ferreiro" and verificar_desbloqueio_ferreiro(jogador_id):
        opcoes.insert(0, ("[orange4]🔨 Falar com Mu (Ferreiro)[/orange4]", interagir_ferreiro))

    elif check_npc == "Missao":
        opcoes.insert(0, ("[sea_green1]💬 Falar com Saori Kido (Missões)[/sea_green1]", interagir_quest))

    elif check_npc == "Mercador":
        opcoes.insert(0, ("[chartreuse2]💰 Falar com Jabu (Mercador)[/chartreuse2]", interagir_mercador))

    opcoes.append(("[bold red]❌ Sair do Menu de Ações[/bold red]", None))

    return opcoes
