import 'package:flutter/material.dart';
import 'cartScreen.dart';
import 'package:provider/provider.dart';
import 'data_provider_class.dart';
import 'searchPage.dart';
import 'home_page.dart';
import 'customDelegate.dart';
import 'profile.dart';
class AppDrawer extends StatelessWidget {
  final List<String> items = [
    'Home',
    'Profile',
    'Search',
    'Cart'
  ];
   


  @override
  Widget build(BuildContext context) {
    final names =  Provider.of<DataModel>(context).allname;
    final them = [];
    void _navigateToPage(BuildContext context, String item) {
    // Add navigation logic here based on the item
    // For example:
    if (item == 'Home') {
     Navigator.pop(context);
    } else if (item == 'Profile') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
    } else if (item == 'Cart') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
    } 
    // ... and so on for other items
  }
    return Drawer(
     
      child: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              height: 60,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 106, 66, 248),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  )],
                ),
              ),
            );
          }
          final item = items[index - 1];

          return GestureDetector(
            onTap: () {
             if (item == 'Search') {
                // Navigate to the custom search delegate page
                showSearch(context: context, delegate: CustomSearchDelegate(
                  namess: names,items: them// Provide appropriate data
                    // Provide appropriate data
                ));
            //    Navigator.pop(context);
              } else {
                _navigateToPage(context, item);
              }

            //  _navigateToPage(context, item); // Navigate based on the item
            },
            child: ListTile(
              title: Text(item),
              
            ),
          );
        },
      ),
    );
  }
}