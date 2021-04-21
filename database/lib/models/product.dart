import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/event_product.dart';
import 'package:database/models/product_ingredients.dart';

class Product extends ManagedObject<_Product> implements _Product{
  @override
  void willInsert() {
  }
  @override
  void willUpdate() {

        }
}

class _Product{
  @primaryKey
  int id;

  @Column(unique: false)
  String name;

  ManagedSet<ProductIngredients> productIngredients;

  ManagedSet<EventProduct> eventProducts;

}