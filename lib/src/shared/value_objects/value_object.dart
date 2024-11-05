import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_error.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_failure.dart';

abstract class IValueObject {
  bool get isValid;
}

@immutable
abstract class ValueObject<T> implements IValueObject {
  const ValueObject();

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold(
      left,
      (r) => right(unit),
    );
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool get isValid => value.isRight();

  Either<ValueFailure<T>, T> get value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  /// Throws UnexpectedValueError containing the [ValueFailure]
  // ignore: only_throw_errors
  T getOr() => value.fold((f) => throw ValueError.unexpectedError(f), id);

  T getOrE(T dflt) => value.getOrElse(() => dflt);

  @override
  String toString() => 'Value($value)';
}
