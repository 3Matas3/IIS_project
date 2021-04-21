import 'dart:convert';

import 'package:controller/sharedUserLibrary.dart';

/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: user_manager.dart
 */

import 'databaseHandle.dart' as dat_han;
import 'models/user.dart';

/* Třída pro správu přihlášení/odhlášení uživatele */
class UserManager
{
  UserManager(){
    user = User();
  }

  User user;

  //bool get isAuthorized => user != null;

  Future<User> login (String username, String pasword) async
  {
    String response = await dat_han.login(username, pasword);
    user = User();
    if (response.isNotEmpty == true) {
      var map = jsonDecode(response);
      List<User> list = await dat_han.listUsers(map["access_token"]);
      list.forEach((f) {
        if(f.username == username) {
          user = f;
        }
      });
      user.token = map["access_token"];
    }
    return user;
  }

  void logout(User user)
  {
    user = null;
    global_logged_user = User();
  }

  void register(String username, String password, String role) {
    dat_han.register(username, password, role);
  }

  bool isAdmin (User user) {
    return (user.role == UserRole.admin);
  }
}
