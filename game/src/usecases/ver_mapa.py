from rich.panel import Panel
from rich.console import Console
from ..database import obter_cursor

def construir_matriz(mapa, sala_atual):
    """Constrói uma matriz representando o mapa de forma estruturada, com o boneco ao lado da sala atual."""
    n = len(mapa)  # Estimativa do tamanho
    matriz = [['   ' for _ in range(n * 2)] for _ in range(n * 2)]  # Matriz grande o suficiente
    posicoes = {}
    visitados = set()

    fila = [(list(mapa.keys())[0], n, n)]  # Assume que começa na primeira sala
    posicoes[fila[0][0]] = (n, n)

    while fila:
        sala_id, x, y = fila.pop(0)

        if sala_id in visitados or sala_id not in mapa:
            continue

        visitados.add(sala_id)

        if sala_id == sala_atual:
            matriz[x][y] = f'🏰{sala_id}🧍'
        else:
            matriz[x][y] = f'🏰{sala_id}'

        for direcao, dx, dy in [("norte", -2, 0), ("sul", 2, 0), ("leste", 0, 2), ("oeste", 0, -2)]:
            vizinho = mapa[sala_id].get(direcao)
            if vizinho and vizinho not in visitados:
                if direcao in ["norte", "sul"]:
                    matriz[x + dx // 2][y] = ' | '
                else:
                    matriz[x][y + dy // 2] = '───'
                fila.append((vizinho, x + dx, y + dy))

    return matriz


def ver_mapa(console, selected_player_id):
    """🗺 Exibe um mapa estruturado no terminal com apenas as salas da casa do jogador."""
    try:
        with obter_cursor() as cursor:
            cursor.execute("""
                SELECT s.id_casa 
                FROM public.sala s
                JOIN public.party p ON s.id_sala = p.id_sala
                WHERE p.id_player = %s;
            """, (selected_player_id,))
            casa_do_jogador = cursor.fetchone()

            if not casa_do_jogador:
                console.print(Panel(
                    "⚠️ [bold yellow]Jogador não está vinculado a nenhuma casa.[/bold yellow]",
                    title="🔍 Nenhuma Casa Encontrada",
                    border_style="yellow",
                    expand=False
                ))
                return

            id_casa = casa_do_jogador[0]
            cursor.execute("SELECT * FROM get_mapa(%s);", (id_casa,))
            salas = cursor.fetchall()

            if not salas:
                console.print(Panel(
                    "⚠️ [bold yellow]Nenhuma sala encontrada para esta casa.[/bold yellow]",
                    title="🔍 Mapa Vazio",
                    border_style="yellow",
                    expand=False
                ))
                return

            cursor.execute("SELECT id_sala FROM public.party WHERE id_player = %s;", (selected_player_id,))
            sala_atual = cursor.fetchone()
            sala_atual = sala_atual[0] if sala_atual else None

            mapa = {}
            legenda_salas = []
            for sala in salas:
                id_sala, nome, norte, sul, leste, oeste = sala
                mapa[id_sala] = {"nome": nome, "norte": norte, "sul": sul, "leste": leste, "oeste": oeste}
                legenda_salas.append(f"{id_sala}: {nome}")

            matriz = construir_matriz(mapa, sala_atual)
            mapa_str = "\n".join(["".join(linha) for linha in matriz])

            legenda = (
                "[bold cyan]🔍 Legenda:[/bold cyan]\n"
                "🏰 = Sala disponível\n"
                "🧍 = Você (jogador)\n"
                "─── = Caminho leste-oeste\n"
                "| = Caminho norte-sul\n\n"
                "[bold yellow]🏷️ Salas:[/bold yellow]\n" +
                "\n".join(legenda_salas)
            )

            console.print(Panel(mapa_str, title="🗺 Mapa do Jogo", border_style="blue", expand=False))
            console.print(Panel(legenda, title="📖 Legenda", border_style="green", expand=False ))

    except Exception as e:
        console.print(Panel(
            f"❌ [bold red]Erro ao gerar o mapa:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red",
            expand=False
        ))
