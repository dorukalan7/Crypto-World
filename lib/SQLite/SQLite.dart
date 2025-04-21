import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Kullanıcı verisini temsil eden model
class User {
  int? id;
  String name;
  String surname;
  int age;
  String email;

  User({
    this.id,
    required this.name,
    required this.surname,
    required this.age,
    required this.email,
  });

  // Veritabanına uygun hale getirme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'age': age,
      'email': email,
    };
  }

  // Veritabanından alırken dönüşüm
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      age: map['age'],
      email: map['email'],
    );
  }
}

// Veritabanı işlemlerini yöneten sınıf
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Veritabanını açma işlemi
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  // Veritabanını başlatma
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDb = join(dbPath, path);
    return await openDatabase(pathToDb, version: 1, onCreate: _onCreate);
  }

  // Veritabanı oluşturma
  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        surname $textType,
        age $integerType,
        email $textType
      )
    ''');
  }

  // Kullanıcı ekleme
  Future<int> addUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  // Kullanıcıları listeleme
  Future<List<User>> getUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // Kullanıcı silme
  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
