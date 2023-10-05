// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthExceptionCopyWith<$Res> {
  factory $AuthExceptionCopyWith(
          AuthException value, $Res Function(AuthException) then) =
      _$AuthExceptionCopyWithImpl<$Res, AuthException>;
}

/// @nodoc
class _$AuthExceptionCopyWithImpl<$Res, $Val extends AuthException>
    implements $AuthExceptionCopyWith<$Res> {
  _$AuthExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_MessageCopyWith<$Res> {
  factory _$$_MessageCopyWith(
          _$_Message value, $Res Function(_$_Message) then) =
      __$$_MessageCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$_MessageCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$_Message>
    implements _$$_MessageCopyWith<$Res> {
  __$$_MessageCopyWithImpl(_$_Message _value, $Res Function(_$_Message) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$_Message(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Message implements _Message {
  const _$_Message(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthException.message(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Message &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageCopyWith<_$_Message> get copyWith =>
      __$$_MessageCopyWithImpl<_$_Message>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return message(this.message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return message?.call(this.message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (message != null) {
      return message(this.message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return message(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return message?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (message != null) {
      return message(this);
    }
    return orElse();
  }
}

abstract class _Message implements AuthException {
  const factory _Message(final String message) = _$_Message;

  String get message;
  @JsonKey(ignore: true)
  _$$_MessageCopyWith<_$_Message> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidEmailOrPasswordCopyWith<$Res> {
  factory _$$InvalidEmailOrPasswordCopyWith(_$InvalidEmailOrPassword value,
          $Res Function(_$InvalidEmailOrPassword) then) =
      __$$InvalidEmailOrPasswordCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InvalidEmailOrPasswordCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$InvalidEmailOrPassword>
    implements _$$InvalidEmailOrPasswordCopyWith<$Res> {
  __$$InvalidEmailOrPasswordCopyWithImpl(_$InvalidEmailOrPassword _value,
      $Res Function(_$InvalidEmailOrPassword) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InvalidEmailOrPassword implements InvalidEmailOrPassword {
  const _$InvalidEmailOrPassword();

  @override
  String toString() {
    return 'AuthException.invalidEmailOrPassword()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InvalidEmailOrPassword);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return invalidEmailOrPassword();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return invalidEmailOrPassword?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (invalidEmailOrPassword != null) {
      return invalidEmailOrPassword();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return invalidEmailOrPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return invalidEmailOrPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (invalidEmailOrPassword != null) {
      return invalidEmailOrPassword(this);
    }
    return orElse();
  }
}

abstract class InvalidEmailOrPassword implements AuthException {
  const factory InvalidEmailOrPassword() = _$InvalidEmailOrPassword;
}

/// @nodoc
abstract class _$$_EmailAlreadyInUseCopyWith<$Res> {
  factory _$$_EmailAlreadyInUseCopyWith(_$_EmailAlreadyInUse value,
          $Res Function(_$_EmailAlreadyInUse) then) =
      __$$_EmailAlreadyInUseCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_EmailAlreadyInUseCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$_EmailAlreadyInUse>
    implements _$$_EmailAlreadyInUseCopyWith<$Res> {
  __$$_EmailAlreadyInUseCopyWithImpl(
      _$_EmailAlreadyInUse _value, $Res Function(_$_EmailAlreadyInUse) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_EmailAlreadyInUse implements _EmailAlreadyInUse {
  const _$_EmailAlreadyInUse();

  @override
  String toString() {
    return 'AuthException.emailAlreadyInUse()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_EmailAlreadyInUse);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return emailAlreadyInUse();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return emailAlreadyInUse?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (emailAlreadyInUse != null) {
      return emailAlreadyInUse();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return emailAlreadyInUse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return emailAlreadyInUse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (emailAlreadyInUse != null) {
      return emailAlreadyInUse(this);
    }
    return orElse();
  }
}

abstract class _EmailAlreadyInUse implements AuthException {
  const factory _EmailAlreadyInUse() = _$_EmailAlreadyInUse;
}

/// @nodoc
abstract class _$$_ServerErrorCopyWith<$Res> {
  factory _$$_ServerErrorCopyWith(
          _$_ServerError value, $Res Function(_$_ServerError) then) =
      __$$_ServerErrorCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ServerErrorCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$_ServerError>
    implements _$$_ServerErrorCopyWith<$Res> {
  __$$_ServerErrorCopyWithImpl(
      _$_ServerError _value, $Res Function(_$_ServerError) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ServerError implements _ServerError {
  const _$_ServerError();

  @override
  String toString() {
    return 'AuthException.serverError()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ServerError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return serverError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return serverError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class _ServerError implements AuthException {
  const factory _ServerError() = _$_ServerError;
}

/// @nodoc
abstract class _$$_UnknownErrorCopyWith<$Res> {
  factory _$$_UnknownErrorCopyWith(
          _$_UnknownError value, $Res Function(_$_UnknownError) then) =
      __$$_UnknownErrorCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UnknownErrorCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$_UnknownError>
    implements _$$_UnknownErrorCopyWith<$Res> {
  __$$_UnknownErrorCopyWithImpl(
      _$_UnknownError _value, $Res Function(_$_UnknownError) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_UnknownError implements _UnknownError {
  const _$_UnknownError();

  @override
  String toString() {
    return 'AuthException.unknownError()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_UnknownError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return unknownError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return unknownError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (unknownError != null) {
      return unknownError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return unknownError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return unknownError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (unknownError != null) {
      return unknownError(this);
    }
    return orElse();
  }
}

abstract class _UnknownError implements AuthException {
  const factory _UnknownError() = _$_UnknownError;
}

/// @nodoc
abstract class _$$_TimeOutErrorCopyWith<$Res> {
  factory _$$_TimeOutErrorCopyWith(
          _$_TimeOutError value, $Res Function(_$_TimeOutError) then) =
      __$$_TimeOutErrorCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_TimeOutErrorCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$_TimeOutError>
    implements _$$_TimeOutErrorCopyWith<$Res> {
  __$$_TimeOutErrorCopyWithImpl(
      _$_TimeOutError _value, $Res Function(_$_TimeOutError) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_TimeOutError implements _TimeOutError {
  const _$_TimeOutError();

  @override
  String toString() {
    return 'AuthException.timeOutError()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_TimeOutError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return timeOutError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return timeOutError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (timeOutError != null) {
      return timeOutError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return timeOutError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return timeOutError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (timeOutError != null) {
      return timeOutError(this);
    }
    return orElse();
  }
}

abstract class _TimeOutError implements AuthException {
  const factory _TimeOutError() = _$_TimeOutError;
}

/// @nodoc
abstract class _$$_NetworkErrorCopyWith<$Res> {
  factory _$$_NetworkErrorCopyWith(
          _$_NetworkError value, $Res Function(_$_NetworkError) then) =
      __$$_NetworkErrorCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NetworkErrorCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$_NetworkError>
    implements _$$_NetworkErrorCopyWith<$Res> {
  __$$_NetworkErrorCopyWithImpl(
      _$_NetworkError _value, $Res Function(_$_NetworkError) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NetworkError implements _NetworkError {
  const _$_NetworkError();

  @override
  String toString() {
    return 'AuthException.networkError()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_NetworkError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return networkError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return networkError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return networkError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return networkError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(this);
    }
    return orElse();
  }
}

abstract class _NetworkError implements AuthException {
  const factory _NetworkError() = _$_NetworkError;
}

/// @nodoc
abstract class _$$_UserTokenExpiredCopyWith<$Res> {
  factory _$$_UserTokenExpiredCopyWith(
          _$_UserTokenExpired value, $Res Function(_$_UserTokenExpired) then) =
      __$$_UserTokenExpiredCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UserTokenExpiredCopyWithImpl<$Res>
    extends _$AuthExceptionCopyWithImpl<$Res, _$_UserTokenExpired>
    implements _$$_UserTokenExpiredCopyWith<$Res> {
  __$$_UserTokenExpiredCopyWithImpl(
      _$_UserTokenExpired _value, $Res Function(_$_UserTokenExpired) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_UserTokenExpired implements _UserTokenExpired {
  const _$_UserTokenExpired();

  @override
  String toString() {
    return 'AuthException.userTokenExpired()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_UserTokenExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) message,
    required TResult Function() invalidEmailOrPassword,
    required TResult Function() emailAlreadyInUse,
    required TResult Function() serverError,
    required TResult Function() unknownError,
    required TResult Function() timeOutError,
    required TResult Function() networkError,
    required TResult Function() userTokenExpired,
  }) {
    return userTokenExpired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? message,
    TResult? Function()? invalidEmailOrPassword,
    TResult? Function()? emailAlreadyInUse,
    TResult? Function()? serverError,
    TResult? Function()? unknownError,
    TResult? Function()? timeOutError,
    TResult? Function()? networkError,
    TResult? Function()? userTokenExpired,
  }) {
    return userTokenExpired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? message,
    TResult Function()? invalidEmailOrPassword,
    TResult Function()? emailAlreadyInUse,
    TResult Function()? serverError,
    TResult Function()? unknownError,
    TResult Function()? timeOutError,
    TResult Function()? networkError,
    TResult Function()? userTokenExpired,
    required TResult orElse(),
  }) {
    if (userTokenExpired != null) {
      return userTokenExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Message value) message,
    required TResult Function(InvalidEmailOrPassword value)
        invalidEmailOrPassword,
    required TResult Function(_EmailAlreadyInUse value) emailAlreadyInUse,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_UnknownError value) unknownError,
    required TResult Function(_TimeOutError value) timeOutError,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_UserTokenExpired value) userTokenExpired,
  }) {
    return userTokenExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Message value)? message,
    TResult? Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult? Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_UnknownError value)? unknownError,
    TResult? Function(_TimeOutError value)? timeOutError,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_UserTokenExpired value)? userTokenExpired,
  }) {
    return userTokenExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Message value)? message,
    TResult Function(InvalidEmailOrPassword value)? invalidEmailOrPassword,
    TResult Function(_EmailAlreadyInUse value)? emailAlreadyInUse,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_UnknownError value)? unknownError,
    TResult Function(_TimeOutError value)? timeOutError,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_UserTokenExpired value)? userTokenExpired,
    required TResult orElse(),
  }) {
    if (userTokenExpired != null) {
      return userTokenExpired(this);
    }
    return orElse();
  }
}

abstract class _UserTokenExpired implements AuthException {
  const factory _UserTokenExpired() = _$_UserTokenExpired;
}
