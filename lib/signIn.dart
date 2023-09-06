import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './data_provider_class.dart';
import 'dart:async';
import 'signUp.dart';
import 'authenticate.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FocusNode focusNode = FocusNode();
  final _emailRegexPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  @override
  void focusKeyboard() {
    FocusScope.of(context).requestFocus(focusNode);
  }
@override
void dispose() {
  // Cancel timers, remove listeners, and dispose of resources here
  super.dispose();
}






  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? _email;
    String? _password;

    // Simulate loading by setting _isLoading to true

    //   final token = Provider.of<DataModel>(context).token;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: (_isLoading)
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Text(
                        'Welcome',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      )),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            final regex = RegExp(_emailRegexPattern);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Password',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0)),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(children: [
                        Text('Don\'t Have An Account? ',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        GestureDetector(
                            child: Text('SignUp',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            })
                      ]),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // Perform sign-in logic here
                                  print('Email: $_email');
                                  print('Password: $_password');
                                  setState(() {
                                    _isLoading = !_isLoading;
                                  });
                                  await Provider.of<DataModel>(context,
                                          listen: false)
                                      .signin(_email.toString(),
                                          _password.toString());

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Authenticate()),
                                  );
                                  await Future.delayed(Duration(seconds: 5),() {setState(() {
                                    _isLoading = !_isLoading;
                                  });});
                                }
                              },
                              child: Text('Sign In'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
