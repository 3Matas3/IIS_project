import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/user.dart';


class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    /*final int userID = request.authorization.ownerID;

    final user = await context.fetchObjectWithID<User>(userID);

    if(user.role != UserRole.admin)
      return Response.unauthorized();
    */
    // Check for required parameters before we spend time hashing
    if (user.username == null || user.password == null) {
      return Response.badRequest(
        body: {"error": "username, email and password required."});
    }

    user
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword = authServer.hashPassword(user.password, user.salt);

    return Response.ok(await Query(context, values: user).insert());
  }
}