import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import 'note_card_options_modal.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.showAddButton = false,
    this.selected = false,
    this.folder,
  });

  final Note note;
  final VoidCallback onTap;
  final bool showAddButton;
  final bool selected;
  final Folder? folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final json = jsonDecode(note.content.get()!);
    final content = Document.fromJson(json).toPlainText();

    final formattedDate = DateFormat('d MMM yyyy').format(note.createdAt!);
    final formattedTime = DateFormat('h:mm a').format(note.createdAt!);

    final noteFolder = note.folder ?? folder;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightForFinite(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MCore.large).r,
        child: Card(
          color: colors.surfaceTint,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MCore.large).r,
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(MCore.large).r,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MText(
                        note.title.get()!,
                        style: MTextStyle.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      MCore.small.verticalSpace,
                      if (noteFolder != null) ...[
                        Row(
                          children: [
                            MTag(
                              title: noteFolder.title.get()!,
                              style: MTextStyle.microMedium,
                              height: 20.h,
                            ),
                          ],
                        ),
                        MCore.small.verticalSpace,
                      ],
                      MText(
                        content,
                        style: MTextStyle.captionRegular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      14.verticalSpace,
                      Wrap(
                        spacing: MCore.small.r,
                        children: [
                          MText(
                            formattedDate,
                            style: MTextStyle.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            '•',
                            style: MTextStyle.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            formattedTime,
                            style: MTextStyle.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                MCore.small.horizontalSpace,
                if (showAddButton)
                  SizedBox.square(
                    dimension: 16.r,
                    child: Icon(
                      selected ? Icons.check_circle : MIcons.plus_circle,
                      size: 20.r,
                    ),
                  )
                else
                  _MoreButton(note: note.copyWith(folder: folder)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      width: 16.r,
      height: 16.r,
      child: IconButton(
        icon: const Icon(MIcons.dots_vertical),
        padding: EdgeInsets.zero,
        color: colors.onDisabledContainer,
        iconSize: 20.r,
        onPressed: () {
          Logger().w(note);
          context.showModal(
            NoteCardOptionsModal(note: note),
            useRootNavigator: true,
          );
        },
      ),
    );
  }
}
