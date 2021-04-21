/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: order.dart
 */

import 'product.dart';
import 'dart:convert';


/// Třída představující objednávku */
class Order
{
  int id;
  double price;
  String status;
  List<Product> products;

  Order();

  /// Konstruktor */
  Order.fromMap(Map map)
  {
    id = map["id"] as int;
    price = map["price"] as double;
    status = map["status"] as String;
    if(map["products"] != null) {
      products = (map["products"] as List).map((i) => Product.fromMap(i)).toList();
    }
  }

  factory Order.fromString(String json)
  {
    Map map = jsonDecode(json);
    return Order.fromMap(map);
  }
}