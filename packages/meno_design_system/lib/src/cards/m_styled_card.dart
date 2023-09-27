import 'package:flutter/material.dart';

abstract class MStyledCard extends StatelessWidget {
  final Widget child;
  final String? imageUrl;
  final String title;
  final String? subtitle;

  const MStyledCard({
    super.key,
    required this.child,
    this.imageUrl,
    required this.title,
 this.subtitle,
  });

  @override
  Widget build(BuildContext context) => child;
}
