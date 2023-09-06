import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_provider_class.dart';

import 'authenticate.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
    var name;
    var email;
    Future<void> _getStoredText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? n = prefs.getString('name');
    String? e = prefs.getString('email');
    setState(() {
      name = n;
      email = e;
    });
      // Replace 'stored_text' with your own key
    print(name);
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStoredText();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 84, 19, 247),
      appBar: AppBar(elevation: 0,
    
      backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child:  Column(children: [
              SizedBox(height: 50),
              Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Profile',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25))]),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: Column(
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 236, 236, 236),
              child: Icon(Icons.person,size: 40,color: Colors.black),
              radius: 40,
            //  backgroundImage: NetworkImage('your_image_url.jpg'),
            ),
                    ],
              ),
              SizedBox(height: 10),
                Container(child: Text('${name}',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))
                  ],
                )
              ),
              SizedBox(height: 10),
              Center(child: Container(
                decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                ),
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Row(
                    children: [Text('Name: '),SizedBox(width: 10),Text('${name}')]
                  ),
                  SizedBox(height: 10),
                  Row(   children: [Text('Email: '),SizedBox(width: 10),Text('${email}')]
                 ),
                 SizedBox(height: 10),
                  Row(   children: [Text('Number of transactions'),SizedBox(width: 10),Text('NAN')]
                  ),
                  SizedBox(height: 10),
                  Row(children: [Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(228, 232, 200, 22),
                                onPrimary: Colors.black,
                              ),
                    onPressed: () {
                    Provider.of<DataModel>(context, listen:false).logout();
                    Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Authenticate(),
              ))
                   ;
                  }, child: Text('Logout')))])
                ]),
              )))
            
              
            ]),
          ),
      )
    ) 
    ;
  }
}