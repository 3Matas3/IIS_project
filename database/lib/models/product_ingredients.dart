import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/product.dart';
import 'ingredient.dart';

class ProductIngredients extends ManagedObject<_ProductIngredients> implements _ProductIngredients{

}

class _ProductIngredients{
  @primaryKey
  int id;
  
  //product
  @Relate(#productIngredients, isRequired: true, onDelete: DeleteRule.cascade)
  Product product;

    //product
  @Relate(#productIngredients, isRequired: true, onDelete: DeleteRule.cascade)
  Ingredient ingredient;
}