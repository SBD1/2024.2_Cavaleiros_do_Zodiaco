import psycopg2
import os
from dotenv import load_dotenv
from rich.console import Console
from pyfiglet import Figlet
from termcolor import colored


# Variável global para armazenar o ID do jogador selecionado
selected_player_id = None

# Carregar as variáveis do .env
load_dotenv(dotenv_path="../.env")

def get_db_connection():
    """Obtém uma conexão com o banco de dados usando psycopg2."""
    try:
        return psycopg2.connect(
            dbname=os.getenv("POSTGRES_DB"),
            user=os.getenv("POSTGRES_USER"),
            password=os.getenv("POSTGRES_PASSWORD"),
            host=os.getenv("POSTGRES_HOST"),
            port=os.getenv("POSTGRES_PORT"),
        )
    except Exception as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        return None

def get_player_status(player_id):
    """Executa a função 'get_player_info' no PostgreSQL para obter o status do jogador."""
    connection = None
    try:
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )
        with connection.cursor() as cursor:
            cursor.execute("SELECT get_player_info(%s);", (player_id,))
            result = cursor.fetchone()

            if result and result[0]:
                return result[0]  # Retorna a string formatada
            else:
                return "Jogador não encontrado."
    except Exception as e:
        print(f"Erro ao executar consulta: {e}")
        return None
    finally:
        if connection is not None:
            connection.close()

def fetch_one(query, params=()):
    """Executa uma consulta SQL que retorna um único resultado."""
    connection = get_db_connection()
    if not connection:
        return None
    try:
        with connection.cursor() as cursor:
            cursor.execute(query, params)
            return cursor.fetchone()
    except Exception as e:
        print(f"Erro ao executar consulta: {e}")
        return None
    finally:
        connection.close()

def listar_jogadores():
    """Chama a função 'listar_jogadores_formatados' no PostgreSQL e retorna os jogadores como string formatada."""
    connection = None
    try:
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )
        with connection.cursor() as cursor:
            cursor.execute("SELECT listar_jogadores_formatados();")
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                print("\n=== Jogadores Disponíveis ===")
                print(resultado[0])  # Exibe a string formatada
            else:
                print("Nenhum jogador disponível.")
    except Exception as e:
        print(f"Erro ao listar jogadores: {e}")
    finally:
        if connection:
            connection.close()

def selecionar_jogador_e_mostrar_status():
    """Permite ao usuário selecionar um jogador pelo nome e exibe o status."""
    global selected_player_id  # Usar a variável global
    listar_jogadores()

    nome_jogador = input("\nDigite o nome do jogador que deseja selecionar: ").strip()
    limpar_terminal()
    connection = None
    try:
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )
        with connection.cursor() as cursor:
            cursor.execute("SELECT id_player FROM player WHERE nome = %s;", (nome_jogador,))
            resultado = cursor.fetchone()

            if resultado:
                selected_player_id = resultado[0]  # Salva o ID na variável global
                print(f"\nJogador '{nome_jogador}' selecionado com sucesso!")
                status = get_player_status(selected_player_id)
                if status:
                    print("\n=== Status do Jogador Selecionado ===")
                    print(status)
                    print("=====================================\n")
                else:
                    print("Não foi possível recuperar o status do jogador.")
            else:
                print(f"Jogador '{nome_jogador}' não encontrado.")
    except Exception as e:
        print(f"Erro ao selecionar jogador: {e}")
    finally:
        if connection:
            connection.close()

def exibir_introducao(console):
    """Exibe o texto da introdução do jogo buscando no banco de dados."""
    connection = None
    try:
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )
        with connection.cursor() as cursor:
            # Consulta o texto com nome_texto = 'introducao'
            cursor.execute("SELECT texto FROM public.texto WHERE nome_texto = %s;", ('introducao',))
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                introducao = resultado[0]
                console.print(introducao, style="bold")
            else:
                console.print("[bold red]Introdução não encontrada no banco de dados.[/bold red]")
    except Exception as e:
        console.print(f"[bold red]Erro ao buscar introdução: {e}[/bold red]")
    finally:
        if connection:
            connection.close()

def mostrar_menu_acoes(console):
    """Exibe o menu de ações disponíveis para o jogador."""
    while True:
        console.print("\n[bold cyan]Menu de Ações:[/bold cyan]")
        console.print("1. Ver Mapa (Salas Disponíveis)")
        console.print("2. Ver Sala Atual")
        console.print("3. Mudar de Sala")
        console.print("4. Sair do Menu de Ações")

        console.print("\n [bold blue] Escolha uma ação: [/bold blue]", end="")
        escolha = input().strip()
        
        if escolha == "1":
            ver_salas_disponiveis(console)
        elif escolha == "2":
            ver_sala_atual(console)
        elif escolha == "3":
            mudar_de_sala(console)
        elif escolha == "4":
            console.print("\n[bold blue]Saindo do Menu de Ações...[/bold blue]")
            console.print("\n[bold green]Pressione ENTER para continuar...[/bold green]")
            input()
            break
        else:
            console.print("[bold red]Opção inválida. Tente novamente.[/bold red]")


