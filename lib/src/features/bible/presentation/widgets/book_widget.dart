import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BookWidget extends StatelessWidget {
  final String bookName;
  final VoidCallback? onTap;
  const BookWidget({super.key, required this.bookName, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return ListTile(
      title: MText(bookName),
      titleTextStyle: MTextStyle.bodyRegular,
      contentPadding: const EdgeInsets.symmetric(horizontal: MCore.medium),
      trailing: const Icon(MIcons.plus, size: 20),
      tileColor: colorScheme.outlineVariant2,
      minVerticalPadding: MCore.large,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
    );
  }
}
