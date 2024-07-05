import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

typedef FolderTitleResult = Either<ValueFailure<String>, String>;

class FolderTitle extends ValueObject<String> {
  @override
  final FolderTitleResult value;

  factory FolderTitle(String input) {
    final finalInput = input.trim();
    return FolderTitle._(validateNotEmpty(finalInput));
  }

  /// Creates a new `IFolderTitle` object with the specified value.
  const FolderTitle._(this.value);
}
