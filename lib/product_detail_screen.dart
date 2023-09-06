import 'package:flutter/material.dart';
import 'data_provider_class.dart';
import 'productinfo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'containerSize.dart';
import 'cart_model.dart';
import 'dart:convert';
import 'db.dart';
import 'package:provider/provider.dart';
class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({required this.productDetail});
 // const ProductDetailScreen({ Key? key }) : super(key: key);
 final productDetail;
 
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // int num = 0;
  var _items;
  int itemNum = 0;
   
  // late Database _database;
 // List<Map<String, dynamic>> _products = [];
 final dbHelper = DatabaseHelper();
 // var Data;
  @override
  void initState() {
    super.initState();
   _fetchItems();
   //   setState(() {
   //   Data = Db();  
   //   });
      
  // Data.initializeDatabase();
   // _initializeDatabase();
  }
  Future<void> _fetchItems() async {
    final items = await dbHelper.getAllData();
    setState(() {
      _items = items;
    });
  }

//  Future<void> _initializeDatabase() async {
//    _database = await openDatabase(
//      join(await getDatabasesPath(), 'cart_database.db'),
//      onCreate: (db, version) {
//        return db.execute(
//          'CREATE TABLE products(id INTEGER PRIMARY KEY, data TEXT)',
//        );
//      },
//      version: 1,
 //   );

  //  _fetchProducts();
 // }

//  Future<void> _insertProduct(Map<String, dynamic> product) async {
//    await _database.insert(
//      'products',
//      {'data': jsonEncode(product)},
//      conflictAlgorithm: ConflictAlgorithm.replace,
//    );
//    _fetchProducts();
//  }

//  Future<void> _fetchProducts() async {
//    final List<Map<String, dynamic>> maps = await _database.query('products');
//    setState(() {
//      _products = maps;
//    });
//  }

 // @override
 // void dispose() {
 //   _database.close();
  //  super.dispose();
 // }

  
     
  void _showAlreadyAddedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Product already Added to cart'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    }
    void showAddedToCartPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Added to Cart'),
          content: Text('The product has been added to your cart.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  void addnum() {
            
              setState(() {
                itemNum++;
              });
  }
  void subtractNum() { 
 
              setState(() {
                if (itemNum > 0) {
                  itemNum--;
                }
                
              });
  }
  @override
  
  Widget build(BuildContext context) {
  var cart = Provider.of<DataModel>(context).cart;
  void addToCart(item) async {
  
  List<Map<String,dynamic>> fill =  await dbHelper.getAllData();
  
  var rt; 
   if (!fill.any((map) =>
      map.keys.every((key) => item.containsKey(key) && map[key] == item[key]))) {
  // await dbHelper.insertData(item);
  await dbHelper.insertData(item);
  rt = await dbHelper.getAllData();
  setState(() {
    cart = rt;
  });
  showAddedToCartPopup(context);
  print('for sqflist of map');
  print(rt);

  
  
  print(rt);
  
 // print(r);
    
  } else {
    print("Map already exists in the list.");
    print(fill);
    _showAlreadyAddedDialog(context);
  }

  //  print(cart);
//   print(_items);
//  await Data.fetchProducts();
 // print(_products);
   // bool alreadyExists = false;
  //   bool alreadyExists = fill.any((map) => map['name'] == item['name']);
     
  
   
  
//print(fill);
//print(fill);
print('for map added ');
print(item);
  
 //   if (!cart.contains(item)) {
    //  print(_products);
    //  _insertProduct(item);
 //     setState(() {
 //       cart.add(item);
        
 //     });
 //     }else {
      
 //     }

  
  print(cart);
  }
  
   final details = widget.productDetail[0] as Map;  
    return Scaffold(
       extendBodyBehindAppBar: true, // This allows the body to go behind the AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Set the AppBar background to transparent
          elevation: 0, // Remove the shadow under the AppBar
          
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back),color: Colors.black),
        ),
        body: Stack(
          children: [
            // Image Widget
            
               Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height / 1.8,
                child: Hero(
                  tag: '${details['name']}',
                  child: Image.network(
                   details['image'],
                  
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // the overlaying thing 
            Positioned(
              top: 0,
              left: 0,
              right: 0,
             height: MediaQuery.of(context).size.height / 1.8,

             // height: MediaQuery.of(context).size.height / 2,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            // Details About the product
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height / 2,
              child: Container(
               //  alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: 
                  //column of the details
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Row(children: [Expanded(
                       child: Text('${details['name']}',
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                     )]),
                     SizedBox(height:10),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('#${details['price']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        // Container(
                        //  padding: EdgeInsets.all(2),
                        //  decoration: BoxDecoration(
                        //    shape: BoxShape.circle,
                        //    color: Color.fromARGB(255, 215, 213, 213)),
                        //  child: Icon(Icons.favorite,color: Colors.pink))
                       ],
                     ),
                     SizedBox(height: 10),
                     BorderContainerPage(info: details['info']),
                     SizedBox(height: 10),
                     // row for cart area at the bottom of the screen
                     Container(
                     //  padding: EdgeInsets.all(20),
                       child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            Expanded(
              child: ElevatedButton(onPressed: () async {
                
                  
             //   bool containsSameValue = fill.any((map) => map.containsValue(details['name']));
           
                
                
                print('name var');
             //   print(fill[0]['name']);                
                 
              //   print(fill);
                 print('whataguan');
                 print(details);        
                addToCart(details);},
              style:ElevatedButton.styleFrom(
                primary: Color.fromARGB(227, 244, 200, 57),
                onPrimary: Colors.black,
              ),
               child: Text('Add to Cart')),
            ),
          ],
        ),
                     ),

                     //product info
                     
                      ],
                  ),
                )
              ),
            ),
          ],
        ),
      

    );
  }
}
