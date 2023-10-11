// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'value_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ValueFailure<T> {
  T? get f => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? f) bioLengthExceeded,
    required TResult Function(T? f) empty,
    required TResult Function(T? f) invalidEmail,
    required TResult Function(T? f) invalidImageType,
    required TResult Function(T? f) invalidPassword,
    required TResult Function(T? f) descLengthExceeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? f)? bioLengthExceeded,
    TResult? Function(T? f)? empty,
    TResult? Function(T? f)? invalidEmail,
    TResult? Function(T? f)? invalidImageType,
    TResult? Function(T? f)? invalidPassword,
    TResult? Function(T? f)? descLengthExceeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? f)? bioLengthExceeded,
    TResult Function(T? f)? empty,
    TResult Function(T? f)? invalidEmail,
    TResult Function(T? f)? invalidImageType,
    TResult Function(T? f)? invalidPassword,
    TResult Function(T? f)? descLengthExceeded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BioLengthExceeded<T> value) bioLengthExceeded,
    required TResult Function(Empty<T> value) empty,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidImageType<T> value) invalidImageType,
    required TResult Function(InvalidPassword<T> value) invalidPassword,
    required TResult Function(DescLengthExceeded<T> value) descLengthExceeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidImageType<T> value)? invalidImageType,
    TResult? Function(InvalidPassword<T> value)? invalidPassword,
    TResult? Function(DescLengthExceeded<T> value)? descLengthExceeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult Function(Empty<T> value)? empty,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidImageType<T> value)? invalidImageType,
    TResult Function(InvalidPassword<T> value)? invalidPassword,
    TResult Function(DescLengthExceeded<T> value)? descLengthExceeded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ValueFailureCopyWith<T, ValueFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValueFailureCopyWith<T, $Res> {
  factory $ValueFailureCopyWith(
          ValueFailure<T> value, $Res Function(ValueFailure<T>) then) =
      _$ValueFailureCopyWithImpl<T, $Res, ValueFailure<T>>;
  @useResult
  $Res call({T? f});
}

/// @nodoc
class _$ValueFailureCopyWithImpl<T, $Res, $Val extends ValueFailure<T>>
    implements $ValueFailureCopyWith<T, $Res> {
  _$ValueFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? f = freezed,
  }) {
    return _then(_value.copyWith(
      f: freezed == f
          ? _value.f
          : f // ignore: cast_nullable_to_non_nullable
              as T?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BioLengthExceededCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$BioLengthExceededCopyWith(_$BioLengthExceeded<T> value,
          $Res Function(_$BioLengthExceeded<T>) then) =
      __$$BioLengthExceededCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? f});
}

/// @nodoc
class __$$BioLengthExceededCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$BioLengthExceeded<T>>
    implements _$$BioLengthExceededCopyWith<T, $Res> {
  __$$BioLengthExceededCopyWithImpl(_$BioLengthExceeded<T> _value,
      $Res Function(_$BioLengthExceeded<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? f = freezed,
  }) {
    return _then(_$BioLengthExceeded<T>(
      freezed == f
          ? _value.f
          : f // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$BioLengthExceeded<T> implements BioLengthExceeded<T> {
  const _$BioLengthExceeded([this.f]);

  @override
  final T? f;

  @override
  String toString() {
    return 'ValueFailure<$T>.bioLengthExceeded(f: $f)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BioLengthExceeded<T> &&
            const DeepCollectionEquality().equals(other.f, f));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(f));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BioLengthExceededCopyWith<T, _$BioLengthExceeded<T>> get copyWith =>
      __$$BioLengthExceededCopyWithImpl<T, _$BioLengthExceeded<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? f) bioLengthExceeded,
    required TResult Function(T? f) empty,
    required TResult Function(T? f) invalidEmail,
    required TResult Function(T? f) invalidImageType,
    required TResult Function(T? f) invalidPassword,
    required TResult Function(T? f) descLengthExceeded,
  }) {
    return bioLengthExceeded(f);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? f)? bioLengthExceeded,
    TResult? Function(T? f)? empty,
    TResult? Function(T? f)? invalidEmail,
    TResult? Function(T? f)? invalidImageType,
    TResult? Function(T? f)? invalidPassword,
    TResult? Function(T? f)? descLengthExceeded,
  }) {
    return bioLengthExceeded?.call(f);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? f)? bioLengthExceeded,
    TResult Function(T? f)? empty,
    TResult Function(T? f)? invalidEmail,
    TResult Function(T? f)? invalidImageType,
    TResult Function(T? f)? invalidPassword,
    TResult Function(T? f)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (bioLengthExceeded != null) {
      return bioLengthExceeded(f);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BioLengthExceeded<T> value) bioLengthExceeded,
    required TResult Function(Empty<T> value) empty,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidImageType<T> value) invalidImageType,
    required TResult Function(InvalidPassword<T> value) invalidPassword,
    required TResult Function(DescLengthExceeded<T> value) descLengthExceeded,
  }) {
    return bioLengthExceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidImageType<T> value)? invalidImageType,
    TResult? Function(InvalidPassword<T> value)? invalidPassword,
    TResult? Function(DescLengthExceeded<T> value)? descLengthExceeded,
  }) {
    return bioLengthExceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult Function(Empty<T> value)? empty,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidImageType<T> value)? invalidImageType,
    TResult Function(InvalidPassword<T> value)? invalidPassword,
    TResult Function(DescLengthExceeded<T> value)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (bioLengthExceeded != null) {
      return bioLengthExceeded(this);
    }
    return orElse();
  }
}

