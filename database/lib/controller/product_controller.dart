import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/ingredient.dart';
import 'package:database/models/product.dart';
import 'package:database/models/product_ingredients.dart';



class ProductController extends ResourceController {
  ProductController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllProducts() async {
    final Query q = Query<Product>(context);
    final res = await q.fetch();
    return Response.ok(res);
  }

  @Operation.delete("p_id")
  Future<Response> deleteProduct(@Bind.path("p_id") int id) async {
    final Query q = Query<Product>(context)
    ..where((p) => p.id).equalTo(id);
    final res = await q.delete();
    return Response.ok({"deletedCount": res});
  }


  @Operation.get("p_id")
  Future<Response> getProductById(@Bind.path("p_id") int id) async {
    final Query q = Query<Product>(context)
      ..where((order) => order.id).equalTo(id)
      ..join(set: (p) => p.productIngredients).join(object: (pi) => pi.ingredient);

    final res = await q.fetchOne();
    return Response.ok(res);
  }

  // prida novy product bez ingrediencii
  @Operation.post()
  Future<Response> addProduct(@Bind.body() Product product) async
  {
      final insertedP = await Query.insertObject(context, product);
	  return Response.ok(insertedP);
  }

  @Operation.post("p_id")
  Future<Response> addIngredientToProduct(@Bind.path("p_id") int id, @Bind.body() Ingredient ingredient) async
  {
    final product = Product()
      ..id = id;

	  final q = Query<ProductIngredients>(context)
		  ..values.ingredient = ingredient
		  ..values.product = product;
	
	  final res = await q.insert();
	  return Response.ok(res);
  }

  // ak chceme zmenit meno producku, napiseme ho do query: ?name=noveMeno
  // ak chceme pridat ingredienciu, posleme ju v body
  @Operation.put("p_id")
  Future<Response> editProduct(@Bind.path("p_id") int id, {@Bind.body() Ingredient ingredient, @Bind.query("name") String productName}) async
  {
    Product product;
    if(productName != null)
    {

      final productQ = Query<Product>(context)
        ..where((p) => p.id).equalTo(id)
        ..values.name = productName;

      product = await productQ.updateOne();
    }
    else
      product = await context.fetchObjectWithID(id);

    if(product == null)
      return Response.badRequest();

    if(ingredient != null)
    {
      final q = Query<ProductIngredients>(context)
          ..values.ingredient = ingredient
          ..values.product = product;

      await q.insert();
    }
    final productQ = Query<Product>(context)
      ..where((p) => p.id).equalTo(id);

    final res = await productQ.fetchOne();

    return Response.ok(res);
  }

  // vymaze ingredienciu z produktu
  @Operation.delete("p_id", "i_id")
  Future<Response> deleteProductIngredient(@Bind.path("p_id") int p_id, @Bind.path("i_id") int i_id) async
  {    
    Product product;
    product = await context.fetchObjectWithID(p_id);

    if(product == null)
      return Response.badRequest();

    final q = Query<ProductIngredients>(context)
        ..where((pi) => pi.product).identifiedBy(p_id)
      ..where((pi) => pi.ingredient).identifiedBy(i_id);

    final deleted = q.delete();

    return Response.ok({"deletedCount": deleted});
  }
}