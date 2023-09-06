import 'package:flutter/material.dart';
import 'home_page.dart';
import 'signIn.dart';
import 'package:provider/provider.dart';
import 'data_provider_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 // final FirebaseAuth _auth = FirebaseAuth.instance;
 final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _nameController = TextEditingController();  


  

  @override
  Widget build(BuildContext context) {
  // String? _name;
 //  String? _password;


 /// String? _token;
 //  String? _email;   
  
    return  Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(elevation: 0,
    
      backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 53),
            Text('ShopEasy',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
            Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                    child: TextFormField(
               //       controller: _emailController,
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email',border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        // You can use a regex to validate the email format
                        // For simplicity, we'll use a basic example here
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      
                      
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    
                    
                    decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                    child: TextFormField(
                      controller: _nameController,
                      
                      decoration: InputDecoration(labelText: 'Name',border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      
                     // onSaved: (value) => _name = value!,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password',border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      
                    //  onSaved: (value) => _password = value!,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                         if (_formKey.currentState!.validate()) {
      // Form is valid, save the data using shared_preferences
      Provider.of<DataModel>(context,listen:false).signUp(_emailController.text.trim(), _passwordController.text.trim());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', _emailController.text.trim());
      prefs.setString('name', _nameController.text.trim());
      prefs.setString('password', _passwordController.text.trim());
        Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
     // Navigator.pop(context);
   // await  Provider.of<DataModel>(context).signUp(_emailController.text.trim(), _passwordController.text.trim());
      
      // Navigate to a new screen or perform further actions
    }
                         
                         
 

                        },
                        child: Text('Submit'),
                      ),
                    )],
                  ),
                ],
              ),
            ),
    ),
          ],
        ),
      )


    );
  }
}