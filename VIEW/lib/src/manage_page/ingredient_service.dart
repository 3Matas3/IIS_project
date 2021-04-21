import 'dart:async';

import 'package:controller/src/models/ingredient.dart';

import 'package:controller/src/databaseHandle.dart';

class IngredientService {
  Future<List<Ingredient>> getAll() async => listIngredients();
   
  Future<Ingredient> get(int id) async =>
    (await getAll()).firstWhere((ingredient) => ingredient.id == id);
}