/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: product.dart
 */

import 'dart:convert';
import 'ingredient.dart';

/// Třída představující produkt */
class Product {
  int id;
  String name;
  String picture; 
  double price = 0;
  List<Ingredient> composition;

  Product();

  Product.fromMap(Map map){
    id = map["id"] as int;
    name = map["name"] as String;
    picture = map["picture"] as String;
    price = map["price"] as double;
    if(map["composition"] != null) {
      composition = (map["composition"] as List).map((i) => Ingredient.fromMap(i)).toList();
    }
  }
  
  /// Konstruktor */
  factory Product.fromString(String json) {
    //final = once assigned a value, a final variable's value cannot be changed
    final Map<String, dynamic> map = jsonDecode(json);
    return Product.fromMap(map);
  }

  void setPriceFromString(String price)
  {
    this.price = double.parse(price);
  }

  String getStringFromPrice()
  {
    return price.toString();
  }

  bool containIngredient(String name)
  {
    for(Ingredient i in composition) {
      if(i.name == name) {
        return true;
      }
    }
    return false;
  }
}