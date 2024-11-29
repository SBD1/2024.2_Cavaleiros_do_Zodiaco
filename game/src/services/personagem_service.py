from repositories.personagem_repository import PersonagemRepository
from db.connection import get_db_connection

class PersonagemService:
    def __init__(self):
        self.db_connection = get_db_connection()
        self.repository = PersonagemRepository(self.db_connection)

    def criar_personagem(self, nome):
        return self.repository.create_personagem(nome)

    def listar_personagens(self):
        return self.repository.list_personagens()
