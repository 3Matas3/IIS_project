import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as https;

import 'models/order.dart' as cntrl_o;
import 'models/product.dart' as cntrl_p;
import 'models/ingredient.dart' as cntrl_i;
import 'models/event.dart' as cntrl_e;
import 'models/user.dart' as usr;
import '../sharedUserLibrary.dart' as global;


/*
 *  LOGIN + REGISTER
 */
Future<String> login( String username, String password) async {
  String url = 'https://streetfoodapp.herokuapp.com/auth/token';
  final clientID = "iis";
  final credentials = Base64Encoder().convert("$clientID:".codeUnits);
  String body = "username=$username&password=$password&grant_type=password";
  final res = await https.post(
    url, 
    headers: {
      "Authorization": "Basic $credentials",
      "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
      "Accept": "*/*"
    },
    body: body
  );
  if (res.statusCode != 200) {
    return "";
  }
  else {
    return res.body;
  }
}


Future<void> register(String username, String password, String role) async {
  String url = "https://streetfoodapp.herokuapp.com/register";
  String token = global.global_logged_user.token;
  Map data = {
      "username": "$username",
      "password": "$password",
      "role": "$role"
    };
  String body = jsonEncode(data);
  await https.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: body,
  );
}

/*
* USER MANAGE
*/

Future<List<usr.User>> listUsers(String tok) async {
  String token;
  if (tok == null) {
    token = global.global_logged_user.token;
  }
  else {
    token = tok;
  }
  List<usr.User> list = [];
  //Uri adress;
  String response;
  List<dynamic> json_map;
  
  response = await https.read(
    "https://streetfoodapp.herokuapp.com/users",
    headers: {
      "Authorization": "Bearer $token",
    }
  );
  json_map = jsonDecode(response);
  list = json_map.map((i) => usr.User.fromMap(i)).toList();
  return list;
}

void removeUser(int id) {
  String url = "https://streetfoodapp.herokuapp.com/users/$id";
  String token = global.global_logged_user.token;

  final res = https.delete(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );
}
/*
* parameter: role, value: admin/employee
*/
void updateUser(int id, String parameter, String role) {
  String url = "https://streetfoodapp.herokuapp.com/users/$id";
  String token = global.global_logged_user.token;
 
  final res = https.put(
    url,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "*/*",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({"$parameter": role})
  );
}

/*
* PRODUCT MANAGE
*/
Future<List<cntrl_p.Product>> listProducts() async {
  String token = global.global_logged_user.token;
  List<cntrl_p.Product> list = [];
  //Uri adress;
  String response;
  List<dynamic> json_map;
  
  response = await https.read(
    "https://streetfoodapp.herokuapp.com/products",
    headers: {
      "Authorization": "Bearer $token",
    }
  );
  json_map = jsonDecode(response);
  list = json_map.map((i) => cntrl_p.Product.fromMap(i)).toList();
  return list;
}

Future<int> insertProduct(String name, List<cntrl_i.Ingredient> ingredients) async {  
  String  url = 'https://streetfoodapp.herokuapp.com/products';
  String token = global.global_logged_user.token;
  https.Response res = await https.post(
    url, 
    headers: {
      "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
    }, 
    body: jsonEncode({"name" : name})
  );

  var map = jsonDecode(res.body);
  int p_id = map["id"];
  ingredients.forEach((f) => addIngredientToProduct(p_id,f.id));

  return p_id; 
}

void deleteProduct(int id) async {
  String url = 'https://streetfoodapp.herokuapp.com/products/$id';
  String token = global.global_logged_user.token;
  https.Response res = await https.delete(
    url, 
    headers: {
        "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
    }
  );
}

/*        Parameter         value
* Name :  Name              newName
* Add :   IngredientAdd     ingredient_id
* Delete :IngrefientRemove  ingredient_id
*/
void updateProduct(int id, String parameter, var value) async{
  if (parameter == "Name") {
    var queryParams = {'name': '$value'};

    Uri uri = Uri.https('streetfoodapp.herokuapp.com', '/products/$id', queryParams);
    String token = global.global_logged_user.token;
    https.Response res = await https.put(
      uri, 
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "*/*",  
        "Content-Type": "application/json; charset=utf-8",
      }, 
    );
    //TODO
    print(res.body);
  
  }
  else if (parameter == "IngredientRemove") {
    String url = 'https://streetfoodapp.herokuapp.com/products/$id/ingredients/$value';
    String token = global.global_logged_user.token;

    https.Response res = await https.delete(
      url, 
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
      },
    );
    //TODO
    print(res.body);
  }
}

