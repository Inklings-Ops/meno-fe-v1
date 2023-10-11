// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$User {
  /// The user's unique identifier.
  String get id => throw _privateConstructorUsedError;

  /// The user's full name.
  IFullName get fullName => throw _privateConstructorUsedError;

  /// The user's email address.
  IEmail get email => throw _privateConstructorUsedError;

  /// The user's bio.
  IBio? get bio => throw _privateConstructorUsedError;

  /// The type of email account the user uses.
  String? get emailAccountType => throw _privateConstructorUsedError;

  /// Whether the user's email address has been verified.
  bool get verified => throw _privateConstructorUsedError;

  /// The ID of the user's profile image.
  String? get imageId => throw _privateConstructorUsedError;

  /// The URL of the user's profile image.
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Whether the user has been deleted.
  dynamic get deleted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      IFullName fullName,
      IEmail email,
      IBio? bio,
      String? emailAccountType,
      bool verified,
      String? imageId,
      String? imageUrl,
      dynamic deleted});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? bio = freezed,
    Object? emailAccountType = freezed,
    Object? verified = null,
    Object? imageId = freezed,
    Object? imageUrl = freezed,
    Object? deleted = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as IFullName,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as IEmail,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as IBio?,
      emailAccountType: freezed == emailAccountType
          ? _value.emailAccountType
          : emailAccountType // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      imageId: freezed == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deleted: freezed == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      IFullName fullName,
      IEmail email,
      IBio? bio,
      String? emailAccountType,
      bool verified,
      String? imageId,
      String? imageUrl,
      dynamic deleted});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? bio = freezed,
    Object? emailAccountType = freezed,
    Object? verified = null,
    Object? imageId = freezed,
    Object? imageUrl = freezed,
    Object? deleted = freezed,
  }) {
    return _then(_$_User(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as IFullName,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as IEmail,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as IBio?,
      emailAccountType: freezed == emailAccountType
          ? _value.emailAccountType
          : emailAccountType // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      imageId: freezed == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deleted: freezed == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$_User implements _User {
  _$_User(
      {required this.id,
      required this.fullName,
      required this.email,
      this.bio,
      this.emailAccountType,
      required this.verified,
      this.imageId,
      this.imageUrl,
      this.deleted});

  /// The user's unique identifier.
  @override
  final String id;

  /// The user's full name.
  @override
  final IFullName fullName;

  /// The user's email address.
  @override
  final IEmail email;

  /// The user's bio.
  @override
  final IBio? bio;

  /// The type of email account the user uses.
  @override
  final String? emailAccountType;

  /// Whether the user's email address has been verified.
  @override
  final bool verified;

  /// The ID of the user's profile image.
  @override
  final String? imageId;

  /// The URL of the user's profile image.
  @override
  final String? imageUrl;

  /// Whether the user has been deleted.
  @override
  final dynamic deleted;

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, bio: $bio, emailAccountType: $emailAccountType, verified: $verified, imageId: $imageId, imageUrl: $imageUrl, deleted: $deleted)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.emailAccountType, emailAccountType) ||
                other.emailAccountType == emailAccountType) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other.deleted, deleted));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullName,
      email,
      bio,
      emailAccountType,
      verified,
      imageId,
      imageUrl,
      const DeepCollectionEquality().hash(deleted));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);
}

abstract class _User implements User {
  factory _User(
      {required final String id,
      required final IFullName fullName,
      required final IEmail email,
      final IBio? bio,
      final String? emailAccountType,
      required final bool verified,
      final String? imageId,
      final String? imageUrl,
      final dynamic deleted}) = _$_User;

  @override

  /// The user's unique identifier.
  String get id;
  @override

  /// The user's full name.
  IFullName get fullName;
  @override

  /// The user's email address.
  IEmail get email;
  @override

  /// The user's bio.
  IBio? get bio;
  @override

  /// The type of email account the user uses.
  String? get emailAccountType;
  @override

  /// Whether the user's email address has been verified.
  bool get verified;
  @override

  /// The ID of the user's profile image.
  String? get imageId;
  @override

  /// The URL of the user's profile image.
  String? get imageUrl;
  @override

  /// Whether the user has been deleted.
  dynamic get deleted;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
