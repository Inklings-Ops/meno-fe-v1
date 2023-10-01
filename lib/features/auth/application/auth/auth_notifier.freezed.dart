// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserCredentials credentials) loggedIn,
    required TResult Function() initial,
    required TResult Function() loggedOut,
    required TResult Function() partiallyLoggedOut,
    required TResult Function() unverified,
    required TResult Function() verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserCredentials credentials)? loggedIn,
    TResult? Function()? initial,
    TResult? Function()? loggedOut,
    TResult? Function()? partiallyLoggedOut,
    TResult? Function()? unverified,
    TResult? Function()? verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserCredentials credentials)? loggedIn,
    TResult Function()? initial,
    TResult Function()? loggedOut,
    TResult Function()? partiallyLoggedOut,
    TResult Function()? unverified,
    TResult Function()? verified,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoggedIn value) loggedIn,
    required TResult Function(_Initial value) initial,
    required TResult Function(_LoggedOut value) loggedOut,
    required TResult Function(_PartiallyLoggedOut value) partiallyLoggedOut,
    required TResult Function(_Unverified value) unverified,
    required TResult Function(_Verified value) verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoggedIn value)? loggedIn,
    TResult? Function(_Initial value)? initial,
    TResult? Function(_LoggedOut value)? loggedOut,
    TResult? Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult? Function(_Unverified value)? unverified,
    TResult? Function(_Verified value)? verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoggedIn value)? loggedIn,
    TResult Function(_Initial value)? initial,
    TResult Function(_LoggedOut value)? loggedOut,
    TResult Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult Function(_Unverified value)? unverified,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_LoggedInCopyWith<$Res> {
  factory _$$_LoggedInCopyWith(
          _$_LoggedIn value, $Res Function(_$_LoggedIn) then) =
      __$$_LoggedInCopyWithImpl<$Res>;
  @useResult
  $Res call({UserCredentials credentials});

  $UserCredentialsCopyWith<$Res> get credentials;
}

/// @nodoc
class __$$_LoggedInCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_LoggedIn>
    implements _$$_LoggedInCopyWith<$Res> {
  __$$_LoggedInCopyWithImpl(
      _$_LoggedIn _value, $Res Function(_$_LoggedIn) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? credentials = null,
  }) {
    return _then(_$_LoggedIn(
      null == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as UserCredentials,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCredentialsCopyWith<$Res> get credentials {
    return $UserCredentialsCopyWith<$Res>(_value.credentials, (value) {
      return _then(_value.copyWith(credentials: value));
    });
  }
}

/// @nodoc

class _$_LoggedIn implements _LoggedIn {
  const _$_LoggedIn(this.credentials);

  @override
  final UserCredentials credentials;

  @override
  String toString() {
    return 'AuthState.loggedIn(credentials: $credentials)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoggedIn &&
            (identical(other.credentials, credentials) ||
                other.credentials == credentials));
  }

  @override
  int get hashCode => Object.hash(runtimeType, credentials);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoggedInCopyWith<_$_LoggedIn> get copyWith =>
      __$$_LoggedInCopyWithImpl<_$_LoggedIn>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserCredentials credentials) loggedIn,
    required TResult Function() initial,
    required TResult Function() loggedOut,
    required TResult Function() partiallyLoggedOut,
    required TResult Function() unverified,
    required TResult Function() verified,
  }) {
    return loggedIn(credentials);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserCredentials credentials)? loggedIn,
    TResult? Function()? initial,
    TResult? Function()? loggedOut,
    TResult? Function()? partiallyLoggedOut,
    TResult? Function()? unverified,
    TResult? Function()? verified,
  }) {
    return loggedIn?.call(credentials);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserCredentials credentials)? loggedIn,
    TResult Function()? initial,
    TResult Function()? loggedOut,
    TResult Function()? partiallyLoggedOut,
    TResult Function()? unverified,
    TResult Function()? verified,
    required TResult orElse(),
  }) {
    if (loggedIn != null) {
      return loggedIn(credentials);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoggedIn value) loggedIn,
    required TResult Function(_Initial value) initial,
    required TResult Function(_LoggedOut value) loggedOut,
    required TResult Function(_PartiallyLoggedOut value) partiallyLoggedOut,
    required TResult Function(_Unverified value) unverified,
    required TResult Function(_Verified value) verified,
  }) {
    return loggedIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoggedIn value)? loggedIn,
    TResult? Function(_Initial value)? initial,
    TResult? Function(_LoggedOut value)? loggedOut,
    TResult? Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult? Function(_Unverified value)? unverified,
    TResult? Function(_Verified value)? verified,
  }) {
    return loggedIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoggedIn value)? loggedIn,
    TResult Function(_Initial value)? initial,
    TResult Function(_LoggedOut value)? loggedOut,
    TResult Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult Function(_Unverified value)? unverified,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (loggedIn != null) {
      return loggedIn(this);
    }
    return orElse();
  }
}

