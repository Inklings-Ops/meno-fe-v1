import 'package:meno_fe_v1/meno.dart';

class EmptyNoteListWidget extends StatelessWidget {
  const EmptyNoteListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      width: 266,
      height: 224,
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120, width: 160),
          MText(
            'Welcome! Start writing down everything you take in.',
            style: textTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalXLarge,
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
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      width: 139,
      height: 32,
      child: MSecondaryButton.icon(
        label: 'Add New Note',
        icon: const Icon(MIcons.plus),
        style: OutlinedButton.styleFrom(
          textStyle: textTheme.microMedium,
          foregroundColor: colors.onBackground,
          iconColor: colors.onBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.sm,
          ),
          side: BorderSide(
            color: colors.outlineVariant3!,
            width: 1.50,
          ),
        ),
        onPressed: () => router.push(Routes.noteEditor),
      ),
    );
  }
}
