import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile({
    super.key,
    required this.folder,
    this.onTap,
    this.selected = false,
  });

  final Folder folder;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final border = Border.all(
      width: 2.toScale,
      color: colors.primary!,
      strokeAlign: BorderSide.strokeAlignOutside,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: $styles.radius.large,
      child: Container(
        height: 78.toScale,
        padding: const EdgeInsets.all(16).radius,
        decoration: BoxDecoration(
          color: colors.surfaceTint,
          borderRadius: $styles.radius.large,
          border: selected ? border : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 46.toScale,
              width: 52.toScale,
              child: ClipPath(
                clipper: FolderClipper(r: 8.toScale, notch: 4.toScale),
                child: ColoredBox(
                  color: colors.primary!,
                  child: Center(
                    child: Icon(MIcons.file, size: 20.toScale),
                  ),
                ),
              ),
            ),
            $styles.spaces.horizontalSmall,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.toScale,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MText(
                        folder.title.getOr(),
                        style: $styles.text.captionMedium,
                      ),
                    ),
                  ),
                  $styles.spaces.verticalMicro,
                  SizedBox(
                    height: 18.toScale,
                    child: MText(
                      '${folder.numberOfNotes ?? 0} notes',
                      style: $styles.text.captionRegular,
                      color: colors.onBackgroundVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
