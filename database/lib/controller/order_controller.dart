import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/event.dart';
import 'package:database/models/event_order_product.dart';
import 'package:database/models/order.dart';
import 'package:database/models/event_product.dart';
import 'package:database/models/product.dart';
import 'package:database/models/user.dart';

class OrderController extends ResourceController {
  OrderController(this.context);

  final ManagedContext context;

  @Operation.get("e_id")
  Future<Response> getAllOrders(@Bind.path("e_id") int e_id) async {
    Event event;
    event = await context.fetchObjectWithID(e_id);

    if(event == null)
      return Response.badRequest();


    final Query q = Query<Order>(context)
     ..where((o) => o.event).identifiedBy(e_id);

    final res = await q.fetch();
    return Response.ok(res);
  }

  @Operation.get("e_id", "o_id")
  Future<Response> getOrderById(@Bind.path("e_id") int e_id, @Bind.path("o_id") int o_id) async {
      Event event;
      Order order;
    
      event = await context.fetchObjectWithID(e_id);
        if(event == null)
      return Response.badRequest();

      order = await context.fetchObjectWithID(o_id);
      if(order == null)
        return Response.badRequest();

    final Query q = Query<Order>(context)
     ..where((o) => o.event.id).equalTo(e_id)
     ..where((o) => o.id).equalTo(o_id)
     ..join(set: (p) => p.eventOrderProducts).join(object: (p) =>p.eventProduct);
     //..where((eop) => eop.order).identifiedBy(e_id);

    final res = await q.fetch();
    //print(res);
    return Response.ok(res);
  }

  //berie to Zoznam produktov, staci id produktu, priklad: 
  /*
    {
      [
        {'id': int}
      ]
    }
  */
  @Operation.post("e_id")
  Future<Response> addOrder(@Bind.path("e_id") int e_id, @Bind.body() List<Product> products) async {
  final event = await context.fetchObjectWithID<Event>(e_id);

  if(event == null)
    return Response.badRequest();

  var order = Order()
    ..event = event;

  order = await Query.insertObject(context, order);

  //pre kazdy produkt
  products.forEach((p) async{
    //zisti event product daneho produktu v evente
    final q = Query<EventProduct>(context)
      ..join(object: (ep) => ep.product)
      ..where((ep) => ep.event).identifiedBy(e_id)
      ..where((ep) => ep.product).identifiedBy(p.id);
    
      final eventProduct = await q.fetchOne();
      
      final iq = Query<EventOrderProduct>(context)
        ..values.order = order
        ..values.eventProduct = eventProduct;

        await iq.insert();
        
  });

  
    return Response.ok(order);

  }

  //zerie to iba sting so statusom 
  @Operation.put("e_id", "o_id")
    Future<Response> editOrderStatus(@Bind.path("e_id") int e_id, @Bind.path("o_id") int o_id, @Bind.query('status') String stat) async {
      Event event;
      Order order;
      OrderStatus status;
      if(stat == "ready") {
        status = OrderStatus.ready;
      }
      else if (stat == "done") {
        status = OrderStatus.done;
      }
      else if (stat == "cancelled") {
        status = OrderStatus.cancelled;
      }
      else {
        return Response.badRequest();
      }
    
      event = await context.fetchObjectWithID(e_id);
        if(event == null)
      return Response.badRequest();

      order = await context.fetchObjectWithID(o_id);
      if(order == null)
        return Response.badRequest();
    
    final Query q = Query<Order>(context)
     ..where((eP) => eP.event).identifiedBy(e_id)
     ..where((eP) => eP.id).equalTo(o_id)
     ..values.status = status;

    final res = await q.updateOne();
    return Response.ok(res);
}

@Operation.delete("e_id", "o_id")
    Future<Response> deleteOrder(@Bind.path("e_id") int e_id, @Bind.path("o_id") int o_id) async {
      Event event;
      Order order;
    
      event = await context.fetchObjectWithID(e_id);
        if(event == null)
      return Response.badRequest();

      order = await context.fetchObjectWithID(o_id);
      if(order == null)
        return Response.badRequest();


   final Query q = Query<Order>(context)
    ..where((o) => o.event).identifiedBy(e_id)
    ..where((o) => o.id).equalTo(o_id)
    ..values.status = OrderStatus.cancelled;

    final res = await q.updateOne();
    return Response.ok(res);
    }
}