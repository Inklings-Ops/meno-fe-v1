import 'package:meno/shared/domain/value_objects/id.dart';

final class AssignResult {
  const AssignResult({required this.succeededIds, required this.failedIds});

  final List<Id> succeededIds;
  final List<Id> failedIds;

  static const empty = AssignResult(succeededIds: [], failedIds: []);

  bool get hasFailures => failedIds.isNotEmpty;

  bool get allSucceeded => failedIds.isEmpty;
}
