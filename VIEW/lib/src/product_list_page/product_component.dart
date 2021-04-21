import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

import 'package:controller/src/models/product.dart';
import 'product_service.dart';
import '../route_paths.dart';

@Component(
  selector: 'my-product',
  templateUrl: 'product_component.html',
  directives: [coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    AutoFocusDirective,],
  providers: 
    [ClassProvider(ProductService),
    ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
)

class ProductComponent implements OnActivate {
  Product product;
  final ProductService _productService;
  final Location _location;

  ProductComponent(this._productService, this._location);
  @override
  void onActivate(_, RouterState current) async {
    final id = getId(current.parameters);
    if (id != null) product = await (_productService.get(id));
  }
  
  void goBack() => _location.back();
}