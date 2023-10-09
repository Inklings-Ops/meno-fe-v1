import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as p;

import 'value_failure.dart';

typedef ValidationResult = Either<ValueFailure<String>, String>;
typedef ValidationResultNullable = Either<ValueFailure<String?>, String?>;

ValidationResult validateBioLength(String input) {
  if (input.length > 250) {
    return left(ValueFailure.bioLengthExceeded(input));
  } else {
    return right(input);
  }
}

ValidationResult validateEmail(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(input));
  } else {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
    if (RegExp(emailRegex).hasMatch(input)) {
      return right(input);
    } else {
      return left(ValueFailure.invalidEmail(input));
    }
  }
}

ValidationResult validateNotEmpty(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(input));
  } else {
    return right(input);
  }
}

ValidationResult validatePassword(String input) {
  // Must contain at least 8 characters
  // Must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number
  // Must contain a special character
  if (input.isEmpty) {
    return left(ValueFailure.empty(input));
  } else {
    const pRegEx =
        r"""^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*[@$!%*?&]).{8,}$""";
    if (RegExp(pRegEx).hasMatch(input)) {
      return right(input);
    } else {
      return left(ValueFailure.invalidPassword(input));
    }
  }
}

ValidationResultNullable validateBroadcastDescription(String? input) {
  if (input == null) {
    return right(null);
  }

  if (input.length > 244) {
    return left(ValueFailure.descLengthExceeded(input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<File?>, File?> validateImage(File? input) {
  if (input == null) {
    return right(null);
  }

  final allowedExtensions = ['.png', '.jpeg', '.jpg'];
  final fileExtension = p.extension(input.path).toLowerCase();

  if (!allowedExtensions.contains(fileExtension)) {
    return left(ValueFailure.invalidImageType(input));
  } else {
    return right(input);
  }
}
