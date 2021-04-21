import 'dart:async';

import 'package:controller/src/models/order.dart';
//import 'mock_ingredients.dart';

import 'package:controller/src/databaseHandle.dart';

class OrderService {
  Future<List<Order>> getAll() async => null; 
   
  Future<Order> get(int id) async =>
    (await getAll()).firstWhere((order) => order.id == id);
}