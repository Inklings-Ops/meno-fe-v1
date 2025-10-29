import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno_domain/meno_domain.dart';

/// Password Value Object
final class Password extends ValueObject<String> {
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

      if (!RegExp('(?=.*[A-Z])').hasMatch(input)) {
        return const Left(PasswordMissingUppercase());
      }

      if (!RegExp('(?=.*[a-z])').hasMatch(input)) {
        return const Left(PasswordMissingLowercase());
      }

      if (!RegExp('(?=.*[0-9])').hasMatch(input)) {
        return const Left(PasswordMissingNumber());
      }

      if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(input)) {
        return const Left(PasswordMissingSpecialCharacter());
      }

      return Right(input);
    }
  }
}

/// Enum to distinguish between sign-in and sign-up modes
enum PasswordMode {
  /// For sign-in mode
  signIn,

  /// For sign-up mode
  signUp,
}

/// Enum representing password validation errors (for UI tracker)
enum PasswordValidationError {
  /// The password is less than 8 characters
  tooShort,

  /// The password does not have an uppercase letter in it
  missingUppercase,

  /// The password does not have a lowercase letter in it
  missingLowercase,

  /// The password does not have a digit in it
  missingNumber,

  /// The password does not have a special character in it [@$!%*?&]
  missingSpecialCharacter,
}

/// Extension for PasswordValidationError
extension PasswordValidationErrorX on ValueException<String> {
  /// Getter for the title of the error
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

  /// Getter for the subtitle of the error
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
