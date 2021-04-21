import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:controller/src/models/event.dart';
import 'package:controller/src/models/order.dart';
import 'package:controller/src/models/product.dart';
import 'package:controller/src/models/ingredient.dart';
import 'package:controller/src/models/user.dart';
import 'package:controller/src/user_manager.dart';
import 'package:view/src/product_list_page/mock_products.dart';
//import '../manage_page/mock_ingredients.dart';
import 'event_service.dart';
import '../route_paths.dart';
import '../product_list_page/product_service.dart';
import '../manage_page/ingredient_service.dart';

import 'package:controller/src/databaseHandle.dart';
import 'package:controller/sharedUserLibrary.dart'as global;


@Component(
  selector: 'my-event',
  templateUrl: 'event_component.html',
  directives: [
    coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    AutoFocusDirective,
  ],
  providers: 
    [ClassProvider(EventService),
    ClassProvider(ProductService),
    ClassProvider(IngredientService),
    ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
  preserveWhitespace: true,
)

class EventComponent implements OnActivate {
  Event event;
  final EventService _eventService;
  final ProductService _productService;
  final IngredientService _ingredientService;
  final Location _location;
  final Router _router;
  List<Ingredient>  ingredients;
  List<Product>  products;
  bool submitted = false;
  bool newOrderForm = false;
  bool statistics = false;
  bool activeO = true;
  bool showcancelmessage = true;
  Order newOrder = Order();
  double totalPrice = 0;
  int totalProducts = 0;
  User loggedUser = global.global_logged_user;
  Order toCancel;

  Map<String, bool> checkbox = Map();

  List<Order> activeOrders = [];
  List<Order> nonActiveOrders = [];


  EventComponent(this._location, this._eventService, this._router, this._productService, this._ingredientService);

  @override
  void onActivate(_, RouterState current) async {
    final id = getId(current.parameters);
    if (id != null) event = await (_eventService.get(id));
    event.offer = await _eventService.getOffer(id);
    event.orders = await _eventService.getOrders(id);
    for (var o in event.orders) { 
      totalPrice += o.price; 
      if (o.status == "ordered"|| o.status == "ready") {
        activeOrders.add(o);
      }
      else {
        nonActiveOrders.add(o);
      }
    }
    await _getProducts();
    await _getIngredients();
    products.forEach((f) => checkbox[f.name]= false);
  }

  Future<void> _getProducts() async {
    products = await _productService.getAll();
  }

  Future<void> _getIngredients() async {
    ingredients = await _ingredientService.getAll();
  }

  Future<NavigationResult> goToProducts() =>
    _router.navigate(RoutePaths.product_list.toUrl());
  
  void goBack() => _location.back();

  void editOffer(List<Product> offer)
  {
    submitted = true;
    for (var p in products) {
      for (var o in offer) {
        if (o.name == p.name) {
          checkbox[p.name] = true;
        }
      }
    }
  }

  void saveOffer()
  {
    /*Vytahneme data z checkboxu */
    List<Product> checked_prod = [];
    for (var p in products) {
      if (checkbox[p.name]) {
        checked_prod.add(p);
      }
    }
    checked_prod.forEach((f) => print(f.name));
    /*Zkontrolujeme jake producty jsme odstranili, odstranime v databazi*/
    for (var e in event.offer) {
      if (!checked_prod.contains(e)) {
        deleteProductFromEvent(event.id, e.id);
      }
    }
    /*Porovname jake produktu pridavame, pridame do databaze */
    for (var p in checked_prod) {
      if (!event.offerContainProduct(p.name)) {
        insertProductToEvent(event.id, p.id, 10); //TODO cena
      }
    }
    hideForms();
  }

  void startNewOrder()
  {
    newOrderForm = true;
    this.newOrder = Order();
    this.newOrder.price = 0;
    this.newOrder.status = "ordered";
    this.newOrder.products = [];
    
  }

  void addToOrder(Product product)
  {
    this.newOrder.products.add(product);
    this.newOrder.price += product.price;
  }

  void removeProductFromOrder(Product product)
  {
    this.newOrder.products.remove(product);
    this.newOrder.price -= product.price; 
  }

  void removeProductFromOffer(Product product)
  {
    this.event.offer.remove(product);
  }

  bool isInOffer(Product product)
   {
     if(event.offer == null)
     {
       return false;
     }
     if(event.offerContainProduct(product.name))
     {
       return true;
     }
     else 
     {
       return false;
     }
   }

  void saveOrder()
  {
    event.orders.add(newOrder);
    activeOrders.add(newOrder);
    this.totalPrice += newOrder.price;
    List<int> p_id = [];
    newOrder.products.forEach((f) => p_id.add(f.id));
    addOrder(event.id, p_id);
    hideForms();
  }

  void showStatistics()
  {
    statistics = true;
    submitted = true;
    newOrderForm = true;
    //totalPrice = event.countTotalPrice(); 
    totalProducts = event.countProducts();
  }

  void hideForms()
  {
    submitted = false;
    newOrderForm = false;
    statistics = false;
  }

  void showNonActive() {
    activeO = !activeO;
  }

  void cancel()
  {
    newOrder = null;
    submitted = false;
    newOrderForm = false;
    statistics = false;
    showcancelmessage = !showcancelmessage;
  }

  cancelorder(Order order){
    toCancel = order;
     showcancelmessage = !showcancelmessage;
  }

  void changeStatus(Order order)
  {
    if(order.status == "ordered") {
      order.status = "ready";
      
    }
    else if(order.status == "ready") {
      order.status = "done";
      activeOrders.remove(order);
      nonActiveOrders.add(order);
    }
         
    updateOrder(event.id, order.id, order.status);
  }

  void cancelOrder() {
    showcancelmessage = !showcancelmessage;
    activeOrders.remove(toCancel);
    nonActiveOrders.add(toCancel);
    updateOrder(event.id, toCancel.id, "cancelled");
  }

  Future<void> logout () async
  {
    UserManager uMan = global.global_user_manager;
    User u = global.global_logged_user;
    uMan.logout(u);
  }

  bool isAdmin() => global.global_user_manager.isAdmin(global.global_logged_user);
}