import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/shared/value_objects/id.dart';

/// An abstract class representing a Domain-Driven Design Entity.
///
/// It uses the [EquatableMixin] to enforce equality checks based solely
/// on the entity's [id], which is the core principle of entity identity in DDD.
abstract class IEntity with EquatableMixin {
  /// The unique identifier for the entity.
  ID get id;

  /// Overrides the props from [EquatableMixin] to ensure equality
  /// is determined *only* by the [id] field.
  @override
  List<Object?> get props => [id];
}
