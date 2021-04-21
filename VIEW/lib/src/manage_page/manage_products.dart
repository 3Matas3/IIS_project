import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:controller/src/models/product.dart';
import 'package:controller/src/models/ingredient.dart';
import '../product_list_page/product_service.dart';
import 'ingredient_service.dart';
import '../route_paths.dart';

import 'package:controller/src/databaseHandle.dart';
import 'package:controller/sharedUserLibrary.dart';

@Component(
  selector: 'manage_products',
  templateUrl: 'manage_products.html',
  directives: [coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    ],
  providers: [
    ClassProvider(ProductService),
    ClassProvider(IngredientService),
  ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
)

//TODO: v prohlizeci error - An invalid form control with name='' is not focusable.

class ManageProductsComponent implements OnInit {
  final ProductService _productService;
  final IngredientService _ingredientService;
  final Router _router;
  List<Product> products;
  bool submitted = false;
  bool editProductForm = false;
  bool showRemoveMess = false;
  List<Ingredient> ingredients;
  double n_price;
  Product modified = Product();
  Product notModified = Product();
  Product newProduct = Product();
  Product remProduct = Product();

  Map<String, bool> checkbox = Map();

  ManageProductsComponent(this._productService, this._router, this._ingredientService);

  Future<void> _getProducts() async {
    products = await _productService.getAll();
    for (var p in products) {
      p.composition = await _productService.getIngredients(p.id);
    }
  }

  Future<void> _getIngredients() async {
    ingredients = await _ingredientService.getAll();
  }

  void ngOnInit() async{
    if(!global_user_manager.isAdmin(global_logged_user)) {
      //Chybove vyskakovaci okno
      await goBack();
    }
    await _getProducts();
    await _getIngredients();
    ingredients.forEach((f) => checkbox[f.name] = false);
  }
  
  Future<NavigationResult> goBack() =>
    _router.navigate(RoutePaths.event_list.toUrl());

  String _productUrl(int id) =>
    RoutePaths.product.toUrl(parameters: {idParam: '$id'});
  
  Future<NavigationResult> gotoDetail(Product selected) =>
      _router.navigate(_productUrl(selected.id));

  void submitRemove()
  {
    this.products.remove(remProduct);
    deleteProduct(remProduct.id);
    showRemoveMess = false;
  }

  void remove(Product product)
  {
    remProduct = product;
    showRemoveMess = true; //TODO: přidat do html
  }

  void onSubmit() => submitted = false;

  void addProduct()
  {
    submitted = true;
    newProduct.name = '';
  }

  bool isInComposition(Ingredient ingredient)
  {
    if(this.modified.composition == null) return false;

    if(this.modified.containIngredient(ingredient.name)) return true;
    
    return false;
  }
  
  void saveProduct() async
  {
    submitted = false;
    List<Ingredient> checked_ing = [];

    for (var i in ingredients) {
      if (checkbox[i.name]) {
        checked_ing.add(i);
      }
    }
    newProduct.composition = checked_ing;
    products.add(newProduct);
    ingredients.forEach((f) => checkbox[f.name]= false);
    newProduct.id = await insertProduct(newProduct.name, checked_ing);
  }

  void editProduct(Product product)
  {
    modified.name = product.name;
    modified.composition = product.composition;
    notModified = product;
    for (var i in ingredients) {
      for (var p in modified.composition) {
        if (i.name == p.name) {
          checkbox[i.name] = true;
        }
      }
    }
    editProductForm = true;
  }

  void saveChanges()
  {
    /*Vytahneme data z checkboxu */
    List<Ingredient> checked_ing = [];
    for (var i in ingredients) {
      if (checkbox[i.name]) {
        checked_ing.add(i);
      }
    }
    /*Zkontrolujeme jake producty jsme odstranili, odstranime v databazi*/
    List<String> names = [];
    checked_ing.forEach((f) => names.add(f.name));
    for (var p in notModified.composition) {
        if (!names.contains(p.name)) {
          //TODO
          updateProduct(notModified.id, "IngredientRemove", p.id);
        }
    }
    /*Porovname jake produktu pridavame, pridame do databaze */
    for (var i in checked_ing) {
      if (!notModified.containIngredient(i.name)) {
        addIngredientToProduct(notModified.id, i.id);
      }
    }

    /*Zkontrolujeme jestli se zmenilo jmeno */
    if(notModified.name != modified.name) {
      //TODO
      updateProduct(notModified.id, "Name", modified.name);
    }
    ingredients.forEach((f) => checkbox[f.name]= false);
    notModified.composition = checked_ing;
    notModified.name = modified.name;    

      cancel();
      
  }

  void cancel()
  {
    showRemoveMess = false;
    submitted = false;
    editProductForm = false;
  }

  //TODO: funkčnost?, ziadna to sa niekde pouzivalo v html, ale nefunkce, pouziva sa cancel
  void clear()
  {
    cancel();
    newProduct.name = '';
    newProduct.composition = [];
  }
}