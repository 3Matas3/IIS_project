import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';


import 'package:controller/src/models/product.dart';
import '../product_list_page/product_service.dart';
import '../route_paths.dart';


@Component(
  selector: 'product_list_component',
  templateUrl: 'product_list_component.html',
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
    ClassProvider(ProductService),
  ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
  pipes: [commonPipes],
)

class ProductListComponent implements OnInit
{
  final ProductService _productService;
  final Router _router;
  List<Product> products;
  Product selected;

  ProductListComponent(this._router, this._productService);

  Future<void> _getProducts() async {
    products = await _productService.getAll();
  }

  void ngOnInit() => _getProducts();

  void onSelect(Product product) => selected = product;

  String _productUrl(int id) =>
      RoutePaths.product.toUrl(parameters: {idParam: '$id'});

  Future<NavigationResult> gotoDetail(Product selected) =>
      _router.navigate(_productUrl(selected.id));

  Future<NavigationResult> goToEvents() =>
      _router.navigate(RoutePaths.event_list.toUrl());

}
