import 'package:universal_io/io.dart' as IO;
import 'dart:math';

import 'package:bodai/services/db.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../models/xmodels.dart';
import 'providers.dart';

final userProvider = StateNotifierProvider<UserController, User>(
    (ref) => UserController(ref: ref));

class UserController extends StateNotifier<User> {
  UserController({required this.ref})
      : super(const User(id: '', name: '', handle: '', updatedAt: ''));

  final Ref ref;

  Future<void> load() async {
    final data = await DB.loadUser();
    state = User.fromJson(data);
  }

  Future<bool> save() async {
    if (supabase.auth.currentUser != null) {
      state = state.copyWith(id: supabase.auth.currentUser!.id);
    }

    if (state.name.isEmpty) {
      state = state.copyWith(name: 'Anon');
    }

    if (state.handle.isEmpty) {
      final random = Random();
      final randomString = random.nextInt(9).toString() +
          random.nextInt(9).toString() +
          random.nextInt(9).toString();

      if (state.name.isEmpty) {
        final handle =
            supabase.auth.currentUser!.email!.split('@').first + randomString;
        state = state.copyWith(handle: handle);
      } else {
        final handle = state.name.split(' ').first + randomString;
        state = state.copyWith(handle: handle);
      }
    }

    state = state.copyWith(updatedAt: DateTime.now().toIso8601String());
    final userJSON = state.toJson();

    //TODO: If saving fails it's probably because handle wasn't unique?
    final success = await DB.saveUser(userJSON);

    return success ? true : false;
  }

  void setName(String name) => state = state.copyWith(name: name);

  //TODO: Need to do validation logic before saving handle to ensure it's unique?
  void setHandle(String handle) => state = state.copyWith(handle: handle);

  void setBio(String bio) => state = state.copyWith(bio: bio);

  void setExperience(Experience experience) =>
      state = state.copyWith(experience: experience);

  Future<bool> setAvatar(XFile image) async {
    final imageX = decodeImage(IO.File(image.path).readAsBytesSync());

    if (imageX != null) {
      final thumbnail = copyResize(imageX, width: 600);

      final extension = image.path.split('.').last;
      final reducedPath = '${image.path}reduced.$extension';

      IO.File file =
          await IO.File(reducedPath).writeAsBytes(encodePng(thumbnail));

      final response =
          await supabase.storage.from('avatars').upload(image.name, file);

      if (response.error == null) {
        final response =
            supabase.storage.from('avatars').getPublicUrl(image.name);

        if (response.error == null) {
          state = state.copyWith(avatar: response.data!);
          return true;
        }
      }
    }

    return false;
  }

  void setDiet(Diet diet, bool isFavorite) {
    isFavorite ? _addDiet(diet) : _removeDiet(diet);
    save();
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
    save();
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

  void setAppliance(Appliance appliance, bool isOwned) {
    isOwned ? _addAppliance(appliance) : _removeAppliance(appliance);
    save();
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

  void setCuisine(Cuisine cuisine, bool isFavorite) {
    isFavorite ? _addCuisine(cuisine) : _removeCuisine(cuisine);
    save();
  }

  void _addCuisine(Cuisine cuisine) {
    List<Cuisine> cuisines = [...state.cuisines];
    cuisines.add(cuisine);
    state = state.copyWith(cuisines: cuisines);
  }

  void _removeCuisine(Cuisine cuisine) {
    List<Cuisine> cuisines = [...state.cuisines];
    cuisines.removeWhere((userCuisine) => userCuisine == cuisine);
    state = state.copyWith(cuisines: cuisines);
  }

  Future<User> loadUserWithId(String id) async {
    ref.read(loadingProvider.notifier).state = true;

    final data = await DB.loadUserWithId(id);
    final user = User.fromJson(data);

    ref.read(loadingProvider.notifier).state = false;

    return user;
  }

  Future<List<User>> loadUsersWithIds(List<String> ids) async {
    ref.read(loadingProvider.notifier).state = true;

    final List<User> users = [];
    final data = await DB.loadUsersWithIds(ids);
    for (final userJson in data) {
      users.add(User.fromJson(userJson));
    }

    return users;
  }

  Future<void> follow(String id) async {
    if (state.following.contains(id)) {
      List<String> following = List.from(state.followers);
      following.removeWhere((id2) => id2 == id);

      state = state.copyWith(following: following);
    } else {
      state = state.copyWith(following: [...state.following, id]);
    }

    await DB.saveUser(state.toJson());
  }
}
