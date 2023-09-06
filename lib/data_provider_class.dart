import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DataModel extends ChangeNotifier {
 
    
final List productList = []; 
 List _items = ['mac 1','mac 2','mac 3','mac 4','mac 5'];
  List images = [];
  var cart;
  List allname = [];
  
  String? _email;
  final List<Map> products = [];
  var image_list = [];

  

 get allitem => _items;
 
  Future<List> getIt() async {
  

  try {
    final response = await http.get(Uri.parse('https://moniepoint-2795d-default-rtdb.firebaseio.com/.json'));

    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      if (data['products'] != null) {
        data['products'].forEach((key, value) {
          productList.add(value);
        });
      }
    } else {
      print('HTTP Request failed with status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching data: $error');
  }
notifyListeners();
  return productList;  
 
}
  Future getProducts() async {
  //  SharedPreferences.setMockInitialValues({});
    
    var name;
    var id;
    final List<dynamic> streamItems = [];
      
 // SharedPreferences prefs = await SharedPreferences.getInstance(); 
 
    final response =
        await http.get(Uri.parse('https://moniepoint-2795d-default-rtdb.firebaseio.com/.json'));
    //https://clothings-54603-default-rtdb.firebaseio.com/.json    
    // print(response.body);
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
       data['products'].forEach((key, value) {
        if(streamItems.length < data['products'].length) {
       //  images.add(value['image']);
      //   allname.add(value['name']);
         streamItems.add(value);
       //  prefs.setBool(key, false);
      //   print(prefs.getString(key));

        }
       });
  
      data['products'].forEach((key,value) {
       // print(data['products']);
        if(products.length < data['products'].length) {
         images.add(value['image']);
         allname.add(value['name']);
         products.add(value);
      
        }
        
      });
    
       
     
     

    }
   // print(products);
   // print(image_list);
    notifyListeners();
    return streamItems;

    
  }
  Future<void> addOrder(List product,email) async {
  var orders = {
    'email': email,
    'orders': product};
var endpoint = 'https://moniepoint-2795d-default-rtdb.firebaseio.com/orders/.json';

try{
var response = await http.post(Uri.parse(endpoint),body: json.encode(orders));
if(response.statusCode == 200) {
  print('sent to db');
}
} catch(e) {

}

  }
  void logout() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.remove('token');
   
    notifyListeners();
    
  }
  Future<void>signUp(email,password) async {
   String signUptoken;
   SharedPreferences prefs = await SharedPreferences.getInstance();
   var endpoint = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyClNvjkgfuYzDgsK1HCFMRkGp2dnXeMhMg';
   try{
 final response = await http.post(Uri.parse(endpoint),
 body: json.encode({'email': email,'password': password,'returnSecureToken': true}));
var responseData = await jsonDecode(response.body);
if(response.statusCode == 200){
  signUptoken = responseData['token'];
  prefs.setString('token', signUptoken);
}

notifyListeners();

   } catch(e) {
    print('error signing in');
   } 
  }

  
  Future <void>signin(email,password) async {
      String token;
    SharedPreferences prefs = await SharedPreferences.getInstance();   
   var endpoint = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyClNvjkgfuYzDgsK1HCFMRkGp2dnXeMhMg';
  try{
final response = await http.post(Uri.parse(endpoint),
   
   body: json.encode({'email': email,'password': password,'returnSecureToken': true}));
   
   var responseData = await jsonDecode(response.body);
    if (response.statusCode == 200) {
       token = responseData['idToken'];
     
    } else {
      final error = responseData['error']['message'];
      print('Sign-in error: $error');
      return null;
    }
   
 // print(data);
   // var Details = UserDetails.fromJson(data);
  
   // _email = Details.email;
    prefs.setString("token", token);
   // return token;
   notifyListeners();
  } catch(e) {
    print('error occured');
  }
 void addItem() {
  _items.add('mac 10');
  notifyListeners();
 }
  }
  }