Future<cntrl_p.Product> getProduct(int id) async {
    String url = 'https://streetfoodapp.herokuapp.com/products/$id';
    String token = global.global_logged_user.token;

    String res = await https.read(
      url, 
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
      },
    );
    Map json = jsonDecode(res);
    cntrl_p.Product product = cntrl_p.Product();
    product.id = json["id"];
    product.name = json["name"];
    return product;
}

/*
* INGREDIENTS MANAGE
*/
Future<List<cntrl_i.Ingredient>> listIngredients() async{
  List<cntrl_i.Ingredient> list = [];
  String response;
  String token = global.global_logged_user.token;
  List<dynamic> json_map;

  response = await https.read(
    "https://streetfoodapp.herokuapp.com/ingredients",
    headers: {
      "Authorization": "Bearer $token",
    }
  );
  json_map = jsonDecode(response);
  list = json_map.map((i) => cntrl_i.Ingredient.fromMap(i)).toList();
  return list;
}

Future<int> insertIngredient(String name) async{
  String  url = 'https://streetfoodapp.herokuapp.com/ingredients';
  String token = global.global_logged_user.token;
  https.Response res = await https.post(
    url, 
    headers: {
      'Content-Type': "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({"name":name})
  );
  Map data = jsonDecode(res.body);
  int ret = data["id"];
  return ret;
}

void deleteIngredient(int id) async{
  String url = 'https://streetfoodapp.herokuapp.com/ingredients/$id';
  String token = global.global_logged_user.token;
  https.Response res = await https.delete(
    url, 
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    }
  );

}

/*
* EVENT MANAGE
*/
Future<List<cntrl_e.Event>> listEvents() async{
  List<cntrl_e.Event> list = [];
  String response;
  List<dynamic> json_map;

  response = await https.read("https://streetfoodapp.herokuapp.com/events");
  json_map = jsonDecode(response);
  list = json_map.map((i) => cntrl_e.Event.fromMap(i)).toList();
  return list;
}

Future<int> insertEvent(String name, String date, List<cntrl_p.Product> products, Map<String, double> prices) async{
  String  url = 'https://streetfoodapp.herokuapp.com/events';
  String token = global.global_logged_user.token;
  https.Response res = await https.post(
    url, 
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    }, 
    body: jsonEncode({"name" : name, "date" : date})
  );
  var map = jsonDecode(res.body);
  int e_id = map["id"];
  products.forEach((f) => insertProductToEvent(e_id,f.id, prices[f.name]));
  return e_id;
}

void deleteEvent(int id) async{
  String url = 'https://streetfoodapp.herokuapp.com/events/$id';
  String token = global.global_logged_user.token;
  https.Response res = await https.delete(
    url, 
    headers: {
      "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
    }

  );
}

/*        paramater       value
* Name    name            newname
  date    date            new date
*/
void updateEvent(int e_id, String parameter, var value) async {
  if (parameter == "Name") {
    String url = 'https://streetfoodapp.herokuapp.com/events/$e_id';
    String token = global.global_logged_user.token;
    https.Response res = await https.put(
      url, 
      headers: {
        "Authorization": "Bearer $token",
          "Accept": "*/*",
          "Content-Type": "application/json; charset=utf-8",
      }
    );
  }
  else {
    String url = 'https://streetfoodapp.herokuapp.com/events/$e_id';
    String token = global.global_logged_user.token;
    https.Response res = await https.put(
      url, 
      headers: {
        "Authorization": "Bearer $token",
          "Accept": "*/*",
          "Content-Type": "application/json; charset=utf-8",
      }
    );
  }
}

