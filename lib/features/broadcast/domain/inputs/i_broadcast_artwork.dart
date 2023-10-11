import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/value_objects/value_objects.dart';

/// Represents a broadcast description for a Meno broadcast
class IBroadcastArtwork extends ValueObject<File?> {
  @override
  final Either<ValueFailure<File?>, File?> value;

  /// Creates a new `IBroadcastArtwork` object.
  factory IBroadcastArtwork(File? input) {
    return IBroadcastArtwork._(right(input));
  }

  /// Creates a new `IBroadcastArtwork` object with the specified value.
  const IBroadcastArtwork._(this.value);
}