abstract class _LoggedIn implements AuthState {
  const factory _LoggedIn(final UserCredentials credentials) = _$_LoggedIn;

  UserCredentials get credentials;
  @JsonKey(ignore: true)
  _$$_LoggedInCopyWith<_$_LoggedIn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserCredentials credentials) loggedIn,
    required TResult Function() initial,
    required TResult Function() loggedOut,
    required TResult Function() partiallyLoggedOut,
    required TResult Function() unverified,
    required TResult Function() verified,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserCredentials credentials)? loggedIn,
    TResult? Function()? initial,
    TResult? Function()? loggedOut,
    TResult? Function()? partiallyLoggedOut,
    TResult? Function()? unverified,
    TResult? Function()? verified,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserCredentials credentials)? loggedIn,
    TResult Function()? initial,
    TResult Function()? loggedOut,
    TResult Function()? partiallyLoggedOut,
    TResult Function()? unverified,
    TResult Function()? verified,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoggedIn value) loggedIn,
    required TResult Function(_Initial value) initial,
    required TResult Function(_LoggedOut value) loggedOut,
    required TResult Function(_PartiallyLoggedOut value) partiallyLoggedOut,
    required TResult Function(_Unverified value) unverified,
    required TResult Function(_Verified value) verified,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoggedIn value)? loggedIn,
    TResult? Function(_Initial value)? initial,
    TResult? Function(_LoggedOut value)? loggedOut,
    TResult? Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult? Function(_Unverified value)? unverified,
    TResult? Function(_Verified value)? verified,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoggedIn value)? loggedIn,
    TResult Function(_Initial value)? initial,
    TResult Function(_LoggedOut value)? loggedOut,
    TResult Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult Function(_Unverified value)? unverified,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AuthState {
  const factory _Initial() = _$_Initial;
}

/// @nodoc
abstract class _$$_LoggedOutCopyWith<$Res> {
  factory _$$_LoggedOutCopyWith(
          _$_LoggedOut value, $Res Function(_$_LoggedOut) then) =
      __$$_LoggedOutCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LoggedOutCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_LoggedOut>
    implements _$$_LoggedOutCopyWith<$Res> {
  __$$_LoggedOutCopyWithImpl(
      _$_LoggedOut _value, $Res Function(_$_LoggedOut) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_LoggedOut implements _LoggedOut {
  const _$_LoggedOut();

  @override
  String toString() {
    return 'AuthState.loggedOut()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_LoggedOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserCredentials credentials) loggedIn,
    required TResult Function() initial,
    required TResult Function() loggedOut,
    required TResult Function() partiallyLoggedOut,
    required TResult Function() unverified,
    required TResult Function() verified,
  }) {
    return loggedOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserCredentials credentials)? loggedIn,
    TResult? Function()? initial,
    TResult? Function()? loggedOut,
    TResult? Function()? partiallyLoggedOut,
    TResult? Function()? unverified,
    TResult? Function()? verified,
  }) {
    return loggedOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserCredentials credentials)? loggedIn,
    TResult Function()? initial,
    TResult Function()? loggedOut,
    TResult Function()? partiallyLoggedOut,
    TResult Function()? unverified,
    TResult Function()? verified,
    required TResult orElse(),
  }) {
    if (loggedOut != null) {
      return loggedOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoggedIn value) loggedIn,
    required TResult Function(_Initial value) initial,
    required TResult Function(_LoggedOut value) loggedOut,
    required TResult Function(_PartiallyLoggedOut value) partiallyLoggedOut,
    required TResult Function(_Unverified value) unverified,
    required TResult Function(_Verified value) verified,
  }) {
    return loggedOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoggedIn value)? loggedIn,
    TResult? Function(_Initial value)? initial,
    TResult? Function(_LoggedOut value)? loggedOut,
    TResult? Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult? Function(_Unverified value)? unverified,
    TResult? Function(_Verified value)? verified,
  }) {
    return loggedOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoggedIn value)? loggedIn,
    TResult Function(_Initial value)? initial,
    TResult Function(_LoggedOut value)? loggedOut,
    TResult Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult Function(_Unverified value)? unverified,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (loggedOut != null) {
      return loggedOut(this);
    }
    return orElse();
  }
}

