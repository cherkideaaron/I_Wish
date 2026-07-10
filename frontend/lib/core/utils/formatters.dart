import 'package:flutter/services.dart';

/// Reusable [TextInputFormatter] instances.
///
/// Usage:
///   TextFormField(inputFormatters: [AppFormatters.noLeadingSpaces])
class AppFormatters {
  AppFormatters._();

  /// Prevents leading spaces — useful for name & email fields.
  static final TextInputFormatter noLeadingSpaces = _NoLeadingSpaceFormatter();

  /// Allows digits only (0-9).
  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.digitsOnly;

  /// Allows letters and spaces — useful for name fields.
  static final TextInputFormatter lettersAndSpaces =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

  /// Converts input to lowercase as the user types.
  static final TextInputFormatter lowercase = _LowercaseFormatter();
}

class _NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) return oldValue;
    return newValue;
  }
}

class _LowercaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toLowerCase());
}
