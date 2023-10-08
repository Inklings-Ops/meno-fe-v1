// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_form_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegisterFormState {
  /// The user's full name - First and Last names.
  IFullName get fullName => throw _privateConstructorUsedError;

  /// The user's email address.
  IEmail get email => throw _privateConstructorUsedError;

  /// The user's password.
  IPassword get password => throw _privateConstructorUsedError;
  String get passwordValue => throw _privateConstructorUsedError;

  /// Whether or not to show an error message.
  bool get showError => throw _privateConstructorUsedError;

  /// Whether or not the registration form is loading.
  bool get loading => throw _privateConstructorUsedError;

  /// The result of the last registration attempt.
  Option<Either<AuthException, Unit>> get option =>
      throw _privateConstructorUsedError;
  bool get rememberMe => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterFormStateCopyWith<RegisterFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterFormStateCopyWith<$Res> {
  factory $RegisterFormStateCopyWith(
          RegisterFormState value, $Res Function(RegisterFormState) then) =
      _$RegisterFormStateCopyWithImpl<$Res, RegisterFormState>;
  @useResult
  $Res call(
      {IFullName fullName,
      IEmail email,
      IPassword password,
      String passwordValue,
      bool showError,
      bool loading,
      Option<Either<AuthException, Unit>> option,
      bool rememberMe});
}

/// @nodoc
class _$RegisterFormStateCopyWithImpl<$Res, $Val extends RegisterFormState>
    implements $RegisterFormStateCopyWith<$Res> {
  _$RegisterFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? password = null,
    Object? passwordValue = null,
    Object? showError = null,
    Object? loading = null,
    Object? option = null,
    Object? rememberMe = null,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as IFullName,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as IEmail,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as IPassword,
      passwordValue: null == passwordValue
          ? _value.passwordValue
          : passwordValue // ignore: cast_nullable_to_non_nullable
              as String,
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
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RegisterFormStateCopyWith<$Res>
    implements $RegisterFormStateCopyWith<$Res> {
  factory _$$_RegisterFormStateCopyWith(_$_RegisterFormState value,
          $Res Function(_$_RegisterFormState) then) =
      __$$_RegisterFormStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {IFullName fullName,
      IEmail email,
      IPassword password,
      String passwordValue,
      bool showError,
      bool loading,
      Option<Either<AuthException, Unit>> option,
      bool rememberMe});
}

/// @nodoc
class __$$_RegisterFormStateCopyWithImpl<$Res>
    extends _$RegisterFormStateCopyWithImpl<$Res, _$_RegisterFormState>
    implements _$$_RegisterFormStateCopyWith<$Res> {
  __$$_RegisterFormStateCopyWithImpl(
      _$_RegisterFormState _value, $Res Function(_$_RegisterFormState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? password = null,
    Object? passwordValue = null,
    Object? showError = null,
    Object? loading = null,
    Object? option = null,
    Object? rememberMe = null,
  }) {
    return _then(_$_RegisterFormState(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as IFullName,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as IEmail,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as IPassword,
      passwordValue: null == passwordValue
          ? _value.passwordValue
          : passwordValue // ignore: cast_nullable_to_non_nullable
              as String,
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
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_RegisterFormState implements _RegisterFormState {
  _$_RegisterFormState(
      {required this.fullName,
      required this.email,
      required this.password,
      required this.passwordValue,
      required this.showError,
      required this.loading,
      required this.option,
      required this.rememberMe});

  /// The user's full name - First and Last names.
  @override
  final IFullName fullName;

  /// The user's email address.
  @override
  final IEmail email;

  /// The user's password.
  @override
  final IPassword password;
  @override
  final String passwordValue;

  /// Whether or not to show an error message.
  @override
  final bool showError;

  /// Whether or not the registration form is loading.
  @override
  final bool loading;

  /// The result of the last registration attempt.
  @override
  final Option<Either<AuthException, Unit>> option;
  @override
  final bool rememberMe;

  @override
  String toString() {
    return 'RegisterFormState(fullName: $fullName, email: $email, password: $password, passwordValue: $passwordValue, showError: $showError, loading: $loading, option: $option, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegisterFormState &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordValue, passwordValue) ||
                other.passwordValue == passwordValue) &&
            (identical(other.showError, showError) ||
                other.showError == showError) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.option, option) || other.option == option) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fullName, email, password,
      passwordValue, showError, loading, option, rememberMe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RegisterFormStateCopyWith<_$_RegisterFormState> get copyWith =>
      __$$_RegisterFormStateCopyWithImpl<_$_RegisterFormState>(
          this, _$identity);
}

abstract class _RegisterFormState implements RegisterFormState {
  factory _RegisterFormState(
      {required final IFullName fullName,
      required final IEmail email,
      required final IPassword password,
      required final String passwordValue,
      required final bool showError,
      required final bool loading,
      required final Option<Either<AuthException, Unit>> option,
      required final bool rememberMe}) = _$_RegisterFormState;

  @override

  /// The user's full name - First and Last names.
  IFullName get fullName;
  @override

  /// The user's email address.
  IEmail get email;
  @override

  /// The user's password.
  IPassword get password;
  @override
  String get passwordValue;
  @override

  /// Whether or not to show an error message.
  bool get showError;
  @override

  /// Whether or not the registration form is loading.
  bool get loading;
  @override

  /// The result of the last registration attempt.
  Option<Either<AuthException, Unit>> get option;
  @override
  bool get rememberMe;
  @override
  @JsonKey(ignore: true)
  _$$_RegisterFormStateCopyWith<_$_RegisterFormState> get copyWith =>
      throw _privateConstructorUsedError;
}
