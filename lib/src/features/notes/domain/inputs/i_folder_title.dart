import 'package:dartz/dartz.dart';

import '../../../../shared/value_objects/value_objects.dart';

typedef IFolderTitleResult = Either<ValueFailure<String>, String>;

class IFolderTitle extends ValueObject<String> {
  @override
  final IFolderTitleResult value;

  factory IFolderTitle(String input) {
    final finalInput = input.trim();
    return IFolderTitle._(validateNotEmpty(finalInput));
  }

  /// Creates a new `IFolderTitle` object with the specified value.
  const IFolderTitle._(this.value);
}
