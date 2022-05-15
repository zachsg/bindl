# bodai
Bodai mobile meal-planning app.

## Dev

## Building

### Code generation
When updating models (anything using `freezed` or `json_serializable`), run the following:
- `flutter pub run build_runner build --delete-conflicting-outputs`

If that command fails with obscure errors like `Unable to generate package graph`, run the following:
1. `flutter clean`
2. `flutter packages pub get`
3. `flutter pub run build_runner build --delete-conflicting-outputs`

Re-build native splash screen:
1. `flutter pub run flutter_native_splash:remove`
2. `flutter pub run flutter_native_splash:create`