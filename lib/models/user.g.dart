// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String,
      updatedAt: json['updated_at'] as String,
      name: json['name'] as String,
      handle: json['handle'] as String,
      avatar: json['avatar'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      experience:
          $enumDecodeNullable(_$ExperienceEnumMap, json['experience']) ??
              Experience.novice,
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AllergyEnumMap, e))
              .toList() ??
          const [],
      appliances: (json['appliances'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ApplianceEnumMap, e))
              .toList() ??
          const [
            Appliance.oven,
            Appliance.stovetop,
            Appliance.airFryer,
            Appliance.instantPot,
            Appliance.blender
          ],
      diets: (json['diets'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DietEnumMap, e))
              .toList() ??
          const [],
      cuisines: (json['cuisines'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CuisineEnumMap, e))
              .toList() ??
          const [
            Cuisine.american,
            Cuisine.mexican,
            Cuisine.spanish,
            Cuisine.japanese,
            Cuisine.thai,
            Cuisine.chinese,
            Cuisine.korean,
            Cuisine.german,
            Cuisine.italian,
            Cuisine.french,
            Cuisine.indian,
            Cuisine.caribbean
          ],
      adoreIngredients: (json['adore_ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      abhorIngredients: (json['abhor_ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'updated_at': instance.updatedAt,
      'name': instance.name,
      'handle': instance.handle,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'experience': _$ExperienceEnumMap[instance.experience],
      'allergies': instance.allergies.map((e) => _$AllergyEnumMap[e]).toList(),
      'appliances':
          instance.appliances.map((e) => _$ApplianceEnumMap[e]).toList(),
      'diets': instance.diets.map((e) => _$DietEnumMap[e]).toList(),
      'cuisines': instance.cuisines.map((e) => _$CuisineEnumMap[e]).toList(),
      'adore_ingredients': instance.adoreIngredients,
      'abhor_ingredients': instance.abhorIngredients,
      'followers': instance.followers,
      'following': instance.following,
    };

const _$ExperienceEnumMap = {
  Experience.novice: 'novice',
  Experience.dabbler: 'dabbler',
  Experience.cook: 'cook',
  Experience.chef: 'chef',
};

const _$AllergyEnumMap = {
  Allergy.wheat: 'wheat',
  Allergy.soy: 'soy',
  Allergy.dairy: 'dairy',
  Allergy.eggs: 'eggs',
  Allergy.shellfish: 'shellfish',
  Allergy.peanuts: 'peanuts',
  Allergy.treeNuts: 'treeNuts',
  Allergy.sesame: 'sesame',
};

const _$ApplianceEnumMap = {
  Appliance.oven: 'oven',
  Appliance.stovetop: 'stovetop',
  Appliance.airFryer: 'airFryer',
  Appliance.instantPot: 'instantPot',
  Appliance.blender: 'blender',
};

const _$DietEnumMap = {
  Diet.paleo: 'paleo',
  Diet.keto: 'keto',
  Diet.vegetarian: 'vegetarian',
  Diet.vegan: 'vegan',
  Diet.omnivore: 'omnivore',
};

const _$CuisineEnumMap = {
  Cuisine.american: 'american',
  Cuisine.mexican: 'mexican',
  Cuisine.spanish: 'spanish',
  Cuisine.japanese: 'japanese',
  Cuisine.thai: 'thai',
  Cuisine.chinese: 'chinese',
  Cuisine.korean: 'korean',
  Cuisine.german: 'german',
  Cuisine.italian: 'italian',
  Cuisine.french: 'french',
  Cuisine.indian: 'indian',
  Cuisine.caribbean: 'caribbean',
};
