import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

/// Represents an avatar of a Meno user
class Avatar extends ValueObject<File?> {

  /// Creates a new `IAvatar` object.
  factory Avatar(File? input) {
    return Avatar._(right(input));
  }

  /// Creates a new `IAvatar` object with the specified value.
  const Avatar._(this.value);
  /// The avatar, validated or not.
  @override
  final Either<ValueFailure<File?>, File?> value;
}
