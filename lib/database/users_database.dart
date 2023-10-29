import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_sign_in.dart';

class UsersDatabase {
  static final UsersDatabase instance = UsersDatabase._init();

  static Database? _database;

  UsersDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableUsers ( 
  ${UserFields.id} $idType, 
  ${UserFields.name} $textType,
  ${UserFields.email} $textType,
  ${UserFields.password} $textType,
  ${UserFields.time} $textType
  )
''');
  }

  Future<User> create(User user) async {
    final db = await instance.database;

    final id = await db.insert(tableUsers, user.toJson());
    return user.copy(id: id);
  }

  Future<User> readUser(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableUsers,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<User> checkCredentials(String name) async {
    final db = await instance.database;

    final maps = await db.query(
      tableUsers,
      columns: UserFields.values,
      where: '${UserFields.name} = ?',
      whereArgs: [name],
    );

    // final maps  = await db.rawQuery("SELECT * from $tableUsers limit 1");

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $name not found');
    }
  }

  Future<List<User>> readAllUsers() async {
    final db = await instance.database;

    final orderBy = '${UserFields.time} ASC';

    final result = await db.query(tableUsers, orderBy: orderBy);

      return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> update(User User) async {
    final db = await instance.database;

    return db.update(
      tableUsers,
      User.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [User.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableUsers,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
