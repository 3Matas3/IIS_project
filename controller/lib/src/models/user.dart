/**
 * Projekt IIS: Informaní systém pro prodej pouličního jídla
 * VUT FIT 2019
 * 
 * Autoři: Michal Krůl, Klára Formánková, Martina Chripková
 * 
 * Soubor: user.dart
 */
import 'dart:convert';

enum UserRole {
  admin, employee
} 

/// Třída představující zaměstnance/admina */
class User {
  int id;
  String username;
  String token;
  UserRole role;

  /// Defaultní konstruktor */
  User() {
    token = null;
  }

  User.fromMap(Map map){
    id = map["id"] as int;
    username = map["username"] as String;
    if(map["role"] == "admin")
    {
      role = UserRole.admin;
    }
    else {
      role = UserRole.employee;
    }
  }
  
  /// Konstruktor */
  factory User.fromString(String json) {
    //final = once assigned a value, a final variable's value cannot be changed
    final Map<String, dynamic> map = jsonDecode(json);
    return User.fromMap(map);
  }

  Map<String, dynamic> asMap() =>
  {
    "id": id,
  };

  void setRoleFromString(String roleString)
  {
    if(roleString == "admin")
    {
      role =  UserRole.admin;
    }
    else {
      role = UserRole.employee;
    }
  }

  List<String> getUserRoles()
  {
    List<String> roles = [];
    for(UserRole u in UserRole.values)
    {
      roles.add(getStringFromRole(u));
    }
    return roles;
  }

  String getStringFromRole(UserRole u)
  {
    return u.toString().substring(u.toString().indexOf('.')+1);
  }

}
