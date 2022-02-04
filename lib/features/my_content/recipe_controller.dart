import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeProvider =
    StateNotifierProvider<RecipeController, Meal>((_) => RecipeController());

class RecipeController extends StateNotifier<Meal> {
  RecipeController()
      : super(const Meal(
            id: 0,
            owner: '',
            name: '',
            servings: 2,
            duration: 25,
            imageURL: '',
            steps: [],
            ingredients: [],
            tags: [],
            allergies: [],
            comments: []));

  void setID(int id) {
    state = state.copyWith(id: id);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setImageURL(String url) {
    state = state.copyWith(imageURL: url);
  }

  void setServings(int servings) {
    state = state.copyWith(servings: servings);
  }

  void setDuration(int duration) {
    state = state.copyWith(duration: duration);
  }

  void addIngredient(Ingredient ingredient) {
    state.ingredients.add(ingredient);
    state = state.copyWith(ingredients: state.ingredients);
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

  void addStep(String step) {
    step = step.replaceAll('\n', ' ');
    step = step.trim();
    if (!(step.endsWith('.') || step.endsWith('!') || step.endsWith('?'))) {
      step += '.';
    }

    state.steps.add(step);
    state = state.copyWith(steps: state.steps);
  }

  String removeStepAtIndex(int index) {
    final step = state.steps.removeAt(index);
    state = state.copyWith(steps: state.steps);
    return step;
  }

  void insertStepAtIndex(int index, String step) {
    state.steps.insert(index, step);
    state = state.copyWith(steps: state.steps);
  }

  void updateStepAtIndex({required String text, required int index}) {
    state.steps.removeAt(index);
    state.steps.insert(index, text.trim());
    state = state.copyWith(steps: state.steps);
  }

  Future<String> validateAndSave() async {
    if (state.name.isEmpty) {
      return 'Recipe name cannot be empty';
    }

    if (state.steps.isEmpty) {
      return 'Steps cannot be empty';
    }

    if (state.ingredients.isEmpty) {
      return 'Ingredients cannot be empty';
    }

    if (state.imageURL.isEmpty) {
      return 'Image cannot be empty';
    }

    var allergies = getAllergies();

    if (supabase.auth.currentUser != null) {
      var owner = supabase.auth.currentUser!.id;

      var recipe = Meal(
        id: state.id,
        owner: owner,
        name: state.name,
        servings: state.servings,
        duration: state.duration,
        imageURL: state.imageURL,
        steps: state.steps,
        ingredients: state.ingredients,
        tags: state.tags,
        allergies: allergies,
        comments: state.comments,
      );

      var recipeJSON = recipe.toJson();

      await DB.saveRecipe(recipeJSON);

      return 'Success';
    } else {
      return 'You\'re not logged in';
    }
  }

  List<Allergy> getAllergies() {
    List<Allergy> allergies = [];

    var hasGluten = false;
    var hasDairy = false;
    var hasShellfish = false;
    var hasSoy = false;
    var hasEgg = false;
    var hasSesame = false;
    var hasTreeNuts = false;
    var hasPeanuts = false;
    var hasMeat = false;
    var hasSeafood = false;

    for (var ingredient in state.ingredients) {
      var simpleIngredient =
          ingredient.name.toLowerCase().split(',').first.trim();

      if (simpleIngredient.contains('meat') ||
          simpleIngredient.contains('chicken') ||
          simpleIngredient.contains('beef') ||
          simpleIngredient.contains('lamb') ||
          simpleIngredient.contains('turkey') ||
          simpleIngredient.contains('steak') ||
          simpleIngredient.contains('pork') ||
          simpleIngredient.contains('bacon') ||
          simpleIngredient.contains('sirloin') ||
          simpleIngredient.contains('filet mignon') ||
          simpleIngredient.contains('t-bone')) {
        hasMeat = true;
      }

      if (simpleIngredient.contains('peanut')) {
        hasPeanuts = true;
      }

      if ((simpleIngredient.contains('nut') &&
              !(simpleIngredient.contains('pea') ||
                  simpleIngredient.contains('tiger'))) ||
          simpleIngredient.contains('cashew') ||
          simpleIngredient.contains('coconut') ||
          simpleIngredient.contains('almond') ||
          simpleIngredient.contains('walnut') ||
          simpleIngredient.contains('pecan') ||
          (simpleIngredient.contains('pine') &&
              !simpleIngredient.contains('apple'))) {
        hasTreeNuts = true;
      }

      if (simpleIngredient.contains('sesame')) {
        hasSesame = true;
      }

      if (simpleIngredient.contains('egg') &&
          !simpleIngredient.contains('tofu')) {
        hasEgg = true;
      }

      if (simpleIngredient.contains('macaroni') ||
          simpleIngredient.contains('ziti') ||
          simpleIngredient.contains('spaghetti') ||
          simpleIngredient.contains('lasagna') ||
          simpleIngredient.contains('ravioli') ||
          simpleIngredient.contains('penne') ||
          simpleIngredient.contains('rigatoni') ||
          simpleIngredient.contains('corkscrew') ||
          (simpleIngredient.contains('pasta') &&
              !simpleIngredient.contains('gluten')) ||
          (simpleIngredient.contains('soy sauce') &&
              !simpleIngredient.contains('gluten')) ||
          simpleIngredient.contains('wheat') ||
          simpleIngredient.contains('bread') ||
          (simpleIngredient.contains('cracker') &&
              !(simpleIngredient.contains('rice'))) ||
          (simpleIngredient.contains('flour') &&
              !(simpleIngredient.contains('almond') ||
                  simpleIngredient.contains('cassava') ||
                  simpleIngredient.contains('arrowroot') ||
                  simpleIngredient.contains('coconut') ||
                  simpleIngredient.contains('chickpea') ||
                  simpleIngredient.contains('tapioca') ||
                  simpleIngredient.contains('sorghum') ||
                  simpleIngredient.contains('amaranth') ||
                  simpleIngredient.contains('teff') ||
                  simpleIngredient.contains('rice') ||
                  simpleIngredient.contains('oat') ||
                  simpleIngredient.contains('corn') ||
                  simpleIngredient.contains('tigernut')))) {
        hasGluten = true;
      }

      if (simpleIngredient.contains('soy') ||
          simpleIngredient.contains('tofu')) {
        hasSoy = true;
      }

      if (simpleIngredient.contains('cheese') ||
          (simpleIngredient.contains('butter') &&
              !(simpleIngredient.contains('almond') ||
                  simpleIngredient.contains('peanut'))) ||
          (simpleIngredient.contains('milk') &&
              !(simpleIngredient.contains('almond') ||
                  simpleIngredient.contains('soy') &&
                      simpleIngredient.contains('oat') &&
                      simpleIngredient.contains('coconut')))) {
        hasDairy = true;
      }

      if (simpleIngredient.contains('shrimp') ||
          simpleIngredient.contains('scallop') ||
          simpleIngredient.contains('clam') ||
          simpleIngredient.contains('oyster') ||
          simpleIngredient.contains('muscles') ||
          simpleIngredient.contains('lobster') ||
          simpleIngredient.contains('crab') ||
          simpleIngredient.contains('prawn') ||
          simpleIngredient.contains('octopus') ||
          simpleIngredient.contains('snail') ||
          simpleIngredient.contains('squid') ||
          simpleIngredient.contains('crawfish') ||
          simpleIngredient.contains('crayfish')) {
        hasShellfish = true;
        hasSeafood = true;
      }

      if (simpleIngredient.contains('fish') ||
          simpleIngredient.contains('salmon') ||
          simpleIngredient.contains('cod') ||
          simpleIngredient.contains('tuna') ||
          simpleIngredient.contains('swordfish') ||
          simpleIngredient.contains('trout') ||
          simpleIngredient.contains('tilapia') ||
          simpleIngredient.contains('catfish') ||
          simpleIngredient.contains('swordfish')) {
        hasSeafood = true;
      }
    }

    if (hasGluten) {
      allergies.add(Allergy.gluten);
    }

    if (hasDairy) {
      allergies.add(Allergy.dairy);
    }

    if (hasShellfish) {
      allergies.add(Allergy.shellfish);
    }

    if (hasSoy) {
      allergies.add(Allergy.soy);
    }

    if (hasEgg) {
      allergies.add(Allergy.egg);
    }

    if (hasSesame) {
      allergies.add(Allergy.sesame);
    }

    if (hasTreeNuts) {
      allergies.add(Allergy.treeNuts);
    }

    if (hasPeanuts) {
      allergies.add(Allergy.peanuts);
    }

    if (hasMeat) {
      allergies.add(Allergy.meat);
    }

    if (hasSeafood) {
      allergies.add(Allergy.seafood);
    }

    return allergies;
  }

  void setupSelf(Meal meal) {
    state = state.copyWith(
      id: meal.id,
      name: meal.name,
      servings: meal.servings,
      duration: meal.duration,
      imageURL: meal.imageURL,
      ingredients: meal.ingredients,
      steps: meal.steps,
      tags: meal.tags,
      comments: meal.comments,
    );
  }

  void resetSelf() {
    state = state.copyWith(
      id: 0,
      name: '',
      servings: 2,
      duration: 25,
      imageURL: '',
      ingredients: [],
      steps: [],
      tags: [],
      comments: [],
    );
  }
}
