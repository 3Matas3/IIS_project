import 'package:aqueduct/aqueduct.dart';
//import 'package:database/models/user.dart';

class UserController extends ResourceController{
  UserController(this.context);

  final ManagedContext context;

  int getUserId(Request request){
    if(request.authorization == null)
      return 1;
    else
      return request.authorization.ownerID;
  }

}