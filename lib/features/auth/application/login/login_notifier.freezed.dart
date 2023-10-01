// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LoginState {
  /// The user's email address.
  IEmail get email => throw _privateConstructorUsedError;

  /// The user's password.
  IPassword get password => throw _privateConstructorUsedError;

  /// Whether or not to show an error message.
  bool get showError => throw _privateConstructorUsedError;

  /// Whether or not the login form is loading.
  bool get loading => throw _privateConstructorUsedError;

  /// The result of the last login attempt.
  Option<Either<AuthException, Unit>> get option =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoginStateCopyWith<LoginState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
          LoginState value, $Res Function(LoginState) then) =
      _$LoginStateCopyWithImpl<$Res, LoginState>;
  @useResult
  $Res call(
      {IEmail email,
      IPassword password,
      bool showError,
      bool loading,
      Option<Either<AuthException, Unit>> option});
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res, $Val extends LoginState>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? showError = null,
    Object? loading = null,
    Object? option = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as IEmail,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as IPassword,
      showError: null == showError
          ? _value.showError
          : showError // ignore: cast_nullable_to_non_nullable
              as bool,
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
}

/// @nodoc
abstract class _$$_LoginStateCopyWith<$Res>
    implements $LoginStateCopyWith<$Res> {
  factory _$$_LoginStateCopyWith(
          _$_LoginState value, $Res Function(_$_LoginState) then) =
      __$$_LoginStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {IEmail email,
      IPassword password,
      bool showError,
      bool loading,
      Option<Either<AuthException, Unit>> option});
}

/// @nodoc
class __$$_LoginStateCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$_LoginState>
    implements _$$_LoginStateCopyWith<$Res> {
  __$$_LoginStateCopyWithImpl(
      _$_LoginState _value, $Res Function(_$_LoginState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? showError = null,
    Object? loading = null,
    Object? option = null,
  }) {
    return _then(_$_LoginState(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as IEmail,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as IPassword,
      showError: null == showError
          ? _value.showError
          : showError // ignore: cast_nullable_to_non_nullable
              as bool,
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

class _$_LoginState implements _LoginState {
  _$_LoginState(
      {required this.email,
      required this.password,
      required this.showError,
      required this.loading,
      required this.option});

  /// The user's email address.
  @override
  final IEmail email;

  /// The user's password.
  @override
  final IPassword password;

  /// Whether or not to show an error message.
  @override
  final bool showError;

  /// Whether or not the login form is loading.
  @override
  final bool loading;

  /// The result of the last login attempt.
  @override
  final Option<Either<AuthException, Unit>> option;

  @override
  String toString() {
    return 'LoginState(email: $email, password: $password, showError: $showError, loading: $loading, option: $option)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoginState &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.showError, showError) ||
                other.showError == showError) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.option, option) || other.option == option));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, showError, loading, option);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoginStateCopyWith<_$_LoginState> get copyWith =>
      __$$_LoginStateCopyWithImpl<_$_LoginState>(this, _$identity);
}

abstract class _LoginState implements LoginState {
  factory _LoginState(
          {required final IEmail email,
          required final IPassword password,
          required final bool showError,
          required final bool loading,
          required final Option<Either<AuthException, Unit>> option}) =
      _$_LoginState;

  @override

  /// The user's email address.
  IEmail get email;
  @override

  /// The user's password.
  IPassword get password;
  @override

  /// Whether or not to show an error message.
  bool get showError;
  @override

  /// Whether or not the login form is loading.
  bool get loading;
  @override

  /// The result of the last login attempt.
  Option<Either<AuthException, Unit>> get option;
  @override
  @JsonKey(ignore: true)
  _$$_LoginStateCopyWith<_$_LoginState> get copyWith =>
      throw _privateConstructorUsedError;
}
