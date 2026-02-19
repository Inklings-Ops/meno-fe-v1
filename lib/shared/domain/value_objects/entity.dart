import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

/// An abstract class representing an entity.
///
/// It uses the [EquatableMixin] to enforce equality checks based solely
/// on the entity's [id].
abstract class IEntity with EquatableMixin {
  /// The unique identifier for the entity.
  Id get id;

  /// Overrides the props from [EquatableMixin] to ensure equality
  /// is determined *only* by the [id] field.
  @override
  List<Object?> get props => [id];
}
