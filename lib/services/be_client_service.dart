// services/be_client_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/client.dart';

class BEClientService {
  static Database? _database;
  static const String tableName = 'clients';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'clients.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            email TEXT,
            telephone TEXT,
            adresse TEXT,
            ville TEXT,
            codePostal TEXT,
            dateCreation TEXT NOT NULL,
            derniereMaj TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertClient(Client client) async {
    final db = await database;
    await db.insert(
      tableName,
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Client>> getClients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Client.fromMap(maps[i]));
  }

  Future<Client?> getClient(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Client.fromMap(maps.first);
  }

  Future<void> updateClient(Client client) async {
    final db = await database;
    await db.update(
      tableName,
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<void> deleteClient(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllClients() async {
    final db = await database;
    await db.delete(tableName);
  }
}
