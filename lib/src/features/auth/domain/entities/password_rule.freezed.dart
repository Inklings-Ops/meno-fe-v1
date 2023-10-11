// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PasswordRule {
  List<Map> get rules => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PasswordRuleCopyWith<PasswordRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordRuleCopyWith<$Res> {
  factory $PasswordRuleCopyWith(
          PasswordRule value, $Res Function(PasswordRule) then) =
      _$PasswordRuleCopyWithImpl<$Res, PasswordRule>;
  @useResult
  $Res call({List<Map> rules, Color color});
}

/// @nodoc
class _$PasswordRuleCopyWithImpl<$Res, $Val extends PasswordRule>
    implements $PasswordRuleCopyWith<$Res> {
  _$PasswordRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rules = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<Map>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PasswordRuleCopyWith<$Res>
    implements $PasswordRuleCopyWith<$Res> {
  factory _$$_PasswordRuleCopyWith(
          _$_PasswordRule value, $Res Function(_$_PasswordRule) then) =
      __$$_PasswordRuleCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Map> rules, Color color});
}

/// @nodoc
class __$$_PasswordRuleCopyWithImpl<$Res>
    extends _$PasswordRuleCopyWithImpl<$Res, _$_PasswordRule>
    implements _$$_PasswordRuleCopyWith<$Res> {
  __$$_PasswordRuleCopyWithImpl(
      _$_PasswordRule _value, $Res Function(_$_PasswordRule) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rules = null,
    Object? color = null,
  }) {
    return _then(_$_PasswordRule(
      rules: null == rules
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<Map>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$_PasswordRule implements _PasswordRule {
  _$_PasswordRule({required final List<Map> rules, required this.color})
      : _rules = rules;

  final List<Map> _rules;
  @override
  List<Map> get rules {
    if (_rules is EqualUnmodifiableListView) return _rules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rules);
  }

  @override
  final Color color;

  @override
  String toString() {
    return 'PasswordRule(rules: $rules, color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PasswordRule &&
            const DeepCollectionEquality().equals(other._rules, _rules) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_rules), color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PasswordRuleCopyWith<_$_PasswordRule> get copyWith =>
      __$$_PasswordRuleCopyWithImpl<_$_PasswordRule>(this, _$identity);
}

abstract class _PasswordRule implements PasswordRule {
  factory _PasswordRule(
      {required final List<Map> rules,
      required final Color color}) = _$_PasswordRule;

  @override
  List<Map> get rules;
  @override
  Color get color;
  @override
  @JsonKey(ignore: true)
  _$$_PasswordRuleCopyWith<_$_PasswordRule> get copyWith =>
      throw _privateConstructorUsedError;
}
