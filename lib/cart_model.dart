import 'dart:convert';
import 'package:flutter/material.dart';
class CartModel {
  String name;
  String image;
  int price;
  int total;
  List<Map<String, dynamic>> data;
  CartModel({required this.name, required this.image, required this.price,required this.total,required this.data});
  Map<String, dynamic> toMap() {
    return {
      
      'name': name,
      'price': price,
      'image': image,
      'total': total,
      'data': data != null ? jsonEncode(data) : null, // Serialize the list of maps to JSON
    };
  }
   factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      name: map['name'],
      image: map['image'],
      price: map['price'],
      total: map['total'],
      data: map['data'] != null ? jsonDecode(map['data']) : null, // Deserialize JSON to list of maps
    );
  }
}