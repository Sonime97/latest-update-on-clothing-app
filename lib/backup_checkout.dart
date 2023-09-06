import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({ Key? key }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final String currency = FlutterwaveCurrency.NGN;
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController amount = TextEditingController();
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter + Flutterwave'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
               child: Form(
              key: formKey,
           child:Column(
            children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: fullname,
                decoration: const InputDecoration(labelText: "Full Name"),
                     validator: (value) =>
                        value!.isNotEmpty? null : "Please fill in Your Name",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
                 validator: (value) =>
                        value!.isNotEmpty? null : "Please fill in Your Phone number",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) =>
                        value!.isNotEmpty? null : "Please fill in Your Email",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: amount,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (value) =>
                        value!.isNotEmpty? null : "Please fill in the Amount you are Paying",
                  ),
            ),
            ElevatedButton(
              child: const Text('Pay with Flutterwave'),
              onPressed: () {
                final name = fullname.text;
                        final userPhone = phone.text;
                        final userEmail = email.text;
                        final amountPaid = amount.text;
        
                        if (formKey.currentState!.validate()) {
                          _makeFlutterwavePayment(
                              context, name, userPhone, userEmail, amountPaid);
                        }
              },
            ),
          ]))),
        ));
  }
  // adding method 
  void _makeFlutterwavePayment(BuildContext context, String fullname, String phone, String email, String amount) async {
    try {
      Flutterwave flutterwave = Flutterwave.forUIPayment(
          //the first 10 fields below are required/mandatory
          context: this.context,
          fullName: fullname,
          phoneNumber: phone,
          email: email,
          amount: amount,
          //Use your Public and Encription Keys from your Flutterwave account on the dashboard
          encryptionKey: "FLWSECK_TEST8ba3909f8351",
          publicKey: "FLWPUBK_TEST-e3ba8950dcf513b8c617aa061bda62e0-X",
          currency: currency,
          txRef: DateTime.now().toIso8601String(),
          //Setting DebugMode below to true since will be using test mode.
          //You can set it to false when using production environment.
          isDebugMode: true,
          //configure the the type of payments that your business will accept
          acceptCardPayment: true,
          acceptUSSDPayment: false,
          acceptAccountPayment: false,
          acceptFrancophoneMobileMoney: false,
          acceptGhanaPayment: false,
          acceptMpesaPayment: false,
          acceptRwandaMoneyPayment: false,
          acceptUgandaPayment: false,
          acceptZambiaPayment: false
          );
          final response = await flutterwave.initializeForUiPayments();
      if (response == null) {
        
      } else {
        if (response.status == "Transaction successful") {
         _showsuccessfulTransactionDialog(context);
         // print(response.data);
          print(response.message);
        } else {
          _showFailedTransactionDialog(context);
          print(response.message);
        }
      }

}catch(e) {
  print(e);
}}
  }
  