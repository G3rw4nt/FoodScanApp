import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Product
{
  final String ean;
  final String name;
  final String ingredients;

  Product({required this.ean, required this.name, required this.ingredients});

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    ean: json['ean'], 
    name: json['name'], 
    ingredients: json['ingredients']
    );
  
  Map<String,dynamic> toMap() {
    return {
      'ean': ean,
      'name': name,
      'ingredients': ingredients
    };
  }
}