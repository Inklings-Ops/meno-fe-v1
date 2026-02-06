import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/core/domain/value_objects/value_objects.dart';

class Password extends ValueObject<String> {
  factory Password.signIn(String input) {
    const mode = PasswordMode.signIn;
    return Password._(_validate(input, mode), input, mode);
  }

  factory Password.signUp(String input) {
    const mode = PasswordMode.signUp;
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

  static const Password emptySignIn = Password._(
    Left(RequiredValueException()),
    '',
    PasswordMode.signIn,
  );

  static const Password emptySignUp = Password._(
    Left(RequiredValueException()),
    '',
    PasswordMode.signUp,
  );

  static Either<ValueException<String>, String> _validate(
    String input,
    PasswordMode mode,
  ) {
    if (input.isEmpty) return const Left(RequiredValueException());

    // For SignIn, we are lenient (server handles checks).
    // For SignUp, we enforce strict rules.
    if (mode == PasswordMode.signUp) {
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
enum PasswordMode { signIn, signUp }