abstract class BioLengthExceeded<T> implements ValueFailure<T> {
  const factory BioLengthExceeded([final T? f]) = _$BioLengthExceeded<T>;

  @override
  T? get f;
  @override
  @JsonKey(ignore: true)
  _$$BioLengthExceededCopyWith<T, _$BioLengthExceeded<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmptyCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$EmptyCopyWith(_$Empty<T> value, $Res Function(_$Empty<T>) then) =
      __$$EmptyCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? f});
}

/// @nodoc
class __$$EmptyCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$Empty<T>>
    implements _$$EmptyCopyWith<T, $Res> {
  __$$EmptyCopyWithImpl(_$Empty<T> _value, $Res Function(_$Empty<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? f = freezed,
  }) {
    return _then(_$Empty<T>(
      freezed == f
          ? _value.f
          : f // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$Empty<T> implements Empty<T> {
  const _$Empty([this.f]);

  @override
  final T? f;

  @override
  String toString() {
    return 'ValueFailure<$T>.empty(f: $f)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Empty<T> &&
            const DeepCollectionEquality().equals(other.f, f));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(f));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmptyCopyWith<T, _$Empty<T>> get copyWith =>
      __$$EmptyCopyWithImpl<T, _$Empty<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? f) bioLengthExceeded,
    required TResult Function(T? f) empty,
    required TResult Function(T? f) invalidEmail,
    required TResult Function(T? f) invalidImageType,
    required TResult Function(T? f) invalidPassword,
    required TResult Function(T? f) descLengthExceeded,
  }) {
    return empty(f);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? f)? bioLengthExceeded,
    TResult? Function(T? f)? empty,
    TResult? Function(T? f)? invalidEmail,
    TResult? Function(T? f)? invalidImageType,
    TResult? Function(T? f)? invalidPassword,
    TResult? Function(T? f)? descLengthExceeded,
  }) {
    return empty?.call(f);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? f)? bioLengthExceeded,
    TResult Function(T? f)? empty,
    TResult Function(T? f)? invalidEmail,
    TResult Function(T? f)? invalidImageType,
    TResult Function(T? f)? invalidPassword,
    TResult Function(T? f)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(f);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BioLengthExceeded<T> value) bioLengthExceeded,
    required TResult Function(Empty<T> value) empty,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidImageType<T> value) invalidImageType,
    required TResult Function(InvalidPassword<T> value) invalidPassword,
    required TResult Function(DescLengthExceeded<T> value) descLengthExceeded,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidImageType<T> value)? invalidImageType,
    TResult? Function(InvalidPassword<T> value)? invalidPassword,
    TResult? Function(DescLengthExceeded<T> value)? descLengthExceeded,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult Function(Empty<T> value)? empty,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidImageType<T> value)? invalidImageType,
    TResult Function(InvalidPassword<T> value)? invalidPassword,
    TResult Function(DescLengthExceeded<T> value)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class Empty<T> implements ValueFailure<T> {
  const factory Empty([final T? f]) = _$Empty<T>;

  @override
  T? get f;
  @override
  @JsonKey(ignore: true)
  _$$EmptyCopyWith<T, _$Empty<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidEmailCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$InvalidEmailCopyWith(
          _$InvalidEmail<T> value, $Res Function(_$InvalidEmail<T>) then) =
      __$$InvalidEmailCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? f});
}

