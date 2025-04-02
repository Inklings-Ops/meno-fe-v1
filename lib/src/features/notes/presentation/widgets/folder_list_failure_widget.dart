import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderListFailureWidget extends StatelessWidget {
  const FolderListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 72),
        MText(
          'An error occurred while retrieving the folders. Please, try again?',
          style: textTheme.bodyRegular,
          textAlign: TextAlign.center,
        ),
        Spaces.verticalXLarge,
        SizedBox(
          height: 32,
          child: MSecondaryButton.icon(
            label: 'Reload',
            icon: const Icon(Icons.refresh),
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
            onPressed: () {
              context.read<FoldersBloc>().add(const GetFoldersRequested());
            },
          ),
        ),
      ],
    );
  }
}
