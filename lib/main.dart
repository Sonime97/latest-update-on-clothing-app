import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:sonime_app/authenticate.dart';
import 'home_page.dart';
import 'data_provider_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splashScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
       
       
      MyApp(),
    
    );
}
// i was tring to work on the authq 
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => DataModel())],
        child: MaterialApp(
          theme: ThemeData(
            colorSchemeSeed: Color.fromARGB(255, 84, 33, 225),
            // add this line
            useMaterial3: true,
             iconTheme: IconThemeData(
    color: Colors.black, // Change the color to your desired color
  ),

            
          ),
          home:
            SplashScreen() 
     
     // Authenticate(),
          )
    );
      
        
      //  HomePage()); 
    
    
  }
}