/// @nodoc
class __$$InvalidEmailCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$InvalidEmail<T>>
    implements _$$InvalidEmailCopyWith<T, $Res> {
  __$$InvalidEmailCopyWithImpl(
      _$InvalidEmail<T> _value, $Res Function(_$InvalidEmail<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? f = freezed,
  }) {
    return _then(_$InvalidEmail<T>(
      freezed == f
          ? _value.f
          : f // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$InvalidEmail<T> implements InvalidEmail<T> {
  const _$InvalidEmail([this.f]);

  @override
  final T? f;

  @override
  String toString() {
    return 'ValueFailure<$T>.invalidEmail(f: $f)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidEmail<T> &&
            const DeepCollectionEquality().equals(other.f, f));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(f));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidEmailCopyWith<T, _$InvalidEmail<T>> get copyWith =>
      __$$InvalidEmailCopyWithImpl<T, _$InvalidEmail<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? f) bioLengthExceeded,
    required TResult Function(T? f) empty,
    required TResult Function(T? f) invalidEmail,
    required TResult Function(T? f) invalidImageType,
    required TResult Function(T? f) invalidPassword,
    required TResult Function(T? f) descLengthExceeded,
  }) {
    return invalidEmail(f);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? f)? bioLengthExceeded,
    TResult? Function(T? f)? empty,
    TResult? Function(T? f)? invalidEmail,
    TResult? Function(T? f)? invalidImageType,
    TResult? Function(T? f)? invalidPassword,
    TResult? Function(T? f)? descLengthExceeded,
  }) {
    return invalidEmail?.call(f);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? f)? bioLengthExceeded,
    TResult Function(T? f)? empty,
    TResult Function(T? f)? invalidEmail,
    TResult Function(T? f)? invalidImageType,
    TResult Function(T? f)? invalidPassword,
    TResult Function(T? f)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (invalidEmail != null) {
      return invalidEmail(f);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BioLengthExceeded<T> value) bioLengthExceeded,
    required TResult Function(Empty<T> value) empty,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidImageType<T> value) invalidImageType,
    required TResult Function(InvalidPassword<T> value) invalidPassword,
    required TResult Function(DescLengthExceeded<T> value) descLengthExceeded,
  }) {
    return invalidEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidImageType<T> value)? invalidImageType,
    TResult? Function(InvalidPassword<T> value)? invalidPassword,
    TResult? Function(DescLengthExceeded<T> value)? descLengthExceeded,
  }) {
    return invalidEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult Function(Empty<T> value)? empty,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidImageType<T> value)? invalidImageType,
    TResult Function(InvalidPassword<T> value)? invalidPassword,
    TResult Function(DescLengthExceeded<T> value)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (invalidEmail != null) {
      return invalidEmail(this);
    }
    return orElse();
  }
}

abstract class InvalidEmail<T> implements ValueFailure<T> {
  const factory InvalidEmail([final T? f]) = _$InvalidEmail<T>;

  @override
  T? get f;
  @override
  @JsonKey(ignore: true)
  _$$InvalidEmailCopyWith<T, _$InvalidEmail<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidImageTypeCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$InvalidImageTypeCopyWith(_$InvalidImageType<T> value,
          $Res Function(_$InvalidImageType<T>) then) =
      __$$InvalidImageTypeCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? f});
}

