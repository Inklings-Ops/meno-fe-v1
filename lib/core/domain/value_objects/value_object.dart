import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/domain/value_objects/value_objects.dart';

abstract class IValueObject {
  bool get isValid;
}

@immutable
abstract class ValueObject<T> with EquatableMixin implements IValueObject {
  /// Base constructor takes the pre-validated Either result.
  /// Can be const, allowing subclasses to define const constructors.
  const ValueObject(this.value);

  /// The core state: the result of validation, stored immutably.
  final Either<ValueException<T>, T> value;

  /// Returns `true` if the validation was successful (result is Right).
  @override
  bool get isValid => value.isRight();

  /// Returns the validated value if successful (isRight), otherwise throws
  /// the [ValueException].
  T getOrCrash() => value.fold((failure) => throw failure, (validV) => validV);

  /// Returns the validated value if successful (isRight), otherwise
  /// returns the result of [dflt].
  T getOrElse(T Function(ValueException<T>) dflt) => value.getOrElse(dflt);

  /// Returns the validated value if successful (isRight), otherwise
  /// returns null.
  T? getOrNull() => value.fold((_) => null, (validV) => validV);

  /// Returns the failure object [ValueException] if validation failed
  /// (isLeft), otherwise null.
  ValueException<T>? get failureOrNull => value.fold((f) => f, (_) => null);

  /// Allows pattern matching or handling both success (Right) and
  /// failure (Left) cases directly.
  B fold<B>(
    B Function(ValueException<T> failure) ifLeft,
    B Function(T value) ifRight,
  ) => value.fold(ifLeft, ifRight);

  /// Provides access to the original input *if* it was valid.
  /// Returns null otherwise.
  /// Note: Original input isn't stored directly in the base
  /// class state anymore, but can be retrieved from the Right side
  /// of the Either.
  T? get validInputOrNull => value.fold((_) => null, (validV) => validV);

  @override
  List<Object?> get props => [value];

  @override
  bool? get stringify => true;
}
