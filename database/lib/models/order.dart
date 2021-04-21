import 'package:aqueduct/aqueduct.dart';
import 'package:database/models/event_order_product.dart';
import 'package:database/models/user.dart';
import 'package:database/models/event.dart';

enum OrderStatus{
  ordered, ready, done, cancelled
}

class Order extends ManagedObject<_Order> implements _Order{
  @override
  void willInsert() {
  }
  @override
  void willUpdate() {

        }
}

class _Order{
  @primaryKey
  int id;
  
  @Column(defaultValue: "'ordered'")
  OrderStatus status;

  @Relate(#orders)
  Event event;

  ManagedSet<EventOrderProduct> eventOrderProducts;
}