import 'package:flutter/material.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno_design_system/meno_design_system.dart';

class VerseOptionsModal extends StatelessWidget {
  const VerseOptionsModal._({required this.verse});

  final Verse verse;

  static Future<dynamic> show(BuildContext context, Verse verse) {
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) => VerseOptionsModal._(verse: verse),
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final reference = '${verse.book} ${verse.chapter}:${verse.verse}';
    return MModal(
      title: reference,
      builder: (context) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MModalListTile(leading: Icon(MIcons.send), title: 'Send to chat'),
          Spaces.verticalLarge,
          MModalListTile(leading: Icon(MIcons.copy_06), title: 'Copy verse'),
          Spaces.verticalLarge,
        ],
      ),
    );
  }
}
