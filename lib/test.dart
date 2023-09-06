import 'package:flutter/material.dart';
import 'db.dart';
class Test extends StatefulWidget {
  const Test({ Key? key }) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  var danda;
  var thing; 
  @override
  void mee() async {
  setState(() {
    // danda = Db();
  //   danda.fetchProducts();
      thing =  danda.products;
    });

  }
  void initState() {
    // TODO: implement initState
    super.initState();
     mee();
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: Container(
      height: 500,
      child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Center(
                  child: ListTile(
                    title: Text('yolo',style: TextStyle(color: Colors.black)),
                    trailing: ElevatedButton(onPressed: () {
                      print(danda.products);
                    }, child: Text('click me')),
                    ),
                ),
              );
  }),
    ));
    }
}
