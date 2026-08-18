import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class Destination with EquatableMixin {
  const Destination({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  List<Object?> get props => [icon, label];
}
