import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/login_page/login_page.dart';
import 'src/routes.dart';


// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [
    coreDirectives,
    LoginPageComponent,
    routerDirectives,
  ],
  exports: [RoutePaths, Routes],
)
class AppComponent  {}
