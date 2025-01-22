from src.database import obter_conexao

def testa_conexao_banco_de_dados():
    conexao = obter_conexao()
    if conexao:
        print("✅ Conexão bem-sucedida!")
        conexao.close()
    else:
        print("❌ Falha na conexão!")

if __name__ == "__main__":
    testa_conexao_banco_de_dados()
