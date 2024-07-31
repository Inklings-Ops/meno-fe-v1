import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

class Token extends ValueObject<String?> {

  factory Token(String input) => Token._(validateTokenExpired(input));

  const Token._(this.value);
  @override
  final Either<ValueFailure<String>, String> value;

  /// Returns `true` if the token has not expired
  bool get isActive => value.isRight();
}
