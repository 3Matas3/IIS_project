//import 'dart:html';
import 'package:aqueduct/managed_auth.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/order.dart';

enum UserRole{
  admin, employee
}

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User>{

  @Serialize(input: true, output: false)
  String password;

  @override
  void willInsert() {
  }
  @override
  void willUpdate() {

        }
}

class _User extends ResourceOwnerTableDefinition{
  @primaryKey
  int id;

  @Column(unique: true)
  String username;

  @Column(nullable: false, defaultValue: "'employee'")
  UserRole role;
}