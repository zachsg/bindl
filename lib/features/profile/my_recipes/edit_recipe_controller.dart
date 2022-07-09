import 'package:universal_io/io.dart' as io;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import '../../../models/xmodels.dart';
import '../../../services/db.dart';

final recipeQuantityProvider = StateProvider<double>((ref) => 0.0);

final recipeIngredientProvider = StateProvider<Ingredient>((ref) =>
    const Ingredient(id: -1, name: '', category: IngredientCategory.oils));

final recipeMeasureProvider =
    StateProvider<IngredientMeasure>((ref) => IngredientMeasure.oz);

final recipePreparationMethodProvider = StateProvider<String>((ref) => '');

final recipeIngredientIsOptionalProvider = StateProvider<bool>((ref) => false);

final recipeNeedsSavingProvider = StateProvider<bool>((ref) => false);

final editRecipeProvider = StateNotifierProvider<EditRecipeController, Recipe>(
    (ref) => EditRecipeController(ref: ref));

class EditRecipeController extends StateNotifier<Recipe> {
  EditRecipeController({required this.ref})
      : super(Recipe(
          updatedAt: '',
          ownerId: '',
          name: '',
          cuisine: Cuisine.american,
          recipeType: RecipeType.dinner,
        ));

  final Ref ref;

  void setName(String name) => state = state.copyWith(name: name);

  void setCookTime(int duration) => state = state.copyWith(cookTime: duration);

  void setPrepTime(int duration) => state = state.copyWith(prepTime: duration);

  void setServings(int servings) => state = state.copyWith(servings: servings);

  void setCuisine(Cuisine cuisine) => state = state.copyWith(cuisine: cuisine);

  void setRecipeType(RecipeType recipeType) =>
      state = state.copyWith(recipeType: recipeType);

  void setDiet(Diet diet, bool isDiet) {
    isDiet ? _addDiet(diet) : _removeDiet(diet);
  }

  void _addDiet(Diet diet) {
    List<Diet> diets = [...state.diets];
    diets.add(diet);
    state = state.copyWith(diets: diets);
  }

  void _removeDiet(Diet diet) {
    List<Diet> diets = [...state.diets];
    diets.removeWhere((userDiet) => userDiet == diet);
    state = state.copyWith(diets: diets);
  }

  void setAllergy(Allergy allergy, bool isAllergic) {
    isAllergic ? _addAllergy(allergy) : _removeAllergy(allergy);
  }

  void _addAllergy(Allergy allergy) {
    List<Allergy> allergies = [...state.allergies];
    allergies.add(allergy);
    state = state.copyWith(allergies: allergies);
  }

  void _removeAllergy(Allergy allergy) {
    List<Allergy> allergies = [...state.allergies];
    allergies.removeWhere((userAllergy) => userAllergy == allergy);
    state = state.copyWith(allergies: allergies);
  }

  void setAppliance(Appliance appliance, bool isUsed) {
    isUsed ? _addAppliance(appliance) : _removeAppliance(appliance);
  }

  void _addAppliance(Appliance appliance) {
    List<Appliance> appliances = [...state.appliances];
    appliances.add(appliance);
    state = state.copyWith(appliances: appliances);
  }

  void _removeAppliance(Appliance appliance) {
    List<Appliance> appliances = [...state.appliances];
    appliances.removeWhere((userAppliance) => userAppliance == appliance);
    state = state.copyWith(appliances: appliances);
  }

  Future<bool> setPhoto(XFile image) async {
    final imageX = decodeImage(io.File(image.path).readAsBytesSync());

    if (imageX != null) {
      final thumbnail = copyResize(imageX, width: 600);

      final extension = image.path.split('.').last;
      final reducedPath = '${image.path}reduced.$extension';

      io.File file =
          await io.File(reducedPath).writeAsBytes(encodePng(thumbnail));

      final response =
          await supabase.storage.from('recipe-photos').upload(image.name, file);

      if (response.error == null) {
        final response =
            supabase.storage.from('recipe-photos').getPublicUrl(image.name);

        if (response.error == null) {
          state = state.copyWith(imageUrl: response.data!);
          return true;
        }
      }
    }

    return false;
  }

  void addIngredient(Ingredient ingredient) {
    final ingredients = [...state.ingredients, ingredient];
    state = state.copyWith(ingredients: ingredients);
  }

  void addIngredientWith(Ingredient ingredient, double quantity,
      IngredientMeasure measure, String preparationMethod, bool isOptional) {
    ingredient = ingredient.copyWith(
      quantity: quantity,
      measurement: measure,
      preparationMethod: preparationMethod,
      isOptional: isOptional,
    );
    addIngredient(ingredient);
  }

  Ingredient removeIngredientAtIndex(int index) {
    List<Ingredient> ingredients = List.from(state.ingredients);
    final ingredient = ingredients.removeAt(index);
    state = state.copyWith(ingredients: ingredients);
    return ingredient;
  }

