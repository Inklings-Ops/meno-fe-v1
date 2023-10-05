// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_login_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ReturnLoginState {
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
  $ReturnLoginStateCopyWith<ReturnLoginState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnLoginStateCopyWith<$Res> {
  factory $ReturnLoginStateCopyWith(
          ReturnLoginState value, $Res Function(ReturnLoginState) then) =
      _$ReturnLoginStateCopyWithImpl<$Res, ReturnLoginState>;
  @useResult
  $Res call(
      {IPassword password,
      bool showError,
      bool loading,
      Option<Either<AuthException, Unit>> option});
}

/// @nodoc
class _$ReturnLoginStateCopyWithImpl<$Res, $Val extends ReturnLoginState>
    implements $ReturnLoginStateCopyWith<$Res> {
  _$ReturnLoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? showError = null,
    Object? loading = null,
    Object? option = null,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$_ReturnLoginStateCopyWith<$Res>
    implements $ReturnLoginStateCopyWith<$Res> {
  factory _$$_ReturnLoginStateCopyWith(
          _$_ReturnLoginState value, $Res Function(_$_ReturnLoginState) then) =
      __$$_ReturnLoginStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {IPassword password,
      bool showError,
      bool loading,
      Option<Either<AuthException, Unit>> option});
}

/// @nodoc
class __$$_ReturnLoginStateCopyWithImpl<$Res>
    extends _$ReturnLoginStateCopyWithImpl<$Res, _$_ReturnLoginState>
    implements _$$_ReturnLoginStateCopyWith<$Res> {
  __$$_ReturnLoginStateCopyWithImpl(
      _$_ReturnLoginState _value, $Res Function(_$_ReturnLoginState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? showError = null,
    Object? loading = null,
    Object? option = null,
  }) {
    return _then(_$_ReturnLoginState(
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

class _$_ReturnLoginState implements _ReturnLoginState {
  _$_ReturnLoginState(
      {required this.password,
      required this.showError,
      required this.loading,
      required this.option});

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
    return 'ReturnLoginState(password: $password, showError: $showError, loading: $loading, option: $option)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReturnLoginState &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.showError, showError) ||
                other.showError == showError) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.option, option) || other.option == option));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, password, showError, loading, option);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReturnLoginStateCopyWith<_$_ReturnLoginState> get copyWith =>
      __$$_ReturnLoginStateCopyWithImpl<_$_ReturnLoginState>(this, _$identity);
}

abstract class _ReturnLoginState implements ReturnLoginState {
  factory _ReturnLoginState(
          {required final IPassword password,
          required final bool showError,
          required final bool loading,
          required final Option<Either<AuthException, Unit>> option}) =
      _$_ReturnLoginState;

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
  _$$_ReturnLoginStateCopyWith<_$_ReturnLoginState> get copyWith =>
      throw _privateConstructorUsedError;
}
