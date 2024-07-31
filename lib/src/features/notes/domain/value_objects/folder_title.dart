import 'package:dartz/dartz.dart';

import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

typedef FolderTitleResult = Either<ValueFailure<String>, String>;

class FolderTitle extends ValueObject<String> {

  factory FolderTitle(String input) {
    final finalInput = input.trim();
    return FolderTitle._(validateStringNotEmpty(finalInput));
  }

  /// Creates a new `IFolderTitle` object with the specified value.
  const FolderTitle._(this.value);
  @override
  final FolderTitleResult value;
}
