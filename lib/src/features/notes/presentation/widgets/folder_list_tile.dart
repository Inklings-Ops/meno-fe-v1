import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile({
    required this.folder,
    super.key,
    this.onTap,
    this.selected = false,
  });

  final Folder folder;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final border = Border.all(
      width: 2,
      color: colors.primary!,
      strokeAlign: BorderSide.strokeAlignOutside,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: Corners.lg,
      child: Container(
        height: 78,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceTint,
          borderRadius: Corners.lg,
          border: selected ? border : null,
        ),
        child: Row(
          children: [
            Skeleton.leaf(
              child: SizedBox(
                height: 46,
                width: 52,
                child: ClipPath(
                  clipper: FolderClipper(r: 8, notch: 4),
                  child: ColoredBox(
                    color: colors.primary!,
                    child: Center(
                      child: Icon(
                        MIcons.file,
                        size: 20,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spaces.horizontalSmall,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MText(
                        folder.title.getOr(),
                        style: textTheme.captionMedium,
                      ),
                    ),
                  ),
                  Spaces.verticalMicro,
                  SizedBox(
                    height: 18,
                    child: MText(
                      '${folder.numberOfNotes ?? 0} notes',
                      style: textTheme.captionRegular,
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

class FolderListTileSkeleton extends StatelessWidget {
  const FolderListTileSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    return Skeletonizer(
      child: Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
        child: Container(
          height: 78,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceTint,
            borderRadius: Corners.lg,
          ),
          child: Row(
            children: [
              Skeleton.leaf(
                child: SizedBox(
                  height: 46,
                  width: 52,
                  child: ClipPath(
                    clipper: FolderClipper(r: 8, notch: 4),
                    child: ColoredBox(
                      color: colors.primary!,
                      child: Center(
                        child: Icon(
                          MIcons.file,
                          size: 20,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spaces.horizontalSmall,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MText(
                          BoneMock.title,
                          style: textTheme.captionMedium,
                        ),
                      ),
                    ),
                    Spaces.verticalMicro,
                    SizedBox(
                      height: 18,
                      child: MText(
                        BoneMock.subtitle,
                        style: textTheme.captionRegular,
                        color: colors.onBackgroundVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
