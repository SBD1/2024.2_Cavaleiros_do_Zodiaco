from rich.panel import Panel
from rich.console import Console
from ..database import obter_cursor

def construir_matriz(mapa):
    """Constrói uma matriz representando o mapa de forma estruturada."""
    
    n = len(mapa)  # O tamanho da matriz depende do número total de salas
    matriz = [['   ' for _ in range(n * 2)] for _ in range(n * 2)]  # Criamos uma matriz grande o suficiente

    posicoes = {}  # Dicionário que mapeia id_sala -> (linha, coluna)
    visitados = set()

    # Começar pela sala inicial (assumimos que a sala 1 existe)
    fila = [(1, n, n)]  # Começamos no centro da matriz
    posicoes[1] = (n, n)

    while fila:
        sala_id, x, y = fila.pop(0)

        if sala_id in visitados or sala_id not in mapa:
            continue

        visitados.add(sala_id)
        matriz[x][y] = f'🏰{sala_id}'  # Marca a posição da sala no mapa

        # Explorar os vizinhos
        if mapa[sala_id]["norte"] and mapa[sala_id]["norte"] not in visitados:
            matriz[x-1][y] = ' | '  # Conexão vertical
            matriz[x-2][y] = f'🏰{mapa[sala_id]["norte"]}'
            fila.append((mapa[sala_id]["norte"], x-2, y))

        if mapa[sala_id]["sul"] and mapa[sala_id]["sul"] not in visitados:
            matriz[x+1][y] = ' | '  # Conexão vertical
            matriz[x+2][y] = f'🏰{mapa[sala_id]["sul"]}'
            fila.append((mapa[sala_id]["sul"], x+2, y))

        if mapa[sala_id]["leste"] and mapa[sala_id]["leste"] not in visitados:
            matriz[x][y+1] = '───'  # Conexão horizontal
            matriz[x][y+2] = f'🏰{mapa[sala_id]["leste"]}'
            fila.append((mapa[sala_id]["leste"], x, y+2))

        if mapa[sala_id]["oeste"] and mapa[sala_id]["oeste"] not in visitados:
            matriz[x][y-1] = '───'  # Conexão horizontal
            matriz[x][y-2] = f'🏰{mapa[sala_id]["oeste"]}'
            fila.append((mapa[sala_id]["oeste"], x, y-2))

    return matriz


def ver_mapa(console, selected_player_id):
    """🗺 Exibe um mapa estruturado no terminal com emojis, matriz dinâmica e legenda."""
    
    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT * FROM get_mapa();")
            salas = cursor.fetchall()

            if not salas:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Nenhuma sala encontrada.[/bold yellow]",
                    title="🔍 Mapa Vazio",
                    border_style="yellow"
                ))
                return

            # Obtém a posição do jogador
            cursor.execute("SELECT id_sala FROM public.party WHERE id_player = %s;", (selected_player_id,))
            sala_atual = cursor.fetchone()
            sala_atual = sala_atual[0] if sala_atual else None

            # Criar um dicionário com as salas
            mapa = {}
            legenda_salas = []

            for sala in salas:
                id_sala, nome, norte, sul, leste, oeste = sala
                mapa[id_sala] = {
                    "nome": nome,
                    "norte": norte,
                    "sul": sul,
                    "leste": leste,
                    "oeste": oeste,
                    "is_player": (id_sala == sala_atual)
                }
                legenda_salas.append(f"{id_sala}: {nome}")

            # Construir a matriz do mapa
            matriz = construir_matriz(mapa)

            # Transformar a matriz em string para exibição
            mapa_str = "\n".join(["".join(linha) for linha in matriz])

            # Criar legenda visual
            legenda = (
                "[bold cyan]🔍 Legenda:[/bold cyan]\n"
                "🏰 = Sala disponível\n"
                "🧍 = Você (jogador)\n"
                "─── = Caminho leste-oeste\n"
                "| = Caminho norte-sul\n\n"
                "[bold yellow]🏷️ Salas:[/bold yellow]\n" +
                "\n".join(legenda_salas)
            )

            # Exibir o mapa no terminal
            console.print(Panel.fit(mapa_str, title="🗺 Mapa do Jogo", border_style="blue"))
            console.print(Panel.fit(legenda, title="📖 Legenda", border_style="green"))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao gerar o mapa:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
