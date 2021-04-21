import 'dart:async';

import 'package:controller/src/models/user.dart';
import 'package:controller/src/databaseHandle.dart';

class UserService {
  Future<List<User>> getAll() async => listUsers(null); 

  Future<User> get(int id) async =>
    (await getAll()).firstWhere((user) => user.id == id);
}