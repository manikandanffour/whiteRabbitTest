import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE users(profileImage TEXT NOT NULL,name TEXT NOT NULL,userName TEXT NOT NULL,email TEXT NOT NULL,address TEXT NOT NULL,phone TEXT NOT NULL,website TEXT NOT NULL,companyDetails TEXT NOT NULL)",
    //age INTEGER NOT NULL, country TEXT NOT NULL, email TEXT
        );
      },
      version: 1,
    );
  }
}