abstract class _LoggedOut implements AuthState {
  const factory _LoggedOut() = _$_LoggedOut;
}

/// @nodoc
abstract class _$$_PartiallyLoggedOutCopyWith<$Res> {
  factory _$$_PartiallyLoggedOutCopyWith(_$_PartiallyLoggedOut value,
          $Res Function(_$_PartiallyLoggedOut) then) =
      __$$_PartiallyLoggedOutCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PartiallyLoggedOutCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_PartiallyLoggedOut>
    implements _$$_PartiallyLoggedOutCopyWith<$Res> {
  __$$_PartiallyLoggedOutCopyWithImpl(
      _$_PartiallyLoggedOut _value, $Res Function(_$_PartiallyLoggedOut) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PartiallyLoggedOut implements _PartiallyLoggedOut {
  const _$_PartiallyLoggedOut();

  @override
  String toString() {
    return 'AuthState.partiallyLoggedOut()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PartiallyLoggedOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserCredentials credentials) loggedIn,
    required TResult Function() initial,
    required TResult Function() loggedOut,
    required TResult Function() partiallyLoggedOut,
    required TResult Function() unverified,
    required TResult Function() verified,
  }) {
    return partiallyLoggedOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserCredentials credentials)? loggedIn,
    TResult? Function()? initial,
    TResult? Function()? loggedOut,
    TResult? Function()? partiallyLoggedOut,
    TResult? Function()? unverified,
    TResult? Function()? verified,
  }) {
    return partiallyLoggedOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserCredentials credentials)? loggedIn,
    TResult Function()? initial,
    TResult Function()? loggedOut,
    TResult Function()? partiallyLoggedOut,
    TResult Function()? unverified,
    TResult Function()? verified,
    required TResult orElse(),
  }) {
    if (partiallyLoggedOut != null) {
      return partiallyLoggedOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoggedIn value) loggedIn,
    required TResult Function(_Initial value) initial,
    required TResult Function(_LoggedOut value) loggedOut,
    required TResult Function(_PartiallyLoggedOut value) partiallyLoggedOut,
    required TResult Function(_Unverified value) unverified,
    required TResult Function(_Verified value) verified,
  }) {
    return partiallyLoggedOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoggedIn value)? loggedIn,
    TResult? Function(_Initial value)? initial,
    TResult? Function(_LoggedOut value)? loggedOut,
    TResult? Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult? Function(_Unverified value)? unverified,
    TResult? Function(_Verified value)? verified,
  }) {
    return partiallyLoggedOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoggedIn value)? loggedIn,
    TResult Function(_Initial value)? initial,
    TResult Function(_LoggedOut value)? loggedOut,
    TResult Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult Function(_Unverified value)? unverified,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (partiallyLoggedOut != null) {
      return partiallyLoggedOut(this);
    }
    return orElse();
  }
}

abstract class _PartiallyLoggedOut implements AuthState {
  const factory _PartiallyLoggedOut() = _$_PartiallyLoggedOut;
}

