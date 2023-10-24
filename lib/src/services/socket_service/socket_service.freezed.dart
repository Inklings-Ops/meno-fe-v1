// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SocketState {
  bool get isLive => throw _privateConstructorUsedError;
  Broadcast get liveBroadcast => throw _privateConstructorUsedError;
  List<Participant?> get participants => throw _privateConstructorUsedError;
  List<Broadcast?> get liveBroadcasts => throw _privateConstructorUsedError;
  Participant? get newParticipant => throw _privateConstructorUsedError;
  int? get numberOfParticipants => throw _privateConstructorUsedError;
  int? get numberOfLiveBroadcasts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SocketStateCopyWith<SocketState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocketStateCopyWith<$Res> {
  factory $SocketStateCopyWith(
          SocketState value, $Res Function(SocketState) then) =
      _$SocketStateCopyWithImpl<$Res, SocketState>;
  @useResult
  $Res call(
      {bool isLive,
      Broadcast liveBroadcast,
      List<Participant?> participants,
      List<Broadcast?> liveBroadcasts,
      Participant? newParticipant,
      int? numberOfParticipants,
      int? numberOfLiveBroadcasts});

  $BroadcastCopyWith<$Res> get liveBroadcast;
  $ParticipantCopyWith<$Res>? get newParticipant;
}