  void insertIngredientAtIndex(int index, Ingredient ingredient) {
    List<Ingredient> ingredients = List.from(state.ingredients);
    ingredients.insert(index, ingredient);
    state = state.copyWith(ingredients: ingredients);
  }

  void updateIngredientAtIndex(int index) {
    final quantity = ref.read(recipeQuantityProvider);
    final measure = ref.read(recipeMeasureProvider);
    final isOptional = ref.read(recipeIngredientIsOptionalProvider);
    final preparationMethod = ref.read(recipePreparationMethodProvider);
    final baseIngredient = ref.read(recipeIngredientProvider);

    final ingredient = state.ingredients[index].copyWith(
      quantity: quantity,
      measurement: measure,
      id: baseIngredient.id,
      name: baseIngredient.name,
      category: baseIngredient.category,
      preparationMethod: preparationMethod,
      nutrition: baseIngredient.nutrition,
      isOptional: isOptional,
    );

    ref.read(recipeIngredientProvider.notifier).state = ingredient;

    final List<Ingredient> ingredients = [];
    var indexInner = 0;
    for (final i in state.ingredients) {
      if (indexInner == index) {
        ingredients.add(ingredient);
      } else {
        ingredients.add(i);
      }
      indexInner++;
    }

    state = state.copyWith(ingredients: ingredients);
  }

  void addStep(String step, String tip) {
    var recipeStep = RecipeStep(
        step: step.replaceAll('\n', ' ').trim(),
        tip: tip.replaceAll('\n', ' ').trim());

    if (!(recipeStep.step.endsWith('.') ||
        recipeStep.step.endsWith('!') ||
        recipeStep.step.endsWith('?'))) {
      recipeStep = recipeStep.copyWith(step: '${recipeStep.step}.');
    }

    if (recipeStep.tip.isNotEmpty) {
      if (!(recipeStep.tip.endsWith('.') ||
          recipeStep.tip.endsWith('!') ||
          recipeStep.tip.endsWith('?'))) {
        recipeStep = recipeStep.copyWith(tip: '${recipeStep.tip}.');
      }
    }

    state = state.copyWith(steps: [...state.steps, recipeStep]);
  }

  RecipeStep removeStepAtIndex(int index) {
    List<RecipeStep> steps = List.from(state.steps);
    final step = steps.removeAt(index);
    state = state.copyWith(steps: steps);
    return step;
  }

  void insertStepAtIndex(int index, RecipeStep step) {
    List<RecipeStep> steps = List.from(state.steps);
    steps.insert(index, step);
    state = state.copyWith(steps: steps);
  }

  void updateStepAtIndex({required String update, required int index}) {
    var step = state.steps[index];

    step = step.copyWith(step: update.replaceAll('\n', ' ').trim());

    state.steps[index] = step;
  }

  void updateTipAtIndex({required String update, required int index}) {
    var step = state.steps[index];

    step = step.copyWith(tip: update.replaceAll('\n', ' ').trim());

    state.steps[index] = step;
  }

  Future<String> validateAndSave() async {
    if (state.name.isEmpty) {
      return 'Recipe name cannot be empty';
    }

    // if (state.steps.isEmpty) {
    //   return 'Steps cannot be empty';
    // }

    // if (state.ingredients.isEmpty) {
    //   return 'Ingredients cannot be empty';
    // }

    // if (state.imageUrl.isEmpty) {
    //   return 'Image cannot be empty';
    // }

    state = state.copyWith(updatedAt: DateTime.now().toIso8601String());
    state = state.copyWith(ownerId: supabase.auth.currentUser!.id);

    final recipeJson = state.toJson();
    if (state.id == null) {
      recipeJson.removeWhere((key, value) => key == 'id');
    }

    final success = await DB.saveRecipe(recipeJson);

    return success ? 'Recipe saved' : 'Failed to save';
  }

  void setup(Recipe recipe) {
    state = state.copyWith(
      id: recipe.id,
      name: recipe.name,
      imageUrl: recipe.imageUrl,
      videoUrl: recipe.videoUrl,
      steps: recipe.steps,
      ingredients: recipe.ingredients,
      allergies: recipe.allergies,
      appliances: recipe.appliances,
      cuisine: recipe.cuisine,
      diets: recipe.diets,
      recipeType: recipe.recipeType,
      recipeTags: recipe.recipeTags,
      servings: recipe.servings,
      cookTime: recipe.cookTime,
      prepTime: recipe.prepTime,
    );
  }

  void reset() {
    final recipe = Recipe(
        updatedAt: '',
        ownerId: '',
        name: '',
        cuisine: Cuisine.american,
        diets: [],
        appliances: [],
        recipeType: RecipeType.dinner);

    state = recipe;
  }
}
