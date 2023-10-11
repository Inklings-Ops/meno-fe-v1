import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_creator.freezed.dart';

@freezed
class BroadcastCreator with _$BroadcastCreator {
  const factory BroadcastCreator({
    required String id,
    required String fullName,
    String? imageUrl,
  }) = _BroadcastCreator;

  factory BroadcastCreator.empty() =>
      const BroadcastCreator(id: '', fullName: '');
}