/// @nodoc
class _$SocketStateCopyWithImpl<$Res, $Val extends SocketState>
    implements $SocketStateCopyWith<$Res> {
  _$SocketStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLive = null,
    Object? liveBroadcast = null,
    Object? participants = null,
    Object? liveBroadcasts = null,
    Object? newParticipant = freezed,
    Object? numberOfParticipants = freezed,
    Object? numberOfLiveBroadcasts = freezed,
  }) {
    return _then(_value.copyWith(
      isLive: null == isLive
          ? _value.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
      liveBroadcast: null == liveBroadcast
          ? _value.liveBroadcast
          : liveBroadcast // ignore: cast_nullable_to_non_nullable
              as Broadcast,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<Participant?>,
      liveBroadcasts: null == liveBroadcasts
          ? _value.liveBroadcasts
          : liveBroadcasts // ignore: cast_nullable_to_non_nullable
              as List<Broadcast?>,
      newParticipant: freezed == newParticipant
          ? _value.newParticipant
          : newParticipant // ignore: cast_nullable_to_non_nullable
              as Participant?,
      numberOfParticipants: freezed == numberOfParticipants
          ? _value.numberOfParticipants
          : numberOfParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfLiveBroadcasts: freezed == numberOfLiveBroadcasts
          ? _value.numberOfLiveBroadcasts
          : numberOfLiveBroadcasts // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BroadcastCopyWith<$Res> get liveBroadcast {
    return $BroadcastCopyWith<$Res>(_value.liveBroadcast, (value) {
      return _then(_value.copyWith(liveBroadcast: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ParticipantCopyWith<$Res>? get newParticipant {
    if (_value.newParticipant == null) {
      return null;
    }

    return $ParticipantCopyWith<$Res>(_value.newParticipant!, (value) {
      return _then(_value.copyWith(newParticipant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SocketStateCopyWith<$Res>
    implements $SocketStateCopyWith<$Res> {
  factory _$$_SocketStateCopyWith(
          _$_SocketState value, $Res Function(_$_SocketState) then) =
      __$$_SocketStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLive,
      Broadcast liveBroadcast,
      List<Participant?> participants,
      List<Broadcast?> liveBroadcasts,
      Participant? newParticipant,
      int? numberOfParticipants,
      int? numberOfLiveBroadcasts});

  @override
  $BroadcastCopyWith<$Res> get liveBroadcast;
  @override
  $ParticipantCopyWith<$Res>? get newParticipant;
}

/// @nodoc
class __$$_SocketStateCopyWithImpl<$Res>
    extends _$SocketStateCopyWithImpl<$Res, _$_SocketState>
    implements _$$_SocketStateCopyWith<$Res> {
  __$$_SocketStateCopyWithImpl(
      _$_SocketState _value, $Res Function(_$_SocketState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLive = null,
    Object? liveBroadcast = null,
    Object? participants = null,
    Object? liveBroadcasts = null,
    Object? newParticipant = freezed,
    Object? numberOfParticipants = freezed,
    Object? numberOfLiveBroadcasts = freezed,
  }) {
    return _then(_$_SocketState(
      isLive: null == isLive
          ? _value.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
      liveBroadcast: null == liveBroadcast
          ? _value.liveBroadcast
          : liveBroadcast // ignore: cast_nullable_to_non_nullable
              as Broadcast,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<Participant?>,
      liveBroadcasts: null == liveBroadcasts
          ? _value._liveBroadcasts
          : liveBroadcasts // ignore: cast_nullable_to_non_nullable
              as List<Broadcast?>,
      newParticipant: freezed == newParticipant
          ? _value.newParticipant
          : newParticipant // ignore: cast_nullable_to_non_nullable
              as Participant?,
      numberOfParticipants: freezed == numberOfParticipants
          ? _value.numberOfParticipants
          : numberOfParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfLiveBroadcasts: freezed == numberOfLiveBroadcasts
          ? _value.numberOfLiveBroadcasts
          : numberOfLiveBroadcasts // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$_SocketState with DiagnosticableTreeMixin implements _SocketState {
  _$_SocketState(
      {required this.isLive,
      required this.liveBroadcast,
      required final List<Participant?> participants,
      required final List<Broadcast?> liveBroadcasts,
      this.newParticipant,
      this.numberOfParticipants,
      this.numberOfLiveBroadcasts})
      : _participants = participants,
        _liveBroadcasts = liveBroadcasts;

  @override
  final bool isLive;
  @override
  final Broadcast liveBroadcast;
  final List<Participant?> _participants;
  @override
  List<Participant?> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  final List<Broadcast?> _liveBroadcasts;
  @override
  List<Broadcast?> get liveBroadcasts {
    if (_liveBroadcasts is EqualUnmodifiableListView) return _liveBroadcasts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_liveBroadcasts);
  }

  @override
  final Participant? newParticipant;
  @override
  final int? numberOfParticipants;
  @override
  final int? numberOfLiveBroadcasts;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SocketState(isLive: $isLive, liveBroadcast: $liveBroadcast, participants: $participants, liveBroadcasts: $liveBroadcasts, newParticipant: $newParticipant, numberOfParticipants: $numberOfParticipants, numberOfLiveBroadcasts: $numberOfLiveBroadcasts)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SocketState'))
      ..add(DiagnosticsProperty('isLive', isLive))
      ..add(DiagnosticsProperty('liveBroadcast', liveBroadcast))
      ..add(DiagnosticsProperty('participants', participants))
      ..add(DiagnosticsProperty('liveBroadcasts', liveBroadcasts))
      ..add(DiagnosticsProperty('newParticipant', newParticipant))
      ..add(DiagnosticsProperty('numberOfParticipants', numberOfParticipants))
      ..add(DiagnosticsProperty(
          'numberOfLiveBroadcasts', numberOfLiveBroadcasts));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SocketState &&
            (identical(other.isLive, isLive) || other.isLive == isLive) &&
            (identical(other.liveBroadcast, liveBroadcast) ||
                other.liveBroadcast == liveBroadcast) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            const DeepCollectionEquality()
                .equals(other._liveBroadcasts, _liveBroadcasts) &&
            (identical(other.newParticipant, newParticipant) ||
                other.newParticipant == newParticipant) &&
            (identical(other.numberOfParticipants, numberOfParticipants) ||
                other.numberOfParticipants == numberOfParticipants) &&
            (identical(other.numberOfLiveBroadcasts, numberOfLiveBroadcasts) ||
                other.numberOfLiveBroadcasts == numberOfLiveBroadcasts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLive,
      liveBroadcast,
      const DeepCollectionEquality().hash(_participants),
      const DeepCollectionEquality().hash(_liveBroadcasts),
      newParticipant,
      numberOfParticipants,
      numberOfLiveBroadcasts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SocketStateCopyWith<_$_SocketState> get copyWith =>
      __$$_SocketStateCopyWithImpl<_$_SocketState>(this, _$identity);
}

abstract class _SocketState implements SocketState {
  factory _SocketState(
      {required final bool isLive,
      required final Broadcast liveBroadcast,
      required final List<Participant?> participants,
      required final List<Broadcast?> liveBroadcasts,
      final Participant? newParticipant,
      final int? numberOfParticipants,
      final int? numberOfLiveBroadcasts}) = _$_SocketState;

  @override
  bool get isLive;
  @override
  Broadcast get liveBroadcast;
  @override
  List<Participant?> get participants;
  @override
  List<Broadcast?> get liveBroadcasts;
  @override
  Participant? get newParticipant;
  @override
  int? get numberOfParticipants;
  @override
  int? get numberOfLiveBroadcasts;
  @override
  @JsonKey(ignore: true)
  _$$_SocketStateCopyWith<_$_SocketState> get copyWith =>
      throw _privateConstructorUsedError;
}
