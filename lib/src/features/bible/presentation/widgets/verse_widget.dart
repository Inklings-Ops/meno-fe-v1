import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class VerseWidget extends StatelessWidget {
  const VerseWidget({super.key, required this.verse});
  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final reference = '${verse.book} ${verse.chapter}:${verse.verse}';

    return GestureDetector(
      onTap: () {
        context.showModal(
          MModal(
            title: reference,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MModalListTile(
                  leading: Icon(MIcons.send),
                  title: 'Send to chat',
                ),
                $styles.spaces.verticalLarge,
                const MModalListTile(
                  leading: Icon(MIcons.copy_06),
                  title: 'Copy verse',
                ),
                $styles.spaces.verticalLarge,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4).radius,
            decoration: BoxDecoration(
              borderRadius: $styles.radius.circle,
              color: colors.primaryContainer,
            ),
            child: MText(
              reference,
              style: $styles.text.microMedium,
              textAlign: TextAlign.center,
            ),
          ),
          $styles.spaces.verticalMicro,
          MText(verse.text, style: $styles.text.bodyRegular),
        ],
      ),
    );
  }
}
