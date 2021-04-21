import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/event.dart';
import 'package:database/models/event_product.dart';
import 'package:database/models/product.dart';

class EventController extends ResourceController {
  EventController(this.context);

  final ManagedContext context;

  @Operation.get("e_id")
  Future<Response> getAllProductsByEventId(@Bind.path("e_id") int id) async {
    final event = await context.fetchObjectWithID<Event>(id);

    if(event == null)
      return Response.badRequest();

    final Query q = Query<Event>(context)
     ..where((eP) => eP.id).equalTo(id)
     ..join(set: (p) => p.eventProducts).join(object: (pi) => pi.product);

    final res = await q.fetch();
    return Response.ok(res);
  }

  @Operation.get("e_id", "p_id")
  Future<Response> getEventProductById(@Bind.path("e_id") int e_id, @Bind.path("p_id") int p_id) async {
    final event = await context.fetchObjectWithID<Event>(e_id);

    if(event == null)
      return Response.badRequest();
    
    final Query q = Query<EventProduct>(context)
      ..join(object: (eP) => eP.product)
      ..where((eP) => eP.event).identifiedBy(e_id)
      ..where((eP) => eP.product).identifiedBy(p_id);

    
    final res = await q.fetchOne();
    return Response.ok(res);
  }

  @Operation.post("e_id")
  Future<Response> addProduct(@Bind.path("e_id") int id, @Bind.body() Product product, @Bind.query('price') double price) async {
  final event = await context.fetchObjectWithID<Event>(id);

  if(event == null)
    return Response.badRequest();

  final query = Query<EventProduct>(context)
    ..values.event = event
    ..values.product = product
    ..values.price = price;

  final eP = await query.insert();

  final retQ = Query<Product>(context)
    ..join(set: (p) => p.eventProducts).where((e) => e.id).equalTo(eP.id)
    ..where((p) => p.id).equalTo(product.id);

  final res = await retQ.fetchOne();

  return Response.ok(res);
}

  // this deletes only product from event, not product!!!
  @Operation.delete("e_id", "p_id")
  Future<Response> deleteEventProduct(@Bind.path("e_id") int e_id, @Bind.path("p_id") int p_id) async {
    final event = await context.fetchObjectWithID<Event>(e_id);

    if(event == null)
      return Response.badRequest();
    
    final Query q = Query<EventProduct>(context)
     ..where((eP) => eP.event).identifiedBy(e_id)
     ..where((eP) => eP.product).identifiedBy(p_id);

    final res = await q.delete();
    return Response.ok(res);
  }

  @Operation.put("e_id", "p_id")
    Future<Response> updateEventProduct(@Bind.path("e_id") int eId, @Bind.path("p_id") int pId, @Bind.query('price') double price) async {
      final event = await context.fetchObjectWithID<Event>(eId);

      if(event == null)
        return Response.badRequest();
    
    final Query q = Query<EventProduct>(context)
     ..where((eP) => eP.event).identifiedBy(eId)
     ..where((eP) => eP.product).identifiedBy(pId)
     ..values.price = price;

    final res = await q.updateOne();
    return Response.ok(res);
  }

}
