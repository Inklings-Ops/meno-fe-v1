import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/core/core.dart';

class Password extends ValueObject<String> {
  factory Password.login(String input) {
    const mode = PasswordMode.login;
    return Password._(_validate(input, mode), input, mode);
  }

  factory Password.register(String input) {
    const mode = PasswordMode.register;
    return Password._(_validate(input, mode), input, mode);
  }

  const Password._(super.value, this.input, this.mode);

  final String input;
  final PasswordMode mode;

  /// Returns ALL broken rules. Used specifically for the UI Tracker.
  List<ValueException<String>> get brokenRules => _collectBrokenRules(input);

  /// Helper to check if a specific rule is broken
  bool isRuleBroken(ValueException<String> rule) {
    // We compare runtime types because the instances might be different
    return brokenRules.any((r) => r.runtimeType == rule.runtimeType);
  }

  static const Password emptyLogin = Password._(
    Left(RequiredValueException()),
    '',
    PasswordMode.login,
  );

  static const Password emptyRegister = Password._(
    Left(RequiredValueException()),
    '',
    PasswordMode.register,
  );

  static Either<ValueException<String>, String> _validate(
    String input,
    PasswordMode mode,
  ) {
    if (input.isEmpty) return const Left(RequiredValueException());

    // For SignIn, we are lenient (server handles checks).
    // For SignUp, we enforce strict rules.
    if (mode == PasswordMode.register) {
      final rules = _collectBrokenRules(input);
      if (rules.isNotEmpty) {
        // Return the first rule as the "Primary" failure for the Either
        return Left(rules.first);
      }
    }
    return Right(input);
  }

  static List<ValueException<String>> _collectBrokenRules(String input) {
    // If empty, we don't return "broken rules" yet, we treat it as "untouched"
    // so the UI stays neutral color.
    if (input.isEmpty) return [];

    final errors = <ValueException<String>>[];

    if (input.length < 8) {
      errors.add(const PasswordTooShort());
    }

    if (!RegExp('[A-Z]').hasMatch(input)) {
      errors.add(const PasswordMissingUppercase());
    }

    if (!RegExp('[a-z]').hasMatch(input)) {
      errors.add(const PasswordMissingLowercase());
    }

    if (!RegExp('[0-9]').hasMatch(input)) {
      errors.add(const PasswordMissingNumber());
    }

    if (!RegExp(r'[@$!%*?&_]').hasMatch(input)) {
      errors.add(const PasswordMissingSpecialCharacter());
    }

    return errors;
  }
}

/// Enum to distinguish between sign-in and sign-up modes
enum PasswordMode { login, register }
