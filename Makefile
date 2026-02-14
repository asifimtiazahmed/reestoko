release_android:
	@echo "Cleaning project..."
	@flutter clean
	@echo "Fetching dependencies... "
	@flutter pub get
	@echo "Bumping up build number"
# below the single $ has been changed to $$ for make file, this is the original 	@perl -i -p -e 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$/$1.($2+1).$3.($4+1)/e' ./pubspec.yaml
	@perl -i -p -e 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$$/$$1.($$2+1).$$3.($$4+1)/e' ./pubspec.yaml
	@echo "Building Dependencies..."
#	@dart run build_runner build --delete-conflicting-outputs
	@echo Building the app bundle
	@flutter build appbundle

update_build_number:
	@echo "Bumping up build number and launching app"
# below the single $ has been changed to $$ for make file, this is the original 	@perl -i -p -e 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$/$1.($2+1).$3.($4+1)/e' ./pubspec.yaml
	@perl -i -p -e 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$$/$$1.($$2+1).$$3.($$4+1)/e' ./pubspec.yaml
# Don't need to run this code as we will only use this to update build number
# @flutter run lib/main.dart

