import 'dart:async';

import 'package:sonime_app/db.dart';
import 'orderPage.dart';
import 'database.dart';
import 'package:flutter/material.dart';
import 'checkoutScreen.dart';
import 'cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'Data_provider_class.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/subaccount.dart';

class CartScreen extends StatefulWidget {
  // var cartItems;
  // CartScreen({required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
// please work on integrating the image and add someother things
//   Future<List<Map<String, dynamic>>> getProductsFromDatabase() async {
  // final db = await database;
  // final List<Map<String, dynamic>> maps = await db.query('products');
  // return maps.map<Map<String, dynamic>>((map) {
  //   return jsonDecode(map['data']);
//  }).toList();
// }
  final dbHelper = DatabaseHelper();
  void initState() {
    doit();
  }

  Future doit() async {
    var t = await dbHelper.getAllData();
    setState(() {
      cart = t;
    });
  }

  List cart = [];
  int itemNum = 0;
  void _showFailedTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Failed'),
          content: Text('Sorry, the transaction was not successful.'),
          actions: <Widget>[
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

  void _showsuccessfulTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction success'),
          content: Center(
              child: Text('Your transaction successful.',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreen(),
                  ),
                );
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
    //   print(widget.cartItems);
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
    int sum = cart.fold(0,
        (previousValue, item) => previousValue + (item['price'] as int? ?? 0));
    void gotoOrder() {
      Timer(Duration(seconds: 5), () {
        // Navigate to the new screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen()),
        );
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.transparent, // Set the AppBar background to transparent
          elevation: 0, // Remove the shadow under the AppBar
          title: Center(
              child: Text(
            'My Cart',
            style: TextStyle(color: Colors.black),
          )),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.black),
        ),
        body: (cart.isEmpty)
            ? Center(child: Text('Your Cart is empty'))
            : Container(
                child: Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 120,
                          child: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                                width: 80,
                                      height: 90,
                                     // ${cartItems[index]['image']}
                                     
                                      child: 
                                      //to make the image at the middle of the card
                                      ClipRRect(
                                           borderRadius: BorderRadius.circular(10.0),
                                          child: Image.network('${cart[index]['image']}',
                                          fit: BoxFit.fill
                                          ),
                                        ),
                                ),
              ),
                              SizedBox(width: 10),
                               Padding(
                                 padding: EdgeInsets.all(5),
                                 child: Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Container(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Text('${cart[index]['name']}')),
                                      SizedBox(height: 8,),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text('#${cart[index]['price']}',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                               
                                      
                                    ],
                                  )),
                               ),
                                
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [IconButton(onPressed: () async {
                                   await dbHelper.deleteItem(cart[index]);
                                   var re = await dbHelper.getAllData(); 
                                   setState(() {
                                     cart = re;
                                   });
                                    }, icon: Icon(Icons.delete)
                                    )],
                                ), 
                            

              ]
            )
          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('${sum}',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                _makeFlutterwavePayment(sum);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(228, 232, 200, 22),
                                onPrimary: Colors.black,
                              ),
                              child: Text('checkout')),
                        )
                      ],
                    ),
                  )
                ]),
              ));
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }

  void _makeFlutterwavePayment(sum) async {
    try {
      final style = FlutterwaveStyle(
        appBarText: "My Standard Blue",
        buttonColor: Color(0xffd0ebff),
        buttonTextStyle: TextStyle(
          color: Colors.deepOrangeAccent,
          fontSize: 16,
        ),
        appBarColor: Color(0xff8fa33b),
        dialogCancelTextStyle: TextStyle(
          color: Colors.brown,
          fontSize: 18,
        ),
        dialogContinueTextStyle: TextStyle(
          color: Colors.purpleAccent,
          fontSize: 18,
        ),
        mainBackgroundColor: Colors.indigo,
        mainTextStyle:
            TextStyle(color: Colors.indigo, fontSize: 19, letterSpacing: 2),
        dialogBackgroundColor: Colors.greenAccent,
        appBarIcon: Icon(Icons.message, color: Colors.purple),
        buttonText: "Pay Now",
        appBarTitleTextStyle: TextStyle(
          color: Colors.purpleAccent,
          fontSize: 18,
        ),
      );
      final Customer customer = Customer(
          name: "FLW Developer",
          phoneNumber: '08082133024',
          email: "customer@customer.com");

      Flutterwave flutterwave = Flutterwave(
        //the first 10 fields below are required/mandatory
        context: this.context,
        txRef: DateTime.now().toIso8601String(),
        currency: 'NGN',
        paymentOptions: "card, payattitude",
        redirectUrl: "https://www.google.com",
        isTestMode: true,

        customization: Customization(title: "Test Payment"),
        customer: customer,

        amount: sum.toString(),
        //Use your Public and Encription Keys from your Flutterwave account on the dashboard
        //  encryptionKey: "FLWSECK_TEST8ba3909f8351",
        publicKey: "FLWPUBK_TEST-e3ba8950dcf513b8c617aa061bda62e0-X",

        //Setting DebugMode below to true since will be using test mode.
        //You can set it to false when using production environment.

        //configure the the type of payments that your business will accept
      );

      final ChargeResponse response = await flutterwave.charge();

      if (response.status == 'success') {
        _showsuccessfulTransactionDialog(this.context);

        //  this.showLoading(response.status!);
//      print("${response.toJson()}");
      } else {
        print('error');
//    }
      }
    } catch (e) {
      print(e);
    }
  }
}
