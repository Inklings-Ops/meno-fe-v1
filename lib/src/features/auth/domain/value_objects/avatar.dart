import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

/// Represents an avatar of a Meno user
class Avatar extends ValueObject<File?> {
  /// The avatar, validated or not.
  @override
  final Either<ValueFailure<File?>, File?> value;

  /// Creates a new `IAvatar` object.
  factory Avatar(File? input) {
    return Avatar._(right(input));
  }

  /// Creates a new `IAvatar` object with the specified value.
  const Avatar._(this.value);
}