/*
* EVENT-PRODUCT
*/
Future<List<cntrl_p.Product>> getEventOffer(int id) async{
  String url = 'https://streetfoodapp.herokuapp.com/event/$id/products';

  String res = await https.read(
    url,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  List<cntrl_p.Product> prod_lst = [];
  var map = jsonDecode(res);
  var lst = map[0];
  var prod = lst["eventProducts"];
  for (var i in prod) {
    var product = i["product"];
    var no_price = cntrl_p.Product.fromMap(product);
    no_price.price = i["price"];
    prod_lst.add(no_price);
  }
  
  return prod_lst;
}

void insertProductToEvent(int e_id,int p_id, double price) async {
  var queryParams = {'price': '$price'};

  Uri uri = Uri.https('streetfoodapp.herokuapp.com', '/event/$e_id/products', queryParams);
  String token = global.global_logged_user.token;
  https.Response res = await https.post(
    uri, 
    headers: {
      "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
      }, 
    body: 
      jsonEncode(
        {"id": p_id,
        }));
}

void deleteProductFromEvent(int e_id, int p_id) async {
  String token = global.global_logged_user.token;
  String url = 'https://streetfoodapp.herokuapp.com/event/$e_id/products/$p_id';
  https.Response res = await https.delete(url, headers: {    
    "Authorization": "Bearer $token",
    "Accept": "*/*",
    "Content-Type": "application/json; charset=utf-8",});
  
}

/*Delete: ProductDelete
  Update: productUpdate + price
*/
void updateEventOffer(int e_id, int p_id, String parameter, double value) async {
  if (parameter == "ProductDelete") {
    deleteProductFromEvent(e_id, p_id);
  }
  else {
    String token = global.global_logged_user.token;
    var queryParams = {'price': '$value'};

    Uri uri = Uri.https('streetfoodapp.herokuapp.com', '/event/$e_id/products/$p_id', queryParams);
    https.Response res = await https.put(
      uri, 
      headers: {    
        "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
      },
            
    );
  }
}
/*
* EVENT-ORDER
*/
Future<List<cntrl_o.Order>> getEventOrders(int e_id) async{
  String url = 'https://streetfoodapp.herokuapp.com/event/$e_id/orders';
  String token = global.global_logged_user.token;
  List<cntrl_o.Order> order_lst = [];

  String res = await https.read(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  List<cntrl_o.Order> orders;  
  List<dynamic> map = jsonDecode(res);
  orders = map.map((i) => cntrl_o.Order.fromMap(i)).toList();
  int o_id;
  List<dynamic> eventOrderProduct;
  for (var o in orders) {
    o_id = o.id;
    url = 'https://streetfoodapp.herokuapp.com/event/$e_id/orders/$o_id';
    res = await https.read(
      url, 
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json; charset=utf-8",
      },
    );
    map = jsonDecode(res);
    cntrl_o.Order order = cntrl_o.Order();
    order.products = [];
    order.price = 0;
    order.status = map.map((f) => f["status"]).toString();
    order.status = order.status.substring(1,order.status.length-1);
    order.id = o_id;
    eventOrderProduct = map.map((f) => f["eventOrderProducts"]).toList();
    for (var f in eventOrderProduct){
      for (var i in f) {
        Map eventProduct = i["eventProduct"];
        Map product = eventProduct["product"];
        double price = eventProduct["price"];
        if (price != null) {
          order.price += price;
        }
        int id = product["id"];
        cntrl_p.Product prod = await getProduct(id);
        order.products.add(prod);
      };
    };
    order_lst.add(order);
  }
  return order_lst;
}

//TODO testing
void addOrder(int e_id, List<int> p_id) async {
  String url = 'https://streetfoodapp.herokuapp.com/event/$e_id/orders';
  String token = global.global_logged_user.token;
  List<Map> list_p = [];
  for (var i in p_id) {
    Map<String, int> m_p = {"id": i};
    list_p.add(m_p);
  }
  print(list_p);
  https.Response res = await https.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    },
    body: jsonEncode(list_p)
  );
  print(res.headers);
  print(res.body);
}

//TODO testing
//value = newStatus
void updateOrder(int e_id, int o_id, String value) async{
  var queryParams = {'status': '$value'};

    Uri uri = Uri.https('streetfoodapp.herokuapp.com', '/event/$e_id/orders/$o_id', queryParams);
  String token = global.global_logged_user.token;

  https.Response res = await https.put(
    uri,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    },
  );
}

/*
* PRODUCT-INGREDIENT
*/
void addIngredientToProduct(int p_id,int i_id) async {
  String url = 'https://streetfoodapp.herokuapp.com/products/$p_id/ingredients';
  String token = global.global_logged_user.token;
   
  https.Response res = await https.post(
    url, 
    headers: {
        "Authorization": "Bearer $token",
        "Accept": "*/*",
        "Content-Type": "application/json; charset=utf-8",
      }, 
    body: 
      jsonEncode({"id":i_id}));
    
}

Future<List<cntrl_i.Ingredient>> getIngredientOfProduct(int p_id) async {
  String url = 'https://streetfoodapp.herokuapp.com/products/$p_id/ingredients';
  String token = global.global_logged_user.token;

  String res = await https.read(
    url,
    headers: {
        "Authorization": "Bearer $token",
        
        "Content-Type": "application/json; charset=utf-8",
      }, 
  );

  var response = jsonDecode(res);
  List<dynamic> p_i_lst = response["productIngredients"];
  List<cntrl_i.Ingredient> i_lst;
  List<dynamic> map = [];
  p_i_lst.forEach((f) => map.add(f["ingredient"]));
  i_lst = map.map((i) => cntrl_i.Ingredient.fromMap(i)).toList();
  return i_lst;
}


