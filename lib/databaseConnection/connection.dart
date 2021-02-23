import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  String dbName = "mynotes.db";
  String table = "mynotes";
  String titleCol = "title";
  String contentCol = "content";
  String idCol = "noteID";
  String dateCol = "noteDate";
  String titleColorCol = "titleColor";
  String titleFontSizeCol = "titleFontSize";
  Database database;
  Future<Database> getDatabase() async {
    if (this.database != null) {
      return this.database;
    } else {
      this.database = await this.initializeDatabase();
      return this.database;
    }
  }

  Future<Database> initializeDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var databasePath = join(directory.path, this.dbName);
    return await openDatabase(databasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE $table($idCol INTEGER PRIMARY KEY  NOT NULL,$titleCol TEXT,$contentCol TEXT,$dateCol TEXT,$titleColorCol TEXT,$titleFontSizeCol INTEGER)");
    });
  }
}
