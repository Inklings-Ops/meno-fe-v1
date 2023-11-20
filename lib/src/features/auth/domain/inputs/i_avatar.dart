import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

/// A typedef representing the result of validating an avatar.
typedef IAvatarResult = Either<ValueFailure<File?>, File?>;

/// Represents an avatar of a Meno user
class IAvatar extends ValueObject<File?> {
  /// The avatar, validated or not.
  @override
  final IAvatarResult value;

  /// Creates a new `IAvatar` object.
  factory IAvatar(File? input) {
    return IAvatar._(right(input));
  }

  /// Creates a new `IAvatar` object with the specified value.
  const IAvatar._(this.value);
}
