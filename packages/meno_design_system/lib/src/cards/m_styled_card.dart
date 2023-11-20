import 'package:flutter/material.dart';

abstract class MStyledCard extends StatelessWidget {
  final Widget child;
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  const MStyledCard({
    super.key,
    required this.child,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => child;
}