/// @nodoc
abstract class _$$_UnverifiedCopyWith<$Res> {
  factory _$$_UnverifiedCopyWith(
          _$_Unverified value, $Res Function(_$_Unverified) then) =
      __$$_UnverifiedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UnverifiedCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_Unverified>
    implements _$$_UnverifiedCopyWith<$Res> {
  __$$_UnverifiedCopyWithImpl(
      _$_Unverified _value, $Res Function(_$_Unverified) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Unverified implements _Unverified {
  const _$_Unverified();

  @override
  String toString() {
    return 'AuthState.unverified()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Unverified);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserCredentials credentials) loggedIn,
    required TResult Function() initial,
    required TResult Function() loggedOut,
    required TResult Function() partiallyLoggedOut,
    required TResult Function() unverified,
    required TResult Function() verified,
  }) {
    return unverified();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserCredentials credentials)? loggedIn,
    TResult? Function()? initial,
    TResult? Function()? loggedOut,
    TResult? Function()? partiallyLoggedOut,
    TResult? Function()? unverified,
    TResult? Function()? verified,
  }) {
    return unverified?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserCredentials credentials)? loggedIn,
    TResult Function()? initial,
    TResult Function()? loggedOut,
    TResult Function()? partiallyLoggedOut,
    TResult Function()? unverified,
    TResult Function()? verified,
    required TResult orElse(),
  }) {
    if (unverified != null) {
      return unverified();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoggedIn value) loggedIn,
    required TResult Function(_Initial value) initial,
    required TResult Function(_LoggedOut value) loggedOut,
    required TResult Function(_PartiallyLoggedOut value) partiallyLoggedOut,
    required TResult Function(_Unverified value) unverified,
    required TResult Function(_Verified value) verified,
  }) {
    return unverified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoggedIn value)? loggedIn,
    TResult? Function(_Initial value)? initial,
    TResult? Function(_LoggedOut value)? loggedOut,
    TResult? Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult? Function(_Unverified value)? unverified,
    TResult? Function(_Verified value)? verified,
  }) {
    return unverified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoggedIn value)? loggedIn,
    TResult Function(_Initial value)? initial,
    TResult Function(_LoggedOut value)? loggedOut,
    TResult Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult Function(_Unverified value)? unverified,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (unverified != null) {
      return unverified(this);
    }
    return orElse();
  }
}

abstract class _Unverified implements AuthState {
  const factory _Unverified() = _$_Unverified;
}

/// @nodoc
abstract class _$$_VerifiedCopyWith<$Res> {
  factory _$$_VerifiedCopyWith(
          _$_Verified value, $Res Function(_$_Verified) then) =
      __$$_VerifiedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_VerifiedCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_Verified>
    implements _$$_VerifiedCopyWith<$Res> {
  __$$_VerifiedCopyWithImpl(
      _$_Verified _value, $Res Function(_$_Verified) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Verified implements _Verified {
  const _$_Verified();

  @override
  String toString() {
    return 'AuthState.verified()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Verified);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserCredentials credentials) loggedIn,
    required TResult Function() initial,
    required TResult Function() loggedOut,
    required TResult Function() partiallyLoggedOut,
    required TResult Function() unverified,
    required TResult Function() verified,
  }) {
    return verified();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserCredentials credentials)? loggedIn,
    TResult? Function()? initial,
    TResult? Function()? loggedOut,
    TResult? Function()? partiallyLoggedOut,
    TResult? Function()? unverified,
    TResult? Function()? verified,
  }) {
    return verified?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserCredentials credentials)? loggedIn,
    TResult Function()? initial,
    TResult Function()? loggedOut,
    TResult Function()? partiallyLoggedOut,
    TResult Function()? unverified,
    TResult Function()? verified,
    required TResult orElse(),
  }) {
    if (verified != null) {
      return verified();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoggedIn value) loggedIn,
    required TResult Function(_Initial value) initial,
    required TResult Function(_LoggedOut value) loggedOut,
    required TResult Function(_PartiallyLoggedOut value) partiallyLoggedOut,
    required TResult Function(_Unverified value) unverified,
    required TResult Function(_Verified value) verified,
  }) {
    return verified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoggedIn value)? loggedIn,
    TResult? Function(_Initial value)? initial,
    TResult? Function(_LoggedOut value)? loggedOut,
    TResult? Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult? Function(_Unverified value)? unverified,
    TResult? Function(_Verified value)? verified,
  }) {
    return verified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoggedIn value)? loggedIn,
    TResult Function(_Initial value)? initial,
    TResult Function(_LoggedOut value)? loggedOut,
    TResult Function(_PartiallyLoggedOut value)? partiallyLoggedOut,
    TResult Function(_Unverified value)? unverified,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (verified != null) {
      return verified(this);
    }
    return orElse();
  }
}

abstract class _Verified implements AuthState {
  const factory _Verified() = _$_Verified;
}
