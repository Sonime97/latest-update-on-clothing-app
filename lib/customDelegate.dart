import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_detail_screen.dart';
import 'data_provider_class.dart';
class CustomSearchDelegate extends SearchDelegate {
// Demo list to show querying
List namess;
List items;

CustomSearchDelegate({required this.namess,required this.items});

// first overwrite to
// clear the search text
@override
List<Widget>? buildActions(BuildContext context) {
	return [
	IconButton(
		onPressed: () {
		query = '';
		},
		icon: Icon(Icons.clear),
	),
	];
}

// second overwrite to pop out of search menu
@override
Widget? buildLeading(BuildContext context) {
	
  return IconButton(
	onPressed: () {
		close(context, null);
    print(namess);
	},
	icon: Icon(Icons.arrow_back),
	);
}

// third overwrite to show query result
@override
Widget buildResults(BuildContext context) {
	List<String> matchQuery = [];
	for (var fruit in namess) {
	if (fruit.toLowerCase().contains(query.toLowerCase())) {
		matchQuery.add(fruit);
	}
	}
	return ListView.builder(
	itemCount: matchQuery.length,
	itemBuilder: (context, index) {
		var result = matchQuery[index];
		return ListTile(
		title: Text(result),
		);
	},
	);
}

// last overwrite to show the
// querying process at the runtime
@override
Widget buildSuggestions(BuildContext context) {
	final product = Provider.of<DataModel>(context).products;
  final images = Provider.of<DataModel>(context).images;
  List<dynamic> matchQuery = [];
	for (var fruit in namess) {
	if (fruit.toLowerCase().contains(query.toLowerCase())) {
		matchQuery.add(fruit);
	}
	}
	final it = Provider.of<DataModel>(context).products;
  return ListView.builder(
	
  itemCount: matchQuery.length,
	itemBuilder: (context, index) {
		var result = matchQuery[index];
		return GestureDetector(
          onTap: () {
           print(it[index]);
              Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productDetail: [it[index]]),
          ),
          );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            height: 100,
            child: Card(
              child: ListTile(
              leading: Container(
          
            padding: EdgeInsets.all(5),
            
            decoration: BoxDecoration( 
              shape: BoxShape.circle,
              
              ),
           
            child: Image.network(images[index])
            ),
          title: Text(result),
              ),
            ),
          ),
        );
	},
	);
}
}
