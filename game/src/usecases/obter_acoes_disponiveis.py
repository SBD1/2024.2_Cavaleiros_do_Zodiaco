from .mudar_casa import mudar_casa
from .mudar_de_sala import mudar_de_sala
from .mudar_para_orfanato import mudar_para_orfanato
from .mudar_saga import mudar_saga
from .ver_mapa import ver_mapa
from .ver_salas_disponiveis import ver_salas_disponiveis
from .verificar_se_esta_na_saga_orfanato import verificar_se_esta_na_saga_orfanato
from .ver_inventario import ver_inventario
<<<<<<< HEAD
from .ver_grupo import ver_grupo
from .trocar_cavaleiro import trocar_cavaleiro
=======
from .ver_missoes import ver_missoes

>>>>>>> c5b652260fce31ccf2aef98be586e81b738a92f9
def obter_acoes_disponiveis(jogador_id):


    # Opções comuns a todos os jogadores
    opcoes = [
        ("[bold yellow]Ver Salas Disponíveis [/bold yellow]", ver_salas_disponiveis),
        ("[bold green]Mudar de Sala[/bold green]", mudar_de_sala),
        ("[bold purple]Ver Mapa[/bold purple] 🗺", ver_mapa),
<<<<<<< HEAD
         ("[bold cyan]Ver Inventário[/bold cyan] 🎒", ver_inventario),
         ("[bold blue]Ver Grupo[/bold blue] ⚔️", ver_grupo),
          ("[bold red]Trocar Cavaleiro na Party[/bold red] 🔄", trocar_cavaleiro)
=======
        ("[bold cyan]Ver Inventário[/bold cyan] 🎒", ver_inventario),
        ("[bold cyan]Ver Missões[/bold cyan] ", ver_missoes)
>>>>>>> c5b652260fce31ccf2aef98be586e81b738a92f9
    ]

    # Opções que variam conforme o estado do jogador
    if verificar_se_esta_na_saga_orfanato(jogador_id):
        opcoes.append(("[bold blue]Mudar de Saga[/bold blue]", mudar_saga))
    else:
        opcoes.append(("Mudar de Casa", mudar_casa))
        opcoes.append(("[bold cyan]Voltar para o Orfanato[/bold cyan]", mudar_para_orfanato))
        

    opcoes.append(("[bold red]Sair do Menu de Ações[/bold red]", None))

    # 7 listar missões -> escolher uma missao pra saber as info ou voltar pro menu principal
    # falar com npc
    # lutar -> caso haja inimigo na sala aparecer a opção
    # ver grupo -> trocar cavaleiros -> lista todos os cavaleiros
    # 

    return opcoes