import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/src/_shared/models/value_objects/value_exception.dart';

abstract class IValueObject {
  bool get isValid;
}

@immutable
abstract class ValueObject<T> with EquatableMixin implements IValueObject {
  /// Base constructor takes the pre-validated Either result.
  const ValueObject(this.value);

  /// The core state: the result of validation, stored immutably.
  final Either<ValueException<T>, T> value;

  @override
  bool get isValid => value.isRight();

  T getOrCrash() => value.fold((failure) => throw failure, (validV) => validV);

  T getOrElse(T Function(ValueException<T>) dflt) => value.getOrElse(dflt);

  T? getOrNull() => value.fold((_) => null, (validV) => validV);

  ValueException<T>? get failureOrNull => value.fold((f) => f, (_) => null);

  B fold<B>(
    B Function(ValueException<T> failure) ifLeft,
    B Function(T value) ifRight,
  ) => value.fold(ifLeft, ifRight);

  T? get validInputOrNull => value.fold((_) => null, (validV) => validV);

  @override
  List<Object?> get props => [value];

  @override
  bool? get stringify => true;
}
