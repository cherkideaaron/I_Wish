@echo off
setlocal enabledelayedexpansion

if not exist "lib" (
    echo ERROR: No "lib" folder found here.
    echo Run this from the root of your Flutter project ^(the folder containing pubspec.yaml^).
    exit /b 1
)

echo ===============================================
echo Adding new folder structure to existing project...
echo ===============================================
mkdir lib\config
mkdir lib\core\constants
mkdir lib\core\theme
mkdir lib\core\router
mkdir lib\core\network
mkdir lib\core\utils
mkdir lib\core\widgets
mkdir lib\data\models
mkdir lib\data\repositories
mkdir lib\data\providers
mkdir lib\features\splash\variants
mkdir lib\features\auth\login\variants
mkdir lib\features\auth\register\variants
mkdir lib\features\auth\providers
mkdir lib\features\home\providers
mkdir lib\shared\widgets\navigation\bottom_nav
mkdir lib\shared\widgets\navigation\drawer
mkdir lib\shared\widgets\cards
mkdir lib\shared\widgets\buttons
mkdir lib\shared\widgets\toasts

echo ===============================================
echo Creating new files (empty - paste starter code from guide)...
echo ===============================================

type nul > lib\app.dart

type nul > lib\config\env.dart

type nul > lib\core\constants\app_colors.dart
type nul > lib\core\constants\app_strings.dart
type nul > lib\core\constants\app_dimensions.dart
type nul > lib\core\constants\api_endpoints.dart

type nul > lib\core\theme\app_theme.dart
type nul > lib\core\theme\text_styles.dart

type nul > lib\core\router\app_router.dart
type nul > lib\core\router\route_names.dart

type nul > lib\core\network\api_client.dart
type nul > lib\core\network\api_exceptions.dart
type nul > lib\core\network\dio_provider.dart

type nul > lib\core\utils\validators.dart
type nul > lib\core\utils\extensions.dart
type nul > lib\core\utils\formatters.dart

type nul > lib\core\widgets\loading_indicator.dart
type nul > lib\core\widgets\error_view.dart

type nul > lib\data\models\user_model.dart
type nul > lib\data\repositories\auth_repository.dart
type nul > lib\data\providers\auth_repository_provider.dart

type nul > lib\features\splash\splash_screen.dart
type nul > lib\features\splash\variants\splash_fade_logo.dart

type nul > lib\features\auth\login\login_screen.dart
type nul > lib\features\auth\login\variants\login_classic.dart

type nul > lib\features\auth\register\register_screen.dart
type nul > lib\features\auth\register\variants\register_classic.dart

type nul > lib\features\auth\providers\auth_provider.dart

type nul > lib\features\home\home_screen.dart
type nul > lib\features\home\providers\home_provider.dart

type nul > lib\shared\widgets\navigation\bottom_nav\bottom_nav_v1.dart
type nul > lib\shared\widgets\navigation\drawer\drawer_v1.dart
type nul > lib\shared\widgets\cards\card_v1.dart
type nul > lib\shared\widgets\buttons\primary_button.dart
type nul > lib\shared\widgets\buttons\outline_button.dart
type nul > lib\shared\widgets\toasts\app_toast.dart

echo ===============================================
echo Adding packages (riverpod, go_router, dio)...
echo ===============================================
flutter pub add flutter_riverpod go_router dio

echo ===============================================
echo DONE.
echo NOTE: lib\main.dart was left untouched - update it
echo yourself with the starter code from the guide.
echo ===============================================
pause