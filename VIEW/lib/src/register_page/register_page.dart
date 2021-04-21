import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:controller/src/user_manager.dart';
import 'package:controller/src/models/user.dart';

import 'package:controller/sharedUserLibrary.dart' as global;

@Component(
  selector: 'register_page',
  templateUrl: 'register_page.html',
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
  ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
)

class RegisterPageComponent implements OnInit {

  final Router _router;
  final Location _location; 

  String username;
  String password;
  String role;
  List<String> roles;
  User user;

  RegisterPageComponent(this._router, this._location);

  @override
  void ngOnInit() 
  {
    user = User();
    roles = user.getUserRoles();
  }

  //TODO: okamžité zobrazení nového uživatele v user manager
  void register() 
  { 
    UserManager uMan = global.global_user_manager;
    uMan.register(username, password, role);
    goBack();
  }

  void goBack() => _location.back();

}