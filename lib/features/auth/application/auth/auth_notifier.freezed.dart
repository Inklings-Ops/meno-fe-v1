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
  AuthStatus get status => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  Map<String, UserCredentials> get credentials =>
      throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  Option<Either<AuthException, Unit>> get option =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call(
      {AuthStatus status,
      User user,
      String token,
      Map<String, UserCredentials> credentials,
      bool loading,
      Option<Either<AuthException, Unit>> option});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? user = null,
    Object? token = null,
    Object? credentials = null,
    Object? loading = null,
    Object? option = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      credentials: null == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as Map<String, UserCredentials>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      option: null == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as Option<Either<AuthException, Unit>>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$$_AuthStateCopyWith(
          _$_AuthState value, $Res Function(_$_AuthState) then) =
      __$$_AuthStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthStatus status,
      User user,
      String token,
      Map<String, UserCredentials> credentials,
      bool loading,
      Option<Either<AuthException, Unit>> option});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$_AuthStateCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$_AuthState>
    implements _$$_AuthStateCopyWith<$Res> {
  __$$_AuthStateCopyWithImpl(
      _$_AuthState _value, $Res Function(_$_AuthState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? user = null,
    Object? token = null,
    Object? credentials = null,
    Object? loading = null,
    Object? option = null,
  }) {
    return _then(_$_AuthState(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      credentials: null == credentials
          ? _value._credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as Map<String, UserCredentials>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      option: null == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as Option<Either<AuthException, Unit>>,
    ));
  }
}

/// @nodoc

class _$_AuthState implements _AuthState {
  _$_AuthState(
      {required this.status,
      required this.user,
      required this.token,
      required final Map<String, UserCredentials> credentials,
      required this.loading,
      required this.option})
      : _credentials = credentials;

  @override
  final AuthStatus status;
  @override
  final User user;
  @override
  final String token;
  final Map<String, UserCredentials> _credentials;
  @override
  Map<String, UserCredentials> get credentials {
    if (_credentials is EqualUnmodifiableMapView) return _credentials;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_credentials);
  }

  @override
  final bool loading;
  @override
  final Option<Either<AuthException, Unit>> option;

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, token: $token, credentials: $credentials, loading: $loading, option: $option)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token) &&
            const DeepCollectionEquality()
                .equals(other._credentials, _credentials) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.option, option) || other.option == option));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, user, token,
      const DeepCollectionEquality().hash(_credentials), loading, option);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AuthStateCopyWith<_$_AuthState> get copyWith =>
      __$$_AuthStateCopyWithImpl<_$_AuthState>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  factory _AuthState(
          {required final AuthStatus status,
          required final User user,
          required final String token,
          required final Map<String, UserCredentials> credentials,
          required final bool loading,
          required final Option<Either<AuthException, Unit>> option}) =
      _$_AuthState;

  @override
  AuthStatus get status;
  @override
  User get user;
  @override
  String get token;
  @override
  Map<String, UserCredentials> get credentials;
  @override
  bool get loading;
  @override
  Option<Either<AuthException, Unit>> get option;
  @override
  @JsonKey(ignore: true)
  _$$_AuthStateCopyWith<_$_AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}
