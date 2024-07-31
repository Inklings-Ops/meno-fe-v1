import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SocketResponse<T> extends Equatable {
  const SocketResponse({this.data, this.error});

  factory SocketResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$SocketResponseFromJson<T>(json, fromJsonT);

  final T? data;
  final String? error;

  @override 
  List<Object?> get props => [data, error];
}
