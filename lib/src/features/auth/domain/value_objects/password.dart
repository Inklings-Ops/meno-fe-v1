// ignore_for_file: unnecessary_raw_strings

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:meno_fe_v1/src/core/exceptions/value_exception.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

/// Enum to distinguish between sign-in and sign-up modes
enum PasswordMode { signIn, signUp }

/// Enum representing password validation errors (for UI tracker)
enum PasswordValidationError {
  tooShort,
  missingUppercase,
  missingLowercase,
  missingNumber,
  missingSpecialCharacter,
}

class Password extends ValueObject<String> {
  /// Factory constructor: Validates eagerly and creates the instance.
  factory Password(String input, [PasswordMode mode = PasswordMode.signIn]) {
    final sanitizedInput = input.trim();

    // Perform validation using the static method
    final validationResult = _validatePassword(sanitizedInput, mode: mode);
    // Create instance via private constructor, passing result, original input,
    // and mode
    return Password._(validationResult, mode);
  }

  const Password._(super.value, this.mode);

  /// The mode (signIn or signUp) affects validation rules.
  final PasswordMode mode;

  /// Default class for use with Sign In form
  static Password emptySignIn = Password('');

  /// Default class for use with Sign Up form
  static Password emptySignUp = Password('', PasswordMode.signUp);

  static Either<ValueException<String>, String> _validatePassword(
    String input, {
    required PasswordMode mode,
  }) {
    if (mode == PasswordMode.signIn) {
      if (input.isEmpty) return const Left(PasswordTooShort());

      return Right(input);
    } else {
      if (input.isEmpty) return const Left(PasswordTooShort());

      if (input.length < 8) return const Left(PasswordTooShort());

      if (!RegExp(r'(?=.*[A-Z])').hasMatch(input)) {
        return const Left(PasswordMissingUppercase());
      }

      if (!RegExp(r'(?=.*[a-z])').hasMatch(input)) {
        return const Left(PasswordMissingLowercase());
      }

      if (!RegExp(r'(?=.*[0-9])').hasMatch(input)) {
        return const Left(PasswordMissingNumber());
      }

      if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(input)) {
        return const Left(PasswordMissingSpecialCharacter());
      }

      return Right(input);
    }
  }
}

extension PasswordValidationErrorX on ValueException<String> {
  String? get title {
    switch (this) {
      case PasswordMissingLowercase():
        return 'a';
      case PasswordMissingNumber():
        return '123';
      case PasswordMissingSpecialCharacter():
        return '%';
      case PasswordMissingUppercase():
        return 'A';
      case PasswordTooShort():
        return '8+';
      default:
        return null;
    }
  }

  String? get subtitle {
    switch (this) {
      case PasswordMissingLowercase():
        return 'Lowercase';
      case PasswordMissingNumber():
        return 'Number';
      case PasswordMissingSpecialCharacter():
        return 'Symbol';
      case PasswordMissingUppercase():
        return 'Uppercase';
      case PasswordTooShort():
        return 'Characters';
      default:
        return null;
    }
  }
}
