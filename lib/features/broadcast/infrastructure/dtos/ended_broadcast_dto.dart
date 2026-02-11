import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/dtos/broadcast_dto.dart';

final class EndedBroadcastDto with EquatableMixin {
  const EndedBroadcastDto({required this.details, required this.reason});

  factory EndedBroadcastDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid EndedBroadcastDto format');
    }

    return EndedBroadcastDto(
      details: BroadcastDto.fromJson(json[_kDetails]),
      reason: EndedBroadcastReasonDto.fromJson(json[_kReason]),
    );
  }

  static const String _kDetails = 'broadcastDetails';
  static const String _kReason = 'reason';

  Map<String, dynamic> toJson() => {
    _kDetails: details.toJson(),
    _kReason: reason.toJson(),
  };

  final BroadcastDto details;
  final EndedBroadcastReasonDto reason;

  @override
  List<Object?> get props => [details, reason];

  @override
  String toString() => 'EndedBroadcastDto(details: $details, reason: $reason)';
}

final class EndedBroadcastReasonDto with EquatableMixin {
  const EndedBroadcastReasonDto({required this.type, required this.message});

  factory EndedBroadcastReasonDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid EndedBroadcastReasonDto format');
    }

    return EndedBroadcastReasonDto(
      type: json[_kType] as String,
      message: json[_kMessage] as String,
    );
  }

  static const String _kType = 'type';
  static const String _kMessage = 'message';

  Map<String, dynamic> toJson() => {_kType: type, _kMessage: message};

  final String type;
  final String message;

  @override
  List<Object?> get props => [type, message];

  @override
  String toString() => 'EndedBroadcastReasonDto(type:$type, message: $message)';
}

extension EndedBroadcastDtoX on EndedBroadcastDto {
  EndedBroadcast get toDomain {
    return EndedBroadcast(
      details: details.toDomain,
      reason: EndedBroadcastReason(type: reason.type, message: reason.message),
    );
  }
}

extension EndedBroadcastX on EndedBroadcast {
  EndedBroadcastDto get toDto {
    return EndedBroadcastDto(
      details: details.toDto,
      reason: EndedBroadcastReasonDto(
        type: reason.type,
        message: reason.message,
      ),
    );
  }
}
