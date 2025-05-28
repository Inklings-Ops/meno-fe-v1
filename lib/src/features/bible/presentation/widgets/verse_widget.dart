import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class VerseWidget extends StatelessWidget {
  const VerseWidget({required this.verse, super.key});
  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    final reference = '${verse.book} ${verse.chapter}:${verse.verse}';
    return GestureDetector(
      onTap: () {
        context.showModal<void>(
          MModal(
            title: reference,
            builder: (context) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MModalListTile(
                  leading: Icon(MIcons.send),
                  title: 'Send to chat',
                ),
                Spaces.verticalLarge,
                MModalListTile(
                  leading: Icon(MIcons.copy_06),
                  title: 'Copy verse',
                ),
                Spaces.verticalLarge,
              ],
            ),
          ),
          useRootNavigator: true,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: Corners.circle,
              color: colors.primaryContainer,
            ),
            child: MText(
              reference,
              style: textTheme.microMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Spaces.verticalMicro,
          MText(verse.text, style: textTheme.bodyRegular),
        ],
      ),
    );
  }
}
