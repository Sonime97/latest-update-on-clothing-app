import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile.dart';
import 'package:provider/provider.dart';
import 'data_provider_class.dart';
import 'searchPage.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'customDelegate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_detail_screen.dart';
import 'ShipmentPage.dart';
import 'carousel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cartScreen.dart';
import 'customDelegate.dart';
import 'database.dart';
import 'test.dart';
import 'appDrawer.dart';

class Adjustment extends StatefulWidget {
  const Adjustment({Key? key}) : super(key: key);

  @override
  State<Adjustment> createState() => _AdjustmentState();
}

class _AdjustmentState extends State<Adjustment>
    with SingleTickerProviderStateMixin {
  final List<Map> adjustItems = [];
  late Future<List<Map>> _futureProducts;
   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _gridKey = GlobalKey<AnimatedListState>();
// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _futureProducts = letHaveIt();
  }

  Future<List<Map>> letHaveIt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(Uri.parse(
          'https://moniepoint-2795d-default-rtdb.firebaseio.com/.json'));

      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        if (data['products'] != null) {
          data['products'].forEach((key, value) {
            if (adjustItems.isEmpty ||
                adjustItems.length < data['products'].length) {
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

  void toggleFavoriteStatus(item) async {
    bool currentStatus = item['favorite'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(item['name'], !currentStatus);
    setState(() {
      item['favorite'] = !currentStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var items = Provider.of<DataModel>(context).products;
    final names = Provider.of<DataModel>(context).allname;
    // var _futureProducts = letHaveIt();
    //  final images =  Provider.of<DataModel>(context).images;
    final cartItem = Provider.of<DataModel>(context).cart;
    int _currentIndex = 0;

    final List<Widget> _pages = [];
    var searchNames = Provider.of<DataModel>(context).allname;
    

    void dispose() {
      //   favoriteNotifier.dispose();
      super.dispose();
    }

// Future<List<Map>> futureProducts = letHaveIt();

    return Scaffold(
       //  key: _scaffoldKey,
      
       drawer: Theme(
         data: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
    ),
  ),
        child: AppDrawer()),
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromARGB(255, 218, 217, 217),
        
        body: FutureBuilder<List<Map>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available.'));
                  } else {
                    final productList = snapshot.data!;
                    return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
             //   leading: Builder(
              //    builder: (context) => IconButton(
              //      icon: FaIcon(
            //          FontAwesomeIcons.bars,
            //          color: Colors.black,
            //        ),
              //      onPressed: () {
             //        Scaffold.of(context).openDrawer();
                     // Scaffold.of(context).openDrawer();
             //       },
            //      ),
            //    ),
                elevation: 0,
                floating: true, // Makes the app bar disappear when scrolling down
                pinned: false, // Keeps the app bar hidden when scrolling down
                actions: [
                  Container(
                    padding: EdgeInsets.all(3),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                            namess: searchNames,
                            items: adjustItems,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.cartShopping,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
               SliverToBoxAdapter(
                 child: Row(
                          children: [
                            Padding(
                                       padding: EdgeInsets.only(left: 16),
                                          child: Text('Find Your Style',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21)
                                          ),
                                        
                                        )
                                    ],
                        ),
               ),
              SliverToBoxAdapter(child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                            height: 200,
                            child: //Text('hello there')
                                CarouselWithIndicatorDemo()),
                      ),),
                      SliverToBoxAdapter(child: Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                              'New Arrival',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                key: _listKey,
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
                                              builder: (context) => ProductDetailScreen(productDetail: [adjustItems[index]]),
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
                    ),
                  ],
                ),
              ),
            SliverToBoxAdapter(child: 
                        
                        Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text('Best Seller',style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                          
                      
                      ),),
               //       SliverToBoxAdapter(child: SizedBox(height: 10),),
                    //  SizedBox(height: 10),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 200.0, // Set the height of the horizontal GridView
                    child: GridView.builder(
      key: _gridKey,
      padding: EdgeInsets.all(0.0),
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
                ),
              ),
              
              // The rest of your slivers and content go here
            ],
      );
                    /*  ListView.builder(
                  itemCount: adjustItems.length,
                  itemBuilder: (context, index) {
                    final product = productList;
                    return ListTile(
                      title: Text('ariana'),
                      subtitle: Text('sos'),
                      // Other UI elements...
                    );
                  },
                );*/
                  }
                })
          
        );
  }
}
