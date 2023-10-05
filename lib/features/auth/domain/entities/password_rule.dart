import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_rule.freezed.dart';

@freezed
class PasswordRule with _$PasswordRule {
  factory PasswordRule({
    required List<Map> rules,
    required Color color,
  }) = _PasswordRule;
}
