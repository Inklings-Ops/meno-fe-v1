import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderListFailureWidget extends StatelessWidget {
  const FolderListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Column(
      children: [
        72.vSpace,
        MText(
          'An error occurred while retrieving the folders. Please, reload to try again?',
          style: $styles.text.bodyRegular,
          textAlign: TextAlign.center,
        ),
        24.vSpace,
        SizedBox(
          height: 32.toScale,
          child: MSecondaryButton.icon(
            label: 'Reload',
            icon: const Icon(Icons.refresh),
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
            onPressed: () => context
                .read<FolderListBloc>()
                .add(const FolderListEvent.getAllFolders()),
          ),
        )
      ],
    );
  }
}
