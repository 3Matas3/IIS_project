import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:controller/src/models/user.dart';

import 'package:controller/sharedUserLibrary.dart' as global;



import '../route_paths.dart';


@Component(
  selector: 'login_page',
  templateUrl: 'login_page.html',
  directives: [
    coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    AutoFocusDirective,
  ],
  providers: [
    materialInputDirectives,
  ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
  preserveWhitespace: true,
)

class LoginPageComponent implements OnInit
{
  User user;
  String username;
  String password;
  bool submited = false;
  
  final Router _router;
  final Location _location;

  LoginPageComponent(this._router, this._location);

  

  void login() async
  {     
    User user = await global.global_user_manager.login(username, password);
    if (user.username != null) {
      global.global_logged_user = user;
      await _router.navigate(RoutePaths.event_list.toUrl());
    }
  }

  @override
  void ngOnInit() {}

  void goBack() => _location.back();

}


