import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/product_ingredients.dart';

class Ingredient extends ManagedObject<_Ingredient> implements _Ingredient{
  @override
  void willInsert() {
  }
  @override
  void willUpdate() {

        }
}

class _Ingredient{
  @primaryKey
  int id;

  @Column(nullable: false)
  String name;
  
  //product
  ManagedSet<ProductIngredients> productIngredients;
}