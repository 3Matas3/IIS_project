/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: ingredient.dart
 */
import 'dart:convert';


/// Třída reprezentující ingredienci */
class Ingredient {
  int id;
  String name;

  Ingredient();

  /// Konstruktor */
  Ingredient.fromMap (Map json) {
    id = json["id"] as int;
    name = json["name"] as String;
  }

  factory Ingredient.fromString (String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return Ingredient.fromMap(map);
  }
}