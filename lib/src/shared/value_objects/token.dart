import 'package:dartz/dartz.dart';

import 'value_objects.dart';

class Token extends ValueObject<String?> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Token(String input) => Token._(validateTokenExpired(input));

  const Token._(this.value);

  /// Returns `true` if the token has not expired
  bool get isActive => value.isRight();
}
