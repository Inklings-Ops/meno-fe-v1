import 'package:meno_fe_v1/meno.dart';

class EmptyNoteListWidget extends StatelessWidget {
  const EmptyNoteListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 266.toScale,
      height: 224.toScale,
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120.toScale, width: 160.toScale),
          MText(
            'Welcome! Start writing down everything you take in.',
            style: $styles.text.bodyRegular,
            textAlign: TextAlign.center,
          ),
          24.vSpace,
          const AddNewNoteButton(),
        ],
      ),
    );
  }
}

class AddNewNoteButton extends StatelessWidget {
  const AddNewNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      width: 139.toScale,
      height: 32.toScale,
      child: MSecondaryButton.icon(
        label: 'Add New Note',
        icon: const Icon(MIcons.plus),
        style: OutlinedButton.styleFrom(
          textStyle: $styles.text.microMedium,
          foregroundColor: colors.onBackground,
          iconColor: colors.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: $styles.radius.small,
          ),
          side: BorderSide(
            color: colors.outlineVariant3!,
            width: 1.50.toScale,
          ),
        ),
        onPressed: () => context.push(Routes.noteEditor),
      ),
    );
  }
}
