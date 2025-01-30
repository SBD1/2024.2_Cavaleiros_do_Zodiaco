from rich.panel import Panel
from ..database import obter_cursor
from ..database import obter_conexao
from .obter_nome_sala import obter_nome_sala

def mudar_para_orfanato(console, selected_player_id):

    if selected_player_id is None:
        console.print(Panel.fit(
            "🚫 [bold red]Nenhum jogador foi selecionado![/bold red] 🚫",
            title="⚠️ Ação Inválida",
            border_style="red"
        ))
        return

    try:
        with obter_cursor() as cursor:
            cursor.execute("SELECT id_sala FROM public.party WHERE id_player = %s;", (selected_player_id,))
            sala_atual = cursor.fetchone()

            if sala_atual is None:
                console.print(Panel.fit(
                    "❌ [bold red]Não foi possível determinar a sala atual do jogador.[/bold red]",
                    title="⛔ Erro na Consulta",
                    border_style="red"
                ))
                return

            id_sala_atual = sala_atual[0]

            # Obter a ID da sala segura (orfanato)
            cursor.execute("SELECT id_sala FROM public.sala_segura LIMIT 1;")
            sala_segura = cursor.fetchone()

            if sala_segura is None:
                console.print(Panel.fit(
                    "❌ [bold red]A sala segura não foi encontrada no banco de dados.[/bold red]",
                    title="⛔ Sala Inexistente",
                    border_style="red"
                ))
                return

            id_sala_segura = sala_segura[0]

            # Verificar se o jogador já está na sala segura
            if id_sala_atual == id_sala_segura:
                console.print(Panel.fit(
                    "✅ [bold green]O jogador já se encontra na sala segura (Orfanato).[/bold green] 🏰",
                    title="📍 Sem Mudança Necessária",
                    border_style="green"
                ))
                return

            # Atualizar a sala do jogador para a sala segura
            cursor.execute("""
                UPDATE public.party
                SET id_sala = %s
                WHERE id_player = %s;
            """, (id_sala_segura, selected_player_id))
            obter_conexao().commit()  # Confirma a transação

            # Buscar o nome da sala para exibir no feedback
            nome_sala = obter_nome_sala(id_sala_segura)
            if nome_sala:
                console.print(Panel.fit(
                    f"✅ [bold green]Movido com sucesso para a sala segura:[/bold green] [bold yellow]{nome_sala}[/bold yellow] 🏰",
                    title="🚀 Transição Concluída",
                    border_style="green"
                ))
            else:
                console.print(Panel.fit(
                    "⚠️ [bold yellow]Movido para a sala segura, mas o nome não foi encontrado.[/bold yellow]",
                    title="🔍 Sala Desconhecida",
                    border_style="yellow"
                ))

    except Exception as e:
        console.print(Panel.fit(
            f"❌ [bold red]Erro ao tentar mudar de sala:[/bold red]\n{e}",
            title="⛔ Erro de Banco de Dados",
            border_style="red"
        ))
