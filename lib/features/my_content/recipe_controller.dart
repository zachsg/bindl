import 'package:bodai/data/xdata.dart';
import 'package:bodai/models/xmodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeProvider = ChangeNotifierProvider((ref) => RecipeController());

class RecipeController extends ChangeNotifier {
  int _id = 0;
  String _name = '';
  List<Ingredient> _ingredients = [];
  List<String> _steps = [];
  int _servings = 2;
  int _duration = 25;
  String _imageURL = '';
  List<Tag> _tags = [];
  List<Comment> _comments = [];

  final List<Meal> _allMyRecipes = [];

  int get id => _id;

  String get name => _name;

  List<Ingredient> get ingredients => _ingredients;

  List<String> get steps => _steps;

  int get servings => _servings;

  int get duration => _duration;

  String get imageURL => _imageURL;

  List<Meal> get allMyRecipes => _allMyRecipes;

  void setID(int id) {
    _id = id;

    notifyListeners();
  }

  void setName(String name) {
    _name = name;

    notifyListeners();
  }

  void setImageURL(String url) {
    _imageURL = url;

    notifyListeners();
  }

  void setServings(int servings) {
    _servings = servings;

    notifyListeners();
  }

  void setDuration(int duration) {
    _duration = duration;

    notifyListeners();
  }

  void addIngredient(Ingredient ingredient) {
    _ingredients.add(ingredient);

    notifyListeners();
  }

  Ingredient removeIngredientAtIndex(int index) {
    var ingredient = _ingredients.removeAt(index);

    notifyListeners();

    return ingredient;
  }

  void insertIngredientAtIndex(int index, Ingredient ingredient) {
    _ingredients.insert(index, ingredient);

    notifyListeners();
  }

  void addStep(String step) {
    step = step.replaceAll('\n', ' ');
    step = step.trim();
    if (!(step.endsWith('.') || step.endsWith('!') || step.endsWith('?'))) {
      step += '.';
    }

    _steps.add(step);

    notifyListeners();
  }

  String removeStepAtIndex(int index) {
    final step = _steps.removeAt(index);

    notifyListeners();

    return step;
  }

  void insertStepAtIndex(int index, String step) {
    _steps.insert(index, step);

    notifyListeners();
  }

  void updateStepAtIndex({required String text, required int index}) {
    _steps.removeAt(index);
    _steps.insert(index, text.trim());
  }

  Future<String> validateAndSave() async {
    if (_name.isEmpty) {
      return 'Recipe name cannot be empty';
    }

    if (_steps.isEmpty) {
      return 'Steps cannot be empty';
    }

    if (_ingredients.isEmpty) {
      return 'Ingredients cannot be empty';
    }

    if (_imageURL.isEmpty) {
      return 'Image cannot be empty';
    }

    var allergies = getAllergies();

    if (supabase.auth.currentUser != null) {
      var owner = supabase.auth.currentUser!.id;

      var recipe = Meal(
        id: _id,
        owner: owner,
        name: _name,
        servings: _servings,
        duration: _duration,
        imageURL: _imageURL,
        steps: _steps,
        ingredients: _ingredients,
        tags: _tags,
        allergies: allergies,
        comments: _comments,
      );

      var recipeJSON = recipe.toJson();

      await DB.saveRecipe(recipeJSON);

      notifyListeners();

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

    for (var ingredient in _ingredients) {
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

  Future<void> load() async {
    if (supabase.auth.currentUser != null) {
      var recipesJson =
          await DB.loadAllMealsOwnedBy(supabase.auth.currentUser!.id);

      _allMyRecipes.clear();

      for (var json in recipesJson) {
        var recipe = Meal.fromJson(json);
        _allMyRecipes.add(recipe);
      }

      notifyListeners();
    }
  }

  void setupSelf(Meal meal) {
    _id = meal.id;
    _name = meal.name;
    _servings = meal.servings;
    _duration = meal.duration;
    _imageURL = meal.imageURL;
    _ingredients = meal.ingredients;
    _steps = meal.steps;
    _tags = meal.tags;
    _comments = meal.comments;

    notifyListeners();
  }

  void resetSelf() {
    _id = 0;
    _name = '';
    _servings = 2;
    _duration = 25;
    _imageURL = '';
    _ingredients = [];
    _steps = [];
    _tags = [];
    _comments = [];

    notifyListeners();
  }
}