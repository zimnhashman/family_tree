import 'package:mike_family_tree/models/person_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'family_tree.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE family_members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        relationship TEXT,
        parentId INTEGER,
        userId INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future<int> insertPerson(Person person) async {
    final db = await database;
    return await db.insert('family_members', person.toMap());
  }

  Future<List<Person>> getFamilyMembersForUser(int? parentId, int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'family_members',
      where: 'parentId = ? AND userId = ?',
      whereArgs: [parentId, userId],
    );

    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return maps.first; // Return the first user found
    }
    return null; // Return null if no user matches the credentials
  }

  Future<int> registerUser(String username, String password) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }
}
