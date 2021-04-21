/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: event.dart
 */

import 'dart:convert';
import 'product.dart';
import 'order.dart';

/* Třída představující akci */
class Event {
  int id;
  String name;
  String date;
  List<Product> offer;
  List<Order> orders;

  Event();

  Event.fromMap(Map map)
  {
    id = map["id"] as int;
    name = map["name"] as String;
    date = map["date"] as String;
    if(map["offer"] != null) {
      offer = (map["offer"] as List).map((of) =>  Product.fromMap(of)).toList();
    }
    if(map["orders"] != null) {
      orders = (map["orders"] as List).map((or) => Order.fromMap(or)).toList();
    }
  }

  factory Event.fromString(String json)
  {
    final Map<String, dynamic> map = jsonDecode(json);
    return Event.fromMap(map);
  }

  Map asMap() =>
  {
    "name": name,
    "date": date,
  };

  bool offerContainProduct(String name)
  {
    for(Product p in offer) {
      if(p.name == name) {
        return true;
      }
    }
    return false;
  }

  double countTotalPrice()
  {
    double price = 0;
    for(Order o in orders) {
      for(Product p in o.products) {
        price += p.price;
      }
    }
    return price;
  }

  int countProducts()
  {
    int product = 0;
    for(Order o in orders) {
      product += o.products.length;
    }
    return product;
  }
}