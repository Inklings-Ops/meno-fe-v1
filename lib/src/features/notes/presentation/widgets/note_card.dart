import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

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

    final json = jsonDecode(note.content.getOr());
    final content = Document.fromJson(json).toPlainText();

    final formattedDate = DateFormat('d MMM yyyy').format(note.createdAt!);
    final formattedTime = DateFormat('h:mm a').format(note.createdAt!);

    final noteFolder = note.folder ?? folder;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightForFinite(),
      child: InkWell(
        onTap: onTap,
        borderRadius: $styles.radius.large,
        child: Card(
          color: colors.surfaceTint,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: $styles.radius.large),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16).radius,
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
                        note.title.getOr(),
                        style: $styles.text.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      $styles.spaces.verticalSmall,
                      if (noteFolder != null) ...[
                        Row(
                          children: [
                            MTag(
                              title: noteFolder.title.getOr(),
                              style: $styles.text.microMedium,
                              height: 20.toScale,
                            ),
                          ],
                        ),
                        $styles.spaces.verticalSmall,
                      ],
                      MText(
                        content,
                        style: $styles.text.captionRegular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      14.vSpace,
                      Wrap(
                        spacing: $styles.insets.small,
                        children: [
                          MText(
                            formattedDate,
                            style: $styles.text.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            '•',
                            style: $styles.text.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            formattedTime,
                            style: $styles.text.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                $styles.spaces.horizontalSmall,
                if (showAddButton)
                  SizedBox.square(
                    dimension: $styles.insets.large,
                    child: Icon(
                      selected ? Icons.check_circle : MIcons.plus_circle,
                      size: 20.toScale,
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

    return SizedBox.square(
      dimension: 16.toScale,
      child: IconButton(
        icon: const Icon(MIcons.dots_vertical),
        padding: EdgeInsets.zero,
        color: colors.onDisabledContainer,
        iconSize: 20.toScale,
        onPressed: () {
          context.showModal(
            NoteCardOptionsModal(note: note),
            useRootNavigator: true,
          );
        },
      ),
    );
  }
}
