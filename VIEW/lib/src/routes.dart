/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: routes.dart
 */

import 'package:angular_router/angular_router.dart';
import 'route_paths.dart';

import 'login_page/login_page.template.dart' as login_template;
import 'register_page/register_page.template.dart' as register_template;
import 'product_list_page/product_component.template.dart' as product_template;
import 'product_list_page/product_list_component.template.dart' as product_list_template;
import 'event_list_page/event_component.template.dart' as event_template;
import 'event_list_page/event_list_component.template.dart' as event_list_template;
import 'manage_page/manage_events.template.dart' as manage_events_template;
import 'manage_page/manage_products.template.dart' as manage_products_template;
import 'manage_page/manage_ingredients.template.dart' as manage_ingredients_template;
import 'not_found.template.dart' as not_found_template;
import 'main_page/main_page.template.dart' as main_page_template;
import 'user_manager/user_manager.template.dart' as user_manager_template;

export 'route_paths.dart';

class Routes {
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.LoginPageComponentNgFactory,
    useAsDefault: true,
  );

  static final register = RouteDefinition(
    routePath: RoutePaths.register_page,
    component: register_template.RegisterPageComponentNgFactory,
  );

  static final product = RouteDefinition(
    routePath: RoutePaths.product,
    component: product_template.ProductComponentNgFactory,
  );

  static final product_list = RouteDefinition(
    routePath: RoutePaths.product_list,
    component: product_list_template.ProductListComponentNgFactory,
  );

  static final event = RouteDefinition(
    routePath: RoutePaths.event,
    component: event_template.EventComponentNgFactory,
  );

  static final event_list = RouteDefinition(
    routePath: RoutePaths.event_list,
    component: event_list_template.EventListComponentNgFactory,
  );

  static final main_page = RouteDefinition(
    routePath: RoutePaths.main_page,
    component: main_page_template.MainPageComponentNgFactory,
  );

  static final manage_events = RouteDefinition(
    routePath: RoutePaths.manage_events,
    component: manage_events_template.ManageEventsComponentNgFactory,
  );

  static final manage_products = RouteDefinition(
    routePath: RoutePaths.manage_products,
    component: manage_products_template.ManageProductsComponentNgFactory,
  );

  static final manage_ingredients = RouteDefinition(
    routePath: RoutePaths.manage_ingredients,
    component: manage_ingredients_template.ManageIngredientsComponentNgFactory,
  );

  static final user_manager = RouteDefinition(
    routePath: RoutePaths.user_manager,
    component: user_manager_template.UserManagerComponentNgFactory,
  );


  static final all = <RouteDefinition>[
    login,
    register,
    product,
    product_list,
    event,
    event_list,
    manage_events,
    manage_ingredients,
    manage_products,
    main_page,
    user_manager,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.main_page.toUrl(),
    ),
    RouteDefinition(
      path: '.+',
      component: not_found_template.NotFoundComponentNgFactory,
    ),
  ];
}
