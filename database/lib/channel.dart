import 'package:aqueduct/managed_auth.dart';
import 'package:database/models/event.dart';
import 'package:database/controller/event_controller.dart';
import 'package:database/models/ingredient.dart';
import 'package:database/models/order.dart';
import 'package:database/models/user.dart';
import 'package:database/models/event_order_product.dart';

import 'controller/order_controller.dart';
import 'controller/product_controller.dart';
import 'controller/register_controller.dart';

import 'database.dart';
//import 'models/order.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class DatabaseChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
 
    final config = IisConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName);

    context = ManagedContext(dataModel, persistentStore);

    final delegate = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(delegate);
 }
 
  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/

        router
          .route('/auth/token')
          .link(() => AuthController(authServer));
 
        router
          .route("/ingredients/[:id]")
          .link(() => Authorizer.bearer(authServer))
          .link(() => ManagedObjectController<Ingredient>(context));

        router
          .route("orders/[:id]")
          .link(() => Authorizer.bearer(authServer))
          .link(() => ManagedObjectController<Order>(context));

        router
          .route("users/[:id]")
          .link(() => Authorizer.bearer(authServer))
          .link(() => ManagedObjectController<User>(context));
      
        router
          .route("register/")
          .link(() => Authorizer.bearer(authServer))
          .link(() => RegisterController(context, authServer));

        router
          .route("products/[:p_id]")
          .link(() => Authorizer.bearer(authServer))
          .link(() => ProductController(context));

        router
          .route("events/[:id]")
          .link(() => ManagedObjectController<Event>(context));

        router
          .route("event/:e_id/products/[:p_id]")
          .link(() => EventController(context));

        router
          .route("products/:p_id/ingredients/[:i_id]")
          .link(() => Authorizer.bearer(authServer))
          .link(() => ProductController(context));

        router
          .route("event/:e_id/orders/[:o_id]")
          .link(() => Authorizer.bearer(authServer))
          .link(() => OrderController(context));

    return router;
  }
}

class IisConfig extends Configuration {
  IisConfig(String path): super.fromFile(File(path));

  DatabaseConfiguration database;
}