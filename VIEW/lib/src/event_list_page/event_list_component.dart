import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:angular_components/angular_components.dart';


import 'package:controller/src/models/event.dart';
import 'package:controller/src/user_manager.dart';
import 'package:controller/src/models/user.dart';
import 'package:controller/src/models/order.dart';
import 'event_service.dart';
import '../route_paths.dart';
import 'order_service.dart';

import 'package:controller/sharedUserLibrary.dart'as global;

@Component(
  selector: 'event_list_component',
  templateUrl: 'event_list_component.html',
  directives: [
    coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    AutoFocusDirective, 
  ],
  providers: [ClassProvider(EventService),
  ClassProvider(OrderService),
  ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
  preserveWhitespace: true,
  pipes: [commonPipes],
)

class EventListComponent implements OnInit
{
  final EventService _eventService;
  //final OrderService _orderService;
  final Router _router;
  List<Event> events;
  List<Order> orders;
  Event selected;
  User loggedUser = global.global_logged_user;

  EventListComponent(this._router, this._eventService, /*this._orderService*/);

  Future<void> _getEvents() async {
    events = await _eventService.getAll();
  }
  /*
  Future<void> _getOrders() async {
    orders = await _orderService.getAll();
  }
  */

  void ngOnInit(){
     _getEvents();
     //_getOrders();
  }

  void onSelect(Event event) => selected = event;

  String _eventUrl(int id) =>
    RoutePaths.event.toUrl(parameters: {idParam: '$id'});
  
  Future<NavigationResult> gotoDetail(Event selected) =>
      _router.navigate(_eventUrl(selected.id));

  Future<NavigationResult> manageEvents() =>
    _router.navigate(RoutePaths.manage_events.toUrl());

  Future<NavigationResult> manageProducts() =>
    _router.navigate(RoutePaths.manage_products.toUrl());

  Future<NavigationResult> manageIngredients() =>
    _router.navigate(RoutePaths.manage_ingredients.toUrl());

  Future<NavigationResult> goToUserManager() =>
    _router.navigate(RoutePaths.user_manager.toUrl());

  Future<void> logout () async
  {
    UserManager uMan = global.global_user_manager;
    User u = global.global_logged_user;
    uMan.logout(u);
    await _router.navigate(RoutePaths.main_page.toUrl());
  }

  bool isAdmin() => global.global_user_manager.isAdmin(global.global_logged_user);
}
