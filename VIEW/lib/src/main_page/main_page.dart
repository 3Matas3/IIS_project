import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:controller/src/models/event.dart';
import '../event_list_page/event_service.dart';
import '../route_paths.dart';

@Component(
  selector: 'main_page',
  templateUrl: 'main_page.html',
  directives: [
    coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    AutoFocusDirective,
    ],
  providers: [
    ClassProvider(EventService),
    ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
  pipes: [commonPipes],
)

class MainPageComponent implements OnInit
{  
  final Router _router;
  final EventService _eventService;
  List<Event> events;

  MainPageComponent(this._router, this._eventService);

  Future<void> _getEvents() async {
    events = await _eventService.getAll();
    
    for (var e in events) {
      e.offer = await _eventService.getOffer(e.id);
    }
  }

  void ngOnInit() => _getEvents();

  Future<NavigationResult> goToLogin() =>
    _router.navigate(RoutePaths.login.toUrl());
}

