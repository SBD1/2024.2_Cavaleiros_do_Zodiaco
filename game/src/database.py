import psycopg2
import os
from dotenv import load_dotenv
from contextlib import contextmanager
import psycopg2

dotenv_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".env"))

if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path) 
else:
    print(f"❌ Arquivo .env não encontrado: {dotenv_path}")

def obter_conexao():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv("POSTGRES_DB"),
            user=os.getenv("POSTGRES_USER_APLICACAO"),
            password=os.getenv("POSTGRES_PASSWORD_APLICACAO"),
            host=os.getenv("DATABASE_HOST"),
            port=os.getenv("POSTGRES_PORT"),
        )
        conn.autocommit = True
        return conn
    except Exception as e:
        print(f"❌ Erro ao conectar ao banco de dados: {e}")
        return None


@contextmanager
def obter_cursor():
    """Obtém um cursor a partir da conexão do banco de dados."""
    conexao = obter_conexao()
    if conexao:
        try:
            cursor = conexao.cursor()
            yield cursor  # Retorna apenas o cursor para ser usado no `with`
        except Exception as e:
            print(f"❌ Erro ao obter cursor: {e}")
        finally:
            cursor.close()
            conexao.close()
    else:
        print("❌ Erro ao obter cursor: conexão não estabelecida.")
        yield None
