import psycopg2
import os
from dotenv import load_dotenv
from rich.console import Console
from pyfiglet import Figlet

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
    connection = None  # Inicializa a variável como None
    try:
        # Conexão com o banco de dados (substitua pelos seus dados fixos)
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="localhost",
            port="5432"
        )

        with connection.cursor() as cursor:
            # Chama a função 'get_player_info' no PostgreSQL
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
        # Fecha a conexão apenas se ela foi aberta
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


def exibir_logo(console):
    """Exibe o logo do jogo buscando do banco de dados."""
    query = "SELECT texto FROM Texto WHERE nome_texto = %s"
    params = ("logo",)
    
    resultado = fetch_one(query, params)
    if resultado:
        logo = resultado[0]
        console.print(logo)
    else:
        console.print("[bold red]Logo não encontrado no banco de dados.[/bold red]")


def exibir_introducao(console):
    """Exibe a introdução do jogo buscando do banco de dados."""
    query = "SELECT texto FROM Texto WHERE nome_texto = %s"
    params = ("introducao",)
    
    resultado = fetch_one(query, params)
    if resultado:
        introducao = resultado[0]
        console.print(introducao)
    else:
        console.print("[bold red]Introdução não encontrada no banco de dados.[/bold red]")

def run():
    """Menu principal do jogo."""
    while True:
        print("\nMenu:")
        print("1. Adicionar Novo Jogador")
        print("2. Listar Jogadores")
        print("3. Selecionar Jogador e Mostrar Status")
        print("5. Sair")

        escolha = input("Escolha uma opção: ").strip()
        
        if escolha == "3":
            # Exibe o status do jogador com ID 1
            player_id = 1
            status = get_player_status(player_id)
            if status:
                print("\n=== Status do Jogador ===")
                print(status)
            else:
                print("\n[ERRO] Não foi possível recuperar o status do jogador.")
        elif escolha == "5":
            print("Saindo do jogo...")
            break
        else:
            print("Opção inválida. Tente novamente.")


def get_player_info(player_id):
    """Chama a stored procedure para recuperar informações do jogador formatadas como string."""
    try:
        # Configuração da conexão (fixa, conforme sua preferência)
        connection = psycopg2.connect(
            dbname="cdz",
            user="user",
            password="password",
            host="postgres",
            port="5432"
        )

        with connection.cursor() as cursor:
            # Chamar a stored procedure
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
        if connection:
            connection.close()

def main():
    console = Console()
    figlet = Figlet(font="slant")
    console.print(figlet.renderText("Cavaleiros do Zodiaco"), style="bold cyan")
    run()
    exibir_logo(console)
    exibir_introducao(console)


if __name__ == "__main__":
    main()
