import 'package:flutter/material.dart';
import 'favIcon.dart';
class FavIcon extends StatefulWidget {
  String name;
  FavIcon({required this.name});
 // const FavIcon({ Key? key }) : super(key: key);

  @override
  State<FavIcon> createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  
@override
  
  void toggleFavorite() async {
    setState(() {
   //   isFavorite = !isFavorite;
    });
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
          icon: Icon(
   //         isFavorite ?
    Icons.favorite 
   // : Icons.favorite_border,
   //         color: isFavorite ? Colors.pink : Colors.grey,
          ),
          onPressed: toggleFavorite,
          iconSize: 48.0,
        );
      
  }
}