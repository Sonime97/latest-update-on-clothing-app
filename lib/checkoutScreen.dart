import 'package:flutter/material.dart';
// import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
// import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
 // const CheckoutScreen({ Key? key }) : super(key: key);
  CheckoutScreen({required this.total});
  final total;
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
 // final String currency = FlutterwaveCurrency.NGN;
 
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
          content: Center(child: Text('Your transaction successful.',style: TextStyle(fontWeight: FontWeight.bold))),
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
  @override
  Widget build(BuildContext context) {
 //   this.currencyController.text = this.selectedCurrency;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout Screen'),
          centerTitle: true,
        ),
        body:Container(child:
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        SizedBox(height: 20),  
        Text('Your Total  Bill: ',style: TextStyle(fontSize:30),),
        SizedBox(height: 10),
        Text(widget.total.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
        ElevatedButton(onPressed: () {
          this._makeFlutterwavePayment();
        }, child: Text('Pay NOW'))]),
        ))
    );
  }

  Widget buildImageTextCard(String imageUrl, String text) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0), // half of width and height for a perfect circle
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(text),
        ],
      ));
  }
  // adding method 
   
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
    
  

  void _makeFlutterwavePayment() async {
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
      mainTextStyle: TextStyle(
        color: Colors.indigo,
        fontSize: 19,
        letterSpacing: 2
      ),
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
          
          amount: widget.total.toString(),
          //Use your Public and Encription Keys from your Flutterwave account on the dashboard
        //  encryptionKey: "FLWSECK_TEST8ba3909f8351",
          publicKey: "FLWPUBK_TEST-e3ba8950dcf513b8c617aa061bda62e0-X",
          
          
          //Setting DebugMode below to true since will be using test mode.
          //You can set it to false when using production environment.
          
          //configure the the type of payments that your business will accept
        
          );
                
    final ChargeResponse response = await flutterwave.charge();
    
   if (response != null) {
    _showsuccessfulTransactionDialog(context);
    //  this.showLoading(response.status!);
//      print("${response.toJson()}");
    } else {
      print('error');
//    }
    }

}catch(e) {
  print(e);
}}
  }
  