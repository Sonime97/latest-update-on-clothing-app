import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
class DatabaseHelper {
 static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

   Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final path = join(await getDatabasesPath(), 'odikemark.db');
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE my_cart(id INTEGER PRIMARY KEY, cartItem TEXT)',
        );
      },
    );
    return database;
  }

  Future<void> insertData(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('my_cart',
     {'cartItem': json.encode(item)},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
   Future<void> insertCartItem(Map<String, dynamic> item) async {
    await insertData(item);
  }
   Future<void> deleteItem(Map<String, dynamic> item) async {
    final db = await database;
    final itemName = item['name']; // Assuming 'name' is a unique identifier
    await db.delete('my_cart', where: 'cartItem LIKE ?', whereArgs: ['%$itemName%']);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;
    final List<Map<String, dynamic>> rawData = await db.query('my_cart');
     // Convert JSON strings back to Map
    final List<Map<String, dynamic>> dataList = rawData.map((data) {
      final jsonData = jsonDecode(data['cartItem']);
      return {
        'name': jsonData['name'],
        'image': jsonData['image'],
        'info': jsonData['info'],
        'price': jsonData['price'],
        
      };
    }).toList();
    return dataList;
    
  }
}
