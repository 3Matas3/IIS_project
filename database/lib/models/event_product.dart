import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:database/models/event_order_product.dart';
import 'package:database/models/product.dart';
import 'package:database/models/event.dart';

class EventProduct extends ManagedObject<_EventProduct> implements _EventProduct{

}

class _EventProduct{
  @primaryKey
  int id;

  @Column(nullable: false, defaultValue: '0')
  double price;

  @Relate(#eventProducts, isRequired: false, onDelete: DeleteRule.cascade)
  Product product;

  @Relate(#eventProducts, isRequired: false, onDelete: DeleteRule.cascade)
  Event event;

  ManagedSet<EventOrderProduct> eventOrderProducts;
}