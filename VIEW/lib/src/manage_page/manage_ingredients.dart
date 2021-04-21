import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import '../route_paths.dart';

import 'package:controller/src/models/ingredient.dart';
import 'ingredient_service.dart';

import 'package:controller/src/databaseHandle.dart';
import 'package:controller/sharedUserLibrary.dart';

@Component(
  selector: 'manage_ingredients',
  templateUrl: 'manage_ingredients.html',
  directives: [coreDirectives, 
    formDirectives,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
    AutoFocusDirective,],
  providers: [
    ClassProvider(IngredientService),
  ],
  styles: ['''
    .button {
      background-color: #808080 !important;
      color: white;
    }
  '''],
)

class ManageIngredientsComponent implements OnInit 
{
  final IngredientService _ingredientService;
  final Router _router;
  List<Ingredient> ingredients;
  bool submitted = false;
  bool showRemoveMess = false;
  Ingredient ingredient;
  Ingredient newIngredient = Ingredient();
  Ingredient remIngredient = Ingredient();

  ManageIngredientsComponent(this._router, this._ingredientService);

  Future<void> _getIngredients() async {
    ingredients = await _ingredientService.getAll();
  }

  void ngOnInit() async {
    if(!global_user_manager.isAdmin(global_logged_user)) {
      //Chybove vyskakovaci okno
      await goBack();
    }
     await _getIngredients();
  }
  
  Future<NavigationResult> goBack() =>
    _router.navigate(RoutePaths.event_list.toUrl());

  void submitRemove()
  {
    this.ingredients.remove(remIngredient);
    deleteIngredient(remIngredient.id);
    showRemoveMess = false;
  }

  void remove(Ingredient ingredient)
  {
    remIngredient = ingredient;
    showRemoveMess = true;
  }

  void onSubmit() => submitted = true;

  void addIngredient()
  {
    onSubmit();
    newIngredient = Ingredient();
    newIngredient.name = '';
  }

  void clear()
  {
    submitted = false;
    this.newIngredient.name = '';
  }
  
  void saveIngredient() async
  {
    this.ingredients.add(newIngredient);
    submitted = false;
    newIngredient.id = await insertIngredient(newIngredient.name);
  }

  void cancel()
  {
    submitted = false;
    showRemoveMess = false;
  }
}