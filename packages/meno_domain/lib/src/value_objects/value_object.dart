import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno_domain/meno_domain.dart' show ValueException;

/// Represents a Value Object in Domain-Driven Design.
///
/// A Value Object is an immutable object distinguished by the value of its
/// properties. Two Value Objects are equal if their properties are equal.
@immutable
abstract class ValueObject<T> with EquatableMixin {
  /// Base constructor takes the pre-validated Either result.
  /// Can be const, allowing subclasses to define const constructors.
  const ValueObject(this.value);

  /// The core state: the result of validation, stored immutably.
  final Either<ValueException<T>, T> value;

  /// Returns `true` if the validation was successful (result is Right).
  bool get isValid => value.isRight();

  /// Returns the validated value if successful (isRight), otherwise throws
  /// the [ValueException].
  T getOrCrash() => value.fold((e) => throw e, (validValue) => validValue);

  /// Returns the validated value if successful (isRight), otherwise
  /// returns the result of [orElse].
  T getOrElse(T Function(ValueException<T>) orElse) => value.getOrElse(orElse);

  /// Returns the validated value if successful (isRight), otherwise
  /// returns null.
  T? getOrNull() => value.fold((_) => null, (validValue) => validValue);

  /// Returns the failure object [ValueException] if validation failed
  /// (isLeft), otherwise null.
  ValueException<T>? get exceptionOrNull => value.fold((e) => e, (_) => null);

  /// Allows pattern matching or handling both success (Right) and
  /// failure (Left) cases directly.
  B fold<B>(
    B Function(ValueException<T> failure) ifError,
    B Function(T value) ifSuccess,
  ) => value.fold(ifError, ifSuccess);

  @override
  List<Object?> get props => [value];

  @override
  bool? get stringify => true;
}
