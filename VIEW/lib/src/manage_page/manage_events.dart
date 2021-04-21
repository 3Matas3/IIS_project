import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';


import 'package:controller/src/models/event.dart';
import 'package:controller/src/models/product.dart';
import 'package:view/src/product_list_page/product_service.dart';
import '../event_list_page/event_service.dart';
import '../route_paths.dart';

import 'package:controller/src/databaseHandle.dart';
import 'package:controller/sharedUserLibrary.dart';

@Component(
  selector: 'manage_events',
  templateUrl: 'manage_events.html',
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
  directives: [coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    AutoFocusDirective,
  ],
  providers: [
    ClassProvider(EventService),
    ClassProvider(ProductService),
  ],
)

class ManageEventsComponent implements OnInit {
  final EventService _eventService;
  final ProductService _productService;
  final Router _router;
  List<Event> events;
  List<Product> products;
  bool submitted = false;
  bool editEventForm = false;
  Event notModified = Event();
  Event modified = Event();
  Event newEvent = Event();
  bool showRemoveMess = false;
  Event remEvent = Event();
  String newPrice;

  Map<String, bool> checkbox = Map();
  Map<String, double> prices = Map();

  ManageEventsComponent(this._eventService, this._router, this._productService);

  Future<void> _getEvents() async {
    events = await _eventService.getAll();
  }
  Future<void> _getProducts() async {
    products = await _productService.getAll();
  }

  void ngOnInit() async {
    if(!global_user_manager.isAdmin(global_logged_user)) {
      //Chybove vyskakovaci okno
      await goBack();
    }
     await _getEvents();
     await _getProducts();
     events.forEach((f) async => f.offer = await _eventService.getOffer(f.id));
     products.forEach((f) => checkbox[f.name]= false);
     this.products.forEach((f) => prices[f.name] = 0);
  }
  
  Future<NavigationResult> goBack() =>
    _router.navigate(RoutePaths.event_list.toUrl());

  void editEvent(Event event)
  {
    modified.name = event.name;
    modified.date = event.date;
    modified.offer = event.offer;
    notModified = event;
    products.forEach((f) => checkbox[f.name]= false);
    for (var p in products) {
      for (var e in notModified.offer) {
        if (p.name == e.name) {
          checkbox[p.name] = true;
        }
      }
    }
    
    for (var p in products) {
      for (var o in event.offer) {
        if (p.name == o.name) {
          prices[p.name] = o.price;
        }
      }
    }
    editEventForm = true;

  }

  bool isInOffer(Product product)
  {
    if(this.modified.offer == null) return false;

    if(this.modified.offerContainProduct(product.name)) return true;
    
    return false;
  }

  void remove(Event event)
  {
    remEvent = event;
    showRemoveMess = true;
  }

  void submitRemove()
  {
    this.events.remove(remEvent);
    deleteEvent(remEvent.id);
    showRemoveMess = false;
  }

  void onSubmit() => submitted = true;

  void submit(){}

  void addEvent()
  {
    this.newEvent.name = '';
    this.newEvent.date = '';
    products.forEach((f) => checkbox[f.name]= false);
    this.products.forEach((f) => prices[f.name] = 0);
    submitted = true;
  }

  void saveChanges()
  {
    /*Vytahneme data z checkboxu */
    List<Product> checked_prod = [];
    for (var p in products) {
      if (checkbox[p.name]) {
        checked_prod.add(p);
      }
    }
    /*Zkontrolujeme jake producty jsme odstranili, odstranime v databazi*/
    List<String> names = [];
    checked_prod.forEach((f) => names.add(f.name));
    for (var p in notModified.offer) {
        if (!names.contains(p.name)) {
          //TODO
          products.remove(p);
          deleteProductFromEvent(notModified.id, p.id);
        }
    }
    /*Porovname jake produktu pridavame, pridame do databaze */
    for (var p in checked_prod) {
      if (!notModified.offerContainProduct(p.name)) {
        products.add(p);
        insertProductToEvent(notModified.id, p.id, prices[p.name]);
      }
    }
    /*Zkontrolujeme ceny */
    for (var o in checked_prod) {
      for (var p in products) {
        if (o.name == p.name) {
          if(o.price != prices[p.name]){
            o.price = prices[p.name];
            updateEventOffer(notModified.id, o.id, "ProductUpdate", o.price);
          } 
        }
      }
    }

    notModified.offer = checked_prod;
    cancel();
  }
  
  void saveEvent() async
  {    
    submitted = false;

    List<Product> checked_prod = [];

    for (Product i in products) {
      if (checkbox[i.name]) {
        checked_prod.add(i);
      }
    }
    products.forEach((f) => checkbox[f.name]= false);  
    newEvent.offer = checked_prod;
    newEvent.offer.forEach((f) => f.price = prices[f.name]);
    events.add(newEvent);
    newEvent.id = await insertEvent(newEvent.name, newEvent.date, checked_prod, prices);
    this.products.forEach((f) => prices[f.name] = 0);

  }

  void cancel()
  {
    this.products.forEach((f) => prices[f.name] = 0);
    products.forEach((f) => checkbox[f.name]= false);
    showRemoveMess = false;
    submitted = false;
    editEventForm = false;
  }

  void clear()
  {
    cancel();
    this.newEvent.name = '';
    this.newEvent.date = '';
    this.newEvent.offer = [];
  }
  
}