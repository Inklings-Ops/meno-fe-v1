import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

/// Represents a broadcast description for a Meno broadcast
class BroadcastArtwork extends ValueObject<File?> {

  /// Creates a new `IBroadcastArtwork` object.
  factory BroadcastArtwork(File? input) {
    return BroadcastArtwork._(right(input));
  }

  /// Creates a new `IBroadcastArtwork` object with the specified value.
  const BroadcastArtwork._(this.value);
  @override
  final Either<ValueFailure<File?>, File?> value;
}
