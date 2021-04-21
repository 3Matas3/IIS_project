import 'package:aqueduct/aqueduct.dart';
import 'package:database/database.dart';
import 'package:database/models/event_product.dart';
import 'package:database/models/order.dart';

class Event extends ManagedObject<_Event> implements _Event{
  @override
  void willInsert() {
  }
  @override
  void willUpdate() {

        }


}

class _Event{
  @primaryKey
  int id;

  @Column(nullable: false)
  String name;

  String date;

  ManagedSet<EventProduct> eventProducts;
  ManagedSet<Order> orders; 

}