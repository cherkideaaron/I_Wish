/// Environment configuration.
///
/// Override the base URL at build time using --dart-define:
///   flutter run --dart-define=BASE_URL=https://api.myapp.com
///   flutter build apk --dart-define=BASE_URL=https://api.myapp.com --dart-define=PRODUCTION=true
///
/// During development the default points to localhost:
///   - Android emulator  → http://10.0.2.2:8000
///   - iOS simulator     → http://127.0.0.1:8000
///   - Physical device   → replace with your machine's LAN IP
class Env {
  Env._();

  /// Base API URL (no trailing slash).
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000', // Default local Android emulator
  );

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://bnfyxqqluzgjgmtmjjri.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuZnl4cXFsdXpnamdtdG1qanJpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM1NzY4NjYsImV4cCI6MjA5OTE1Mjg2Nn0.Pd8TbkxX1p_-G17NuqIARX7b4Iz6oScVnzgOvZKulpc',
  );

  // Example of a boolean flag
  /// True only in production builds.
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');

  /// Verbose Dio logs are shown when NOT in production.
  static bool get enableLogs => !isProduction;
}
