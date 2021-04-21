import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/order.dart';
import 'package:database/models/event_product.dart';

class EventOrderProduct extends ManagedObject<_EventOrderProduct> implements _EventOrderProduct{

}

class _EventOrderProduct{
  @primaryKey
  int id;


  @Relate(#eventOrderProducts, isRequired: false, onDelete: DeleteRule.cascade)
  Order order;

  @Relate(#eventOrderProducts, isRequired: false, onDelete: DeleteRule.cascade)
  EventProduct eventProduct;
}