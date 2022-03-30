import 'dart:io';

import 'package:bodai/models/recipe_step.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/xmodels.dart';
import '../../../services/db.dart';
import 'widgets/recipe_ingredients_widget.dart';

final editRecipeProvider = StateNotifierProvider<EditRecipeController, Recipe>(
    (ref) => EditRecipeController(ref: ref));

class EditRecipeController extends StateNotifier<Recipe> {
  EditRecipeController({required this.ref})
      : super(const Recipe(
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

  void setDiet(Diet diet) => state = state.copyWith(diet: diet);

  void setRecipeType(RecipeType recipeType) =>
      state = state.copyWith(recipeType: recipeType);

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
    final imagex = decodeImage(File(image.path).readAsBytesSync());

    if (imagex != null) {
      final thumbnail = copyResize(imagex, width: 600);

      final extension = image.path.split('.').last;
      final reducedPath = image.path + 'reduced.' + extension;

      File file = await File(reducedPath).writeAsBytes(encodePng(thumbnail));

      final response =
          await supabase.storage.from('recipe-photos').upload(image.name, file);

      if (response.error == null) {
        final response = await supabase.storage
            .from('recipe-photos')
            .getPublicUrl(image.name);

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
    final ingredient = state.ingredients.removeAt(index);
    state = state.copyWith(ingredients: state.ingredients);
    return ingredient;
  }

  void insertIngredientAtIndex(int index, Ingredient ingredient) {
    state.ingredients.insert(index, ingredient);
    state = state.copyWith(ingredients: state.ingredients);
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
      recipeStep = recipeStep.copyWith(step: recipeStep.step + '.');
    }

    if (recipeStep.tip.isNotEmpty) {
      if (!(recipeStep.tip.endsWith('.') ||
          recipeStep.tip.endsWith('!') ||
          recipeStep.tip.endsWith('?'))) {
        recipeStep = recipeStep.copyWith(tip: recipeStep.tip + '.');
      }
    }

    if (state.steps.isEmpty) {
      state = state.copyWith(steps: [recipeStep]);
    } else {
      state.steps.add(recipeStep);
      state = state.copyWith(steps: state.steps);
    }
  }

  RecipeStep removeStepAtIndex(int index) {
    final step = state.steps.removeAt(index);
    state = state.copyWith(steps: state.steps);
    return step;
  }

  void insertStepAtIndex(int index, RecipeStep step) {
    state.steps.insert(index, step);
    state = state.copyWith(steps: state.steps);
  }

  void updateStepAtIndex({required String update, required int index}) {
    var step = state.steps[index];

    step = step.copyWith(step: update.replaceAll('\n', ' ').trim());

    state.steps[index] = step;
    state = state;
  }

  void updateTipAtIndex({required String update, required int index}) {
    var step = state.steps[index];

    step = step.copyWith(tip: update.replaceAll('\n', ' ').trim());

    state.steps[index] = step;
    state = state;
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

    if (state.imageUrl.isEmpty) {
      return 'Image cannot be empty';
    }

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
      diet: recipe.diet,
      recipeType: recipe.recipeType,
      recipeTags: recipe.recipeTags,
      servings: recipe.servings,
      cookTime: recipe.cookTime,
      prepTime: recipe.prepTime,
    );
  }

  void reset() {
    const recipe = Recipe(
        updatedAt: '',
        ownerId: '',
        name: '',
        cuisine: Cuisine.american,
        diet: Diet.omnivore,
        appliances: [],
        recipeType: RecipeType.dinner);

    state = recipe;
  }
}