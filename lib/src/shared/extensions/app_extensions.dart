import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

extension AppX on BuildContext {
  String? validator(Either<ValueFailure<String?>, String?> value) {
    return value.fold(
      (exception) => exception.maybeWhen(
        orElse: () => MErrorMessages.unknownError,
        empty: () => MErrorMessages.emptyError,
        invalidEmail: () => MErrorMessages.invalidEmail,
        invalidPassword: (_) => MErrorMessages.invalidPwd,
      ),
      (_) => null,
    );
  }
}
