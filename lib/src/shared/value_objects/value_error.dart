import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_failure.dart';

part 'value_error.freezed.dart';

@freezed
class ValueError with _$ValueError {
  const factory ValueError.unauthenticated() = _UnauthenticatedError;
  const factory ValueError.unexpectedError(ValueFailure<dynamic> failure) =
      _UnexpectedValueError;

  @override
  String toString() {
    return when(
      unauthenticated: () => 'This user is not authenticated',
      unexpectedError: (failure) {
        const message = 'Encountered an unexpected ValueFailure. Terminating.';
        return Error.safeToString('$message Failure was: $failure');
      },
    );
  }
}
