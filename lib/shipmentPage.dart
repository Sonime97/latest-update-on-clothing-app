import 'package:flutter/material.dart';
class ShipmentPage extends StatefulWidget {
  const ShipmentPage({ Key? key }) : super(key: key);

  @override
  State<ShipmentPage> createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: Center(
      child: Text('hi there'),  
      )),
    );
  }
}