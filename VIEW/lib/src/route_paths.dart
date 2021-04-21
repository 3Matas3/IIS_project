
/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: route_paths.dart
 */

import 'package:angular_router/angular_router.dart';

const idParam = 'id';

class RoutePaths {
  static final login = RoutePath(path: 'login');
  static final next = RoutePath(path: 'next');
  static final product_list = RoutePath(path: 'products_list');
  static final product = RoutePath(path: '${product_list.path}/:$idParam');
  static final event_list = RoutePath(path: 'events_list');
  static final event = RoutePath(path: '${event_list.path}/:$idParam');
  static final manage_events = RoutePath(path: 'manage_events');
  static final manage_products = RoutePath(path: 'manage_products');
  static final manage_ingredients = RoutePath(path: 'manage_ingredients');
  static final main_page = RoutePath(path: 'main');
  static final register_page = RoutePath(path: 'user_manager/register');
  static final user_manager = RoutePath(path: 'user_manager');
}

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
