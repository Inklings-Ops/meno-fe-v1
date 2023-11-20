import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';

@freezed
class Participant with _$Participant {
  const factory Participant({
    required String id,
    required String fullName,
    String? imageUrl,
    @Default(false) bool isCreator,
    @Default(false) bool isCohost,
  }) = _Participant;

  factory Participant.empty() => const Participant(id: '', fullName: '');
}
