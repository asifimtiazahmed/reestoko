release_android:
	@echo "Cleaning project..."
	@flutter clean
	@echo "Fetching dependencies... "
	@flutter pub get
	@echo "Bumping up build number"
	@dart scripts/bump_version.dart
	@echo "Building Dependencies..."
#	@dart run build_runner build --delete-conflicting-outputs
	@echo Building the app bundle
	@flutter build appbundle

update_build_number:
	@echo "Bumping up build number and launching app"
	@dart scripts/bump_version.dart
# Don't need to run this code as we will only use this to update build number
# @flutter run lib/main.dart

