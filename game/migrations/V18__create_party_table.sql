
CREATE TABLE Party (
    id_player INTEGER PRIMARY KEY,
    id_sala INTEGER
);
 
ALTER TABLE Party ADD CONSTRAINT FK_Party_2
    FOREIGN KEY (id_sala)
    REFERENCES Sala (id_sala);