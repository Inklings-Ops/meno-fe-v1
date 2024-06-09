import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder_clipper.dart';

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
      width: 2.r,
      color: colors.primary!,
      strokeAlign: BorderSide.strokeAlignOutside,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MCore.large).r,
      child: Container(
        height: 78.h,
        padding: const EdgeInsets.all(MCore.large).r,
        decoration: BoxDecoration(
          color: colors.surfaceTint,
          borderRadius: BorderRadius.circular(MCore.large).r,
          border: selected ? border : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 46.h,
              width: 52.w,
              child: ClipPath(
                clipper: FolderClipper(r: 8.r, notch: 4),
                child: ColoredBox(
                  color: colors.primary!,
                  child: Center(
                    child: Icon(MIcons.file, size: 20.r),
                  ),
                ),
              ),
            ),
            MCore.small.horizontalSpace,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.h,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MText(
                        folder.title.get()!,
                        style: MTextStyle.captionMedium,
                      ),
                    ),
                  ),
                  MCore.micro.verticalSpace,
                  MText(
                    '${folder.numberOfNotes ?? 0} notes',
                    style: MTextStyle.captionRegular,
                    color: colors.onBackgroundVariant,
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
