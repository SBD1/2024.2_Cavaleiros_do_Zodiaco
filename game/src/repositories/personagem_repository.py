class PersonagemRepository:
    def __init__(self, db_connection):
        self.db_connection = db_connection

    def create_personagem(self, nome):
        with self.db_connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO personagem (nome) VALUES (%s) RETURNING id_personagem;",
                (nome,),
            )
            self.db_connection.commit()
            return cursor.fetchone()[0]

    def list_personagens(self):
        with self.db_connection.cursor() as cursor:
            cursor.execute("SELECT id_personagem, nome FROM personagem;")
            return cursor.fetchall()
