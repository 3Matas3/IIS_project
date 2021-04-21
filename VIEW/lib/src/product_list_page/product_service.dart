import 'dart:async';

import 'package:controller/src/models/product.dart';
import 'package:controller/src/models/ingredient.dart';
import 'package:controller/src/databaseHandle.dart';

class ProductService {
  Future<List<Product>> getAll() async => listProducts(); //TO JE TA ÚŽASNÁ FUNKCE!!!!!

  Future<Product> get(int id) async =>
    (await getAll()).firstWhere((product) => product.id == id);

  Future<List<Ingredient>> getIngredients(int id) async => await getIngredientOfProduct(id);
}