/// @nodoc
class __$$InvalidImageTypeCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$InvalidImageType<T>>
    implements _$$InvalidImageTypeCopyWith<T, $Res> {
  __$$InvalidImageTypeCopyWithImpl(
      _$InvalidImageType<T> _value, $Res Function(_$InvalidImageType<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? f = freezed,
  }) {
    return _then(_$InvalidImageType<T>(
      freezed == f
          ? _value.f
          : f // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$InvalidImageType<T> implements InvalidImageType<T> {
  const _$InvalidImageType([this.f]);

  @override
  final T? f;

  @override
  String toString() {
    return 'ValueFailure<$T>.invalidImageType(f: $f)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidImageType<T> &&
            const DeepCollectionEquality().equals(other.f, f));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(f));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidImageTypeCopyWith<T, _$InvalidImageType<T>> get copyWith =>
      __$$InvalidImageTypeCopyWithImpl<T, _$InvalidImageType<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? f) bioLengthExceeded,
    required TResult Function(T? f) empty,
    required TResult Function(T? f) invalidEmail,
    required TResult Function(T? f) invalidImageType,
    required TResult Function(T? f) invalidPassword,
    required TResult Function(T? f) descLengthExceeded,
  }) {
    return invalidImageType(f);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? f)? bioLengthExceeded,
    TResult? Function(T? f)? empty,
    TResult? Function(T? f)? invalidEmail,
    TResult? Function(T? f)? invalidImageType,
    TResult? Function(T? f)? invalidPassword,
    TResult? Function(T? f)? descLengthExceeded,
  }) {
    return invalidImageType?.call(f);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? f)? bioLengthExceeded,
    TResult Function(T? f)? empty,
    TResult Function(T? f)? invalidEmail,
    TResult Function(T? f)? invalidImageType,
    TResult Function(T? f)? invalidPassword,
    TResult Function(T? f)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (invalidImageType != null) {
      return invalidImageType(f);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BioLengthExceeded<T> value) bioLengthExceeded,
    required TResult Function(Empty<T> value) empty,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidImageType<T> value) invalidImageType,
    required TResult Function(InvalidPassword<T> value) invalidPassword,
    required TResult Function(DescLengthExceeded<T> value) descLengthExceeded,
  }) {
    return invalidImageType(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidImageType<T> value)? invalidImageType,
    TResult? Function(InvalidPassword<T> value)? invalidPassword,
    TResult? Function(DescLengthExceeded<T> value)? descLengthExceeded,
  }) {
    return invalidImageType?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult Function(Empty<T> value)? empty,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidImageType<T> value)? invalidImageType,
    TResult Function(InvalidPassword<T> value)? invalidPassword,
    TResult Function(DescLengthExceeded<T> value)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (invalidImageType != null) {
      return invalidImageType(this);
    }
    return orElse();
  }
}

abstract class InvalidImageType<T> implements ValueFailure<T> {
  const factory InvalidImageType([final T? f]) = _$InvalidImageType<T>;

  @override
  T? get f;
  @override
  @JsonKey(ignore: true)
  _$$InvalidImageTypeCopyWith<T, _$InvalidImageType<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidPasswordCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$InvalidPasswordCopyWith(_$InvalidPassword<T> value,
          $Res Function(_$InvalidPassword<T>) then) =
      __$$InvalidPasswordCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? f});
}

/// @nodoc
class __$$InvalidPasswordCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$InvalidPassword<T>>
    implements _$$InvalidPasswordCopyWith<T, $Res> {
  __$$InvalidPasswordCopyWithImpl(
      _$InvalidPassword<T> _value, $Res Function(_$InvalidPassword<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? f = freezed,
  }) {
    return _then(_$InvalidPassword<T>(
      freezed == f
          ? _value.f
          : f // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$InvalidPassword<T> implements InvalidPassword<T> {
  const _$InvalidPassword([this.f]);

  @override
  final T? f;

  @override
  String toString() {
    return 'ValueFailure<$T>.invalidPassword(f: $f)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidPassword<T> &&
            const DeepCollectionEquality().equals(other.f, f));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(f));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidPasswordCopyWith<T, _$InvalidPassword<T>> get copyWith =>
      __$$InvalidPasswordCopyWithImpl<T, _$InvalidPassword<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? f) bioLengthExceeded,
    required TResult Function(T? f) empty,
    required TResult Function(T? f) invalidEmail,
    required TResult Function(T? f) invalidImageType,
    required TResult Function(T? f) invalidPassword,
    required TResult Function(T? f) descLengthExceeded,
  }) {
    return invalidPassword(f);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? f)? bioLengthExceeded,
    TResult? Function(T? f)? empty,
    TResult? Function(T? f)? invalidEmail,
    TResult? Function(T? f)? invalidImageType,
    TResult? Function(T? f)? invalidPassword,
    TResult? Function(T? f)? descLengthExceeded,
  }) {
    return invalidPassword?.call(f);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? f)? bioLengthExceeded,
    TResult Function(T? f)? empty,
    TResult Function(T? f)? invalidEmail,
    TResult Function(T? f)? invalidImageType,
    TResult Function(T? f)? invalidPassword,
    TResult Function(T? f)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (invalidPassword != null) {
      return invalidPassword(f);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BioLengthExceeded<T> value) bioLengthExceeded,
    required TResult Function(Empty<T> value) empty,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidImageType<T> value) invalidImageType,
    required TResult Function(InvalidPassword<T> value) invalidPassword,
    required TResult Function(DescLengthExceeded<T> value) descLengthExceeded,
  }) {
    return invalidPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidImageType<T> value)? invalidImageType,
    TResult? Function(InvalidPassword<T> value)? invalidPassword,
    TResult? Function(DescLengthExceeded<T> value)? descLengthExceeded,
  }) {
    return invalidPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult Function(Empty<T> value)? empty,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidImageType<T> value)? invalidImageType,
    TResult Function(InvalidPassword<T> value)? invalidPassword,
    TResult Function(DescLengthExceeded<T> value)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (invalidPassword != null) {
      return invalidPassword(this);
    }
    return orElse();
  }
}

