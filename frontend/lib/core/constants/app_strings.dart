/// All user-visible strings in one place.
/// Never hard-code strings inside widgets — reference this class.
class AppStrings {
  AppStrings._();

  static const String appName = 'I Wish';

  // ─── Splash ────────────────────────────────────────
  static const String tagline = 'Make every wish count';

  // ─── Auth — General ────────────────────────────────
  static const String emailLabel = 'Email';
  static const String emailHint = 'you@example.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = '••••••••';
  static const String nameLabel = 'Full name';
  static const String nameHint = 'Jane Doe';
  static const String confirmPasswordLabel = 'Confirm password';
  static const String confirmPasswordHint = '••••••••';

  // ─── Login ─────────────────────────────────────────
  static const String loginTitle = 'Welcome back';
  static const String loginSubtitle = 'Sign in to continue';
  static const String loginButton = 'Sign In';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUpLink = 'Sign Up';

  // ─── Register ──────────────────────────────────────
  static const String registerTitle = 'Create an account';
  static const String registerSubtitle = 'Join us today — it\'s free';
  static const String registerButton = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signInLink = 'Sign In';

  // ─── Home ──────────────────────────────────────────
  static const String homeTitle = 'Home';
  static const String welcomePrefix = 'Welcome, ';
  static const String logoutButton = 'Sign Out';

  // ─── Errors ────────────────────────────────────────
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection.';
  static const String unauthorizedError = 'Invalid email or password.';
  static const String retry = 'Retry';

  // ─── Steps (Stepper variant) ───────────────────────
  static const String stepPersonalInfo = 'Personal Info';
  static const String stepSecurity = 'Security';
  static const String nextButton = 'Next';
  static const String backButton = 'Back';
}
