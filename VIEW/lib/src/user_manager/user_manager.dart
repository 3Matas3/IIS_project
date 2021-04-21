import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:controller/src/models/user.dart';

import 'package:controller/sharedUserLibrary.dart' as global;
import 'package:view/src/user_manager/user_service.dart';

import 'package:controller/src/databaseHandle.dart';
import 'package:controller/sharedUserLibrary.dart';



import '../route_paths.dart';


@Component(
  selector: 'user_manager',
  templateUrl: 'user_manager.html',
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
    ClassProvider(UserService),
    materialInputDirectives,
  ],
  preserveWhitespace: true,
)

class UserManagerComponent implements OnInit
{
  final UserService _userService;
  final Router _router;
  final Location _location;
  List<User> users;
  bool submitted = false;
  bool showRemoveMess = false;
  User modified = User();
  User notModified = User();
  User remUser = User();
  List <String> roles;
  String modifiedRoleString;

  UserManagerComponent(this._router, this._location, this._userService);

  Future<void> _getUsers() async {
    users = await _userService.getAll();
  }

  void ngOnInit() async
  {
    if(!global_user_manager.isAdmin(global_logged_user)) {
      //Chybove vyskakovaci okno
      await goBack();
    }
    _getUsers();
    roles = modified.getUserRoles();
  }

  void register() async => await _router.navigate(RoutePaths.register_page.toUrl());

  void edit(User user)
  {
    modified.username = user.username;
    modified.role = user.role;
    notModified = user;
    modifiedRoleString = modified.getStringFromRole(user.role);
    submitted = true;
  }

  void cancel()
  {
    submitted = false;
    showRemoveMess = false;
  }

  void saveChanges()
  {
    notModified.username = modified.username;
    notModified.setRoleFromString(modifiedRoleString);
    updateUser(notModified.id, "role", notModified.getStringFromRole(notModified.role));
    cancel();
  }

  void remove(User user)
  {
    remUser = user;
    showRemoveMess = true;
  }

  void submitRemove()
  {
    this.users.remove(remUser);
    showRemoveMess = false;
    removeUser(remUser.id);
  }

  void goBack() => _location.back();

}