abstract class InvalidPassword<T> implements ValueFailure<T> {
  const factory InvalidPassword([final T? f]) = _$InvalidPassword<T>;

  @override
  T? get f;
  @override
  @JsonKey(ignore: true)
  _$$InvalidPasswordCopyWith<T, _$InvalidPassword<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DescLengthExceededCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$DescLengthExceededCopyWith(_$DescLengthExceeded<T> value,
          $Res Function(_$DescLengthExceeded<T>) then) =
      __$$DescLengthExceededCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? f});
}

/// @nodoc
class __$$DescLengthExceededCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$DescLengthExceeded<T>>
    implements _$$DescLengthExceededCopyWith<T, $Res> {
  __$$DescLengthExceededCopyWithImpl(_$DescLengthExceeded<T> _value,
      $Res Function(_$DescLengthExceeded<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? f = freezed,
  }) {
    return _then(_$DescLengthExceeded<T>(
      freezed == f
          ? _value.f
          : f // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$DescLengthExceeded<T> implements DescLengthExceeded<T> {
  const _$DescLengthExceeded([this.f]);

  @override
  final T? f;

  @override
  String toString() {
    return 'ValueFailure<$T>.descLengthExceeded(f: $f)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DescLengthExceeded<T> &&
            const DeepCollectionEquality().equals(other.f, f));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(f));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DescLengthExceededCopyWith<T, _$DescLengthExceeded<T>> get copyWith =>
      __$$DescLengthExceededCopyWithImpl<T, _$DescLengthExceeded<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? f) bioLengthExceeded,
    required TResult Function(T? f) empty,
    required TResult Function(T? f) invalidEmail,
    required TResult Function(T? f) invalidImageType,
    required TResult Function(T? f) invalidPassword,
    required TResult Function(T? f) descLengthExceeded,
  }) {
    return descLengthExceeded(f);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? f)? bioLengthExceeded,
    TResult? Function(T? f)? empty,
    TResult? Function(T? f)? invalidEmail,
    TResult? Function(T? f)? invalidImageType,
    TResult? Function(T? f)? invalidPassword,
    TResult? Function(T? f)? descLengthExceeded,
  }) {
    return descLengthExceeded?.call(f);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? f)? bioLengthExceeded,
    TResult Function(T? f)? empty,
    TResult Function(T? f)? invalidEmail,
    TResult Function(T? f)? invalidImageType,
    TResult Function(T? f)? invalidPassword,
    TResult Function(T? f)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (descLengthExceeded != null) {
      return descLengthExceeded(f);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BioLengthExceeded<T> value) bioLengthExceeded,
    required TResult Function(Empty<T> value) empty,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidImageType<T> value) invalidImageType,
    required TResult Function(InvalidPassword<T> value) invalidPassword,
    required TResult Function(DescLengthExceeded<T> value) descLengthExceeded,
  }) {
    return descLengthExceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidImageType<T> value)? invalidImageType,
    TResult? Function(InvalidPassword<T> value)? invalidPassword,
    TResult? Function(DescLengthExceeded<T> value)? descLengthExceeded,
  }) {
    return descLengthExceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BioLengthExceeded<T> value)? bioLengthExceeded,
    TResult Function(Empty<T> value)? empty,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidImageType<T> value)? invalidImageType,
    TResult Function(InvalidPassword<T> value)? invalidPassword,
    TResult Function(DescLengthExceeded<T> value)? descLengthExceeded,
    required TResult orElse(),
  }) {
    if (descLengthExceeded != null) {
      return descLengthExceeded(this);
    }
    return orElse();
  }
}

abstract class DescLengthExceeded<T> implements ValueFailure<T> {
  const factory DescLengthExceeded([final T? f]) = _$DescLengthExceeded<T>;

  @override
  T? get f;
  @override
  @JsonKey(ignore: true)
  _$$DescLengthExceededCopyWith<T, _$DescLengthExceeded<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
