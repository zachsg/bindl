# bodai
Bodai mobile meal-planning app.

## Screenshots
![image 13-2](https://github.com/user-attachments/assets/2288ec5d-d25c-414b-8182-a49188ff950c)

## Dev

## Building

Android: build app bundle:
- `flutter build appbundle`

iOS:
1. Open XCWorkspace file in ios/ directory in Xcode
2. Set build target to `Any iOS device (arm64)
3. Product > Archive
4. Go through distribution flow once built to send to Appstore Connect

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
