import 'package:noteApp/databaseConnection/connection.dart';
import 'package:noteApp/models/notes.dart';

class NotesController {
  //insert new note.
  Future<int> insertNote(Notes note) async {
    var database = await DatabaseConnection().getDatabase();
    return database.insert(DatabaseConnection().table, note.toJSON());
  }

//retrieve all notes
  Future<List<Notes>> getNotes() async {
    var database = await DatabaseConnection().getDatabase();
    List notes = await database.query(DatabaseConnection().table,
        orderBy: "${DatabaseConnection().idCol} DESC");
    List<Notes> _notes = [];
    notes.forEach((note) {
      Notes n = Notes.fromJSON(note);
      _notes.add(n);
    });
    return _notes;
  }

//updating note by ID
  Future<int> updateNote(int noteID, Notes note) async {
    var database = await DatabaseConnection().getDatabase();
    return database.update(DatabaseConnection().table, note.toJSON(),
        where: "${DatabaseConnection().idCol}=?", whereArgs: [noteID]);
  }

  //delete note by ID
  Future<int> deleteNote(int noteID) async {
    var database = await DatabaseConnection().getDatabase();
    return database.delete(DatabaseConnection().table,
        where: "noteID=?", whereArgs: [noteID]);
  }
}
