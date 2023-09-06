import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class MyData extends StatefulWidget {
  @override
  _MyDataState createState() => _MyDataState();
}

class _MyDataState extends State<MyData> {
  late Database _database;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'turning.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, data TEXT)',
        );
      },
      version: 1,
    );

    _fetchProducts();
  }

  Future<void> _insertProduct(Map<String, dynamic> product) async {
    await _database.insert(
      'products',
      {'data': jsonEncode(product)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final List<Map<String, dynamic>> maps = await _database.query('products');
    setState(() {
      _products = maps;
    });
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflite Map Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              final newProduct = {
                'name': 'New Product',
                'price': 50.0,
              };
              _insertProduct(newProduct);
            },
            child: Text('Add New Product'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = jsonDecode(_products[index]['data']);
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Price: ${product['price']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





