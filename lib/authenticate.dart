import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonime_app/home_page.dart';
import 'package:sonime_app/signIn.dart';
import 'data_provider_class.dart';
import 'data_provider_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signIn.dart';
class Authenticate extends StatefulWidget {
  const Authenticate({ Key? key }) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String? tk;
  void getToken () async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
 setState(() {
   tk = prefs.getString('token');
 });
  }
  @override void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }
  @override
  Widget build(BuildContext context) {
    
   // final data = Provider.of<DataModel>(context);
   if (tk != null) {
      // Token is present, user is authenticated, show the home page
      return HomePage();
    } else if (tk == null){
      // Token is null, user is not authenticated, show the sign-in page
      return SignIn();
    } else {
      return Text('fail safe');
    }
    
  }
}