def ver_salas_disponiveis(console):
    """Mostra as salas conectadas disponíveis para o jogador."""
    global selected_player_id
    if selected_player_id is None:
        console.print("[bold red]Nenhum jogador foi selecionado![/bold red]")
        
        return

    connection = None
    try:
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM get_salas_conectadas(%s);", (selected_player_id,))
            salas = cursor.fetchall()

            if salas:
                console.print("\n[bold cyan]Salas Disponíveis:[/bold cyan]")
                for sala in salas:
                    console.print(f"Opção Sala: {sala[0]}, Nome: {sala[1]}")
            else:
                console.print("[bold yellow]Nenhuma sala conectada disponível.[/bold yellow]")
    except Exception as e:
        console.print(f"[bold red]Erro ao buscar salas disponíveis: {e}[/bold red]")
    finally:
        if connection:
            connection.close()

def mudar_de_sala(console):
    """Permite ao jogador mudar de sala."""
    global selected_player_id
    if selected_player_id is None:
        console.print("[bold red]Nenhum jogador foi selecionado![/bold red]")
        return

    ver_salas_disponiveis(console)
    id_sala = input("\nDigite o ID da sala para a qual deseja se mover: ").strip()

    # Converta o ID da sala para inteiro
    try:
        try:
            connection = psycopg2.connect(
                dbname="cdz",
                user="user",
                password="password",
                host="localhost",
                port="5432"
            )
            with connection.cursor() as cursor:
                cursor.execute("SELECT mudar_sala(%s, %s);", (selected_player_id, int(id_sala)))
                connection.commit()  # Confirma a transação

                # Buscar o nome da sala para o feedback
                nome_sala = get_nome_sala(id_sala)
                if nome_sala:
                    console.print(f"[bold green]Movido para a sala '{nome_sala}' com sucesso![/bold green]")
                else:
                    console.print("[bold yellow]Movido para a sala, mas o nome não foi encontrado.[/bold yellow]")
        except Exception as e:
            console.print(f"[bold red]Erro ao mudar de sala: {e}[/bold red]")
        finally:
            if connection:
                connection.close()
    except ValueError:
        console.print("[bold red]O ID da sala deve ser um número válido![/bold red]")
        return

    connection = None
    
            
def get_nome_sala(id_sala):
    """Retorna o nome da sala com base no ID."""
    connection = None
    try:
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )
        with connection.cursor() as cursor:
            cursor.execute("SELECT get_nome_sala(%s);", (id_sala,))
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                return resultado[0]  # Retorna o nome da sala
            else:
                return None
    except Exception as e:
        print(f"Erro ao buscar o nome da sala: {e}")
        return None
    finally:
        if connection:
            connection.close()

def ver_sala_atual(console):
    """Exibe a sala atual do jogador."""
    global selected_player_id
    if selected_player_id is None:
        console.print("[bold red]Nenhum jogador foi selecionado![/bold red]")
        return

    connection = None
    try:
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )
        with connection.cursor() as cursor:
            cursor.execute("SELECT get_sala_atual(%s);", (selected_player_id,))
            resultado = cursor.fetchone()

            if resultado and resultado[0]:
                console.print("\n[bold cyan]Sala Atual:[/bold cyan]")
                console.print(resultado[0], style="bold")
            else:
                console.print("[bold yellow]Sala atual não encontrada para o jogador selecionado.[/bold yellow]")
    except Exception as e:
        console.print(f"[bold red]Erro ao buscar a sala atual: {e}[/bold red]")
    finally:
        if connection:
            connection.close()


def iniciar_jogo(console):
    """Inicia o jogo com o jogador selecionado."""
    global selected_player_id  # Acessa a variável global
    if selected_player_id is None:
        console.print("\n[bold red]Nenhum jogador foi selecionado! Por favor, selecione um jogador primeiro.[/bold red]")
        console.print("\n[bold green]Pressione ENTER para continuar...[/bold green]")
        input()
        return

    # Exibe a introdução antes de começar o jogo
    exibir_introducao(console)

    # Mostra o menu de ações
    mostrar_menu_acoes(console)
    
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

def limpar_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')
    logo_print()


def run():
    """Menu principal do jogo."""
    while True:
        console = Console()
        limpar_terminal()
        print("\nMenu:")
        print("1. Adicionar Novo Jogador")
        print("2. Listar Jogadores")
        print("3. Selecionar Jogador e Mostrar Status")
        print("4. Iniciar Jogo")
        print("5. Sair")

        escolha = input("Escolha uma opção: ").strip()
        if escolha == "1":
            limpar_terminal()
            console.print("[bold red]Não é possivel no momento[/bold red]")
            console.print("[bold green]Pressione ENTER para continuar...[/bold green]")
            input()
        elif escolha == "2":
            listar_jogadores()
            console.print("[bold green]Pressione ENTER para continuar...[/bold green]")
            input()
        elif escolha == "3":
            selecionar_jogador_e_mostrar_status()
            console.print("[bold green]Pressione ENTER para continuar...[/bold green]")
            input()
        elif escolha == "4":
            limpar_terminal()
            iniciar_jogo(console)
        elif escolha == "5":
            print("Saindo do jogo...")
            break
        else:
            print("Opção inválida. Tente novamente.")

def main():
    run()

if __name__ == "__main__":
    main()
