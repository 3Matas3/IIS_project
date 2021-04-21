import 'dart:async';
import 'dart:html';

import 'package:controller/src/models/event.dart';
import 'package:controller/src/databaseHandle.dart';
import 'package:controller/src/models/product.dart';
import 'package:controller/src/models/order.dart';

class EventService {
  Future<List<Event>> getAll() async => listEvents();

  Future<Event> get(int id) async =>
    (await getAll()).firstWhere((event) => event.id == id);

  Future<List<Product>> getOffer(int id) async => getEventOffer(id);

  Future<List<Order>> getOrders(int id) async => getEventOrders(id);
}