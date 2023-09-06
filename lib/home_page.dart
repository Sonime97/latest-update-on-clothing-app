// ignore_for_file: prefer_const_constructors
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'data_provider_class.dart';
import 'searchPage.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'customDelegate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'product_detail_screen.dart';
import 'ShipmentPage.dart';
import 'carousel.dart';
import 'streambuilder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cartScreen.dart';
import 'customDelegate.dart';
import 'database.dart';
import 'test.dart';
import 'appDrawer.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with 
SingleTickerProviderStateMixin  {
 // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
 //  final FirebaseMessaging _firebase_messaging = FirebaseMessaging.instance;
   // Color to transition to
  late AnimationController _controller;
 // late Animation<double> _animation;
  late Animation<double> _animatePadding;
  late AnimationController _controllerFav;
  final List<Map> adjustItems = [];
  late Future<List<Map>> _futureProducts;
 var data;
 
 Future <List<Map>> letHaveIt() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final response = await http.get(Uri.parse('https://moniepoint-2795d-default-rtdb.firebaseio.com/.json'));

    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      if (data['products'] != null) {
        data['products'].forEach((key, value) {
          if(adjustItems.isEmpty ||adjustItems.length < data['products'].length) {
    
    // bool isFavorite = prefs.getBool(value['name']) ?? false; // Get the current favorite status
        bool isFavorite = prefs.getBool(value['name']) ?? false;
        adjustItems.add({...value, 'favorite': isFavorite});
        //    adjustItems.add({...value}); 
      // adjustItems.add(value);
     //   prefs.setBool(value['name'], false);
    //    if(prefs.getBool(value['name']) == null) {
    //  prefs.setBool(value['name'], false);
   // }
       

    

        }
 

          
        });
        
      }
    } else {
      print('HTTP Request failed with status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching data: $error');
  }
  return adjustItems;  
 
}
 @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _futureProducts = letHaveIt();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<DataModel>(context).getProducts();
  }
  void toggleFavoriteStatus(item) async {
  bool currentStatus = item['favorite'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(item['name'], !currentStatus);
    setState(() {
      item['favorite'] = !currentStatus;
    });
  }

  @override
  Widget build(BuildContext context)  {
 

 
var searchNames = Provider.of<DataModel>(context).allname;
 
  
    var images = Provider.of<DataModel>(context).images;
    var selected;

    return Scaffold(
      
        extendBodyBehindAppBar: true,
     
      drawer:  IconTheme(
        data: IconThemeData(color: Colors.white), // Set the color here
        child: AppDrawer(),
      ),
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Sets the AppBar background color to transparent
           leading: Builder(
          builder: (context) => IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bars,
              color: Colors.black
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            })),
          elevation: 0,
        //  title: Center(child: Text('ShopEasy',
      //    style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
      //    ,
          
          
          actions: [
            Container(
              padding: EdgeInsets.all(3),
              child: IconButton(
               icon: FaIcon(FontAwesomeIcons.magnifyingGlass,color: Colors.black,size: 20),
               onPressed: () {
                 showSearch(context: context, delegate: CustomSearchDelegate(
                  namess: searchNames,items: adjustItems// Provide appropriate data
                    // Provide appropriate data
                ));
               } 
            )
            ),
            Container(
              padding: EdgeInsets.all(5),
             child: IconButton(
               icon: FaIcon(FontAwesomeIcons.cartShopping,color: Colors.black,size: 20),
               onPressed: () {
                Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Adjustment()  
         //   CartScreen()
            ),
          );
              

               } 
            )
            ),
          ],
        ),
        body: FutureBuilder<List<Map>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          
         else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          } else {
            final productList = snapshot.data!;
            return SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10),
           //   EdgeInsets.all(10),
              child: Container(
              //  height: 850,
                // MediaQuery.of(context).size.height,
                // column of everythin on the page
                child: Column(children: [
                //  SizedBox(height: 60),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.all(8),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text('Find Your Style',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21)
                                    ),
                                  )
                                  )
                              ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                        height: 200,
                        child: //Text('hello there')
                            CarouselWithIndicatorDemo()),
                  ),
                  // for new arrival
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                          'New Arrival',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                  // grid for new arrival
                        SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productList.length, // Replace with the actual number of items
                          itemBuilder: (BuildContext context, int index) {
                            return 
                                  Container(
                                    height:
                                        200,
                                        width: MediaQuery.of(context).size.width / 3, // Adjust the width of the container to control the card size
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            5.0), // Adjust the spacing between cards
                                    child: GestureDetector(
                                      onTap: () {
                                         Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ProductDetailScreen(productDetail: [productList[index]]),
                                      ),);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25.0),
                                        child: Card(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 110,
                                                width: MediaQuery.of(context).size.width/3,
                                                child: AspectRatio(
                                                  
                                                  aspectRatio: MediaQuery.of(context).size.width / 3 / 110,
                                                  child: Image.network(
                                                    '${productList[index]['image']}',
                                                  // Adjust the image height
                                                     // Make the image fill the container width
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 2), // Adjust the spacing
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                              width: 160,
                                              child: Text(
                                                  '${productList[index]['name']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ),
                                          ),
                                          
                                          SizedBox(height: 2), // Adjust the spacing
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                           //   mainAxisAlignment:
                                           //       MainAxisAlignment.spaceBetween,
                                              children: [
                                               Text('#',style: TextStyle(color: Colors.green)),
                                               Text(
                                                      '${productList[index]['price']}',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold)),
                                                
                                       //       Padding(
                                        //          padding: EdgeInsets.all(8.0),
                                         //         child: Icon(Icons.favorite_border))
                                              ],
                                            ),
                                          )
                                              
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  
                               
                            ;
                          })
                          ),
                  // grid for best seller
                  SizedBox(height: 20),
                  Padding(
                    padding:EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text('Best Seller',style: TextStyle(fontWeight: FontWeight.bold))
                      ),
                  ),
                  SizedBox(height: 10),
                
                Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.topLeft, 
                      height: 200,
                      child: GridView.builder(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
      itemCount: productList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Adjust this value based on your desired number of items in a row
        childAspectRatio: 0.9,
         crossAxisSpacing: 10.0, // Add spacing between adjacent grids
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
      //  final product = products[index];
          
        
        return   Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                            child: AspectRatio(
                              aspectRatio: 0.9,
                              child: GestureDetector(
                                onTap: () {
                                     Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productDetail: [productList[index]]),
            ),);
                                  },
                                 
                                  child: ClipRRect(
                                     borderRadius: BorderRadius.circular(15.0),
                                    child: Hero(
                                      tag: '${productList[index]['image']}', 
                                      child: Image.network(
                                        '${productList[index]['image']}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                
                              ),
                            ),
                        ),
                    
                    
                  ],
                ),
                Positioned(
              top: 8.0,
              right: 8.0,
              child: Container(
                padding: EdgeInsets.all(4.0),
                color: Colors.black.withOpacity(0.5),
                child: IconButton(
                  onPressed: () async {
                    
                    SharedPreferences prefs = await SharedPreferences.getInstance();
        
                   // print(prefs.getString('product0'));
                  toggleFavoriteStatus(productList[index]);
                   // changeFav(index);
               //     print(them);
                    
                  }, 
                   icon: (productList[index]['favorite']) ? Icon(Icons.favorite,color: Colors.pink) : Icon(Icons.favorite_border)
                   // Icon(Icons.favorite)
                      
                  // (favs[index]['name']) ? Icon(Icons.favorite,color: Colors.pink) : Icon(Icons.favorite_border), 
                //   
               // Icon(Icons.favorite)
                  
                   
                   
                 
                 
        
                ), 
              ),
            ),
                Positioned(
          bottom: 0,
          left: 0, // Adjust the alignment as needed
          right: 0, // Adjust the alignment as needed
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)),
              color: Colors.black54,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${productList[index]['name']}',
                    style: TextStyle(color: Colors.white, fontSize: 10, overflow: TextOverflow.ellipsis),
                  ),
                ),
                Text(
                  '#${productList[index]['price']} ',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10)
              ],
            ),
          ),
        ),

              ],
                        );
       
        
        }
        )
        ),
                  )  
                ]),
              )),
        );
        
  }
}));}}
