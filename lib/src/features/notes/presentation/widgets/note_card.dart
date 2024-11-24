import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    required this.note,
    required this.onTap,
    super.key,
    this.showAddButton = false,
    this.selected = false,
  });

  final Note note;
  final VoidCallback onTap;
  final bool showAddButton;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final json = jsonDecode(note.content.getOr()) as List<dynamic>;
    final content = Document.fromJson(json).toPlainText();


    final formattedDate =
        DateFormat('d MMM yyyy').format(note.updatedAt ?? note.createdAt!);
        
    final formattedTime =
        DateFormat('h:mm a').format(note.updatedAt ?? note.createdAt!);

    return ConstrainedBox(
      constraints: const BoxConstraints.tightForFinite(),
      child: InkWell(
        onTap: onTap,
        borderRadius: Corners.lg,
        child: Card(
          color: colors.surfaceTint,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MText(
                        note.title.getOr(),
                        style: textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spaces.verticalSmall,
                      if (note.folder != null) ...[
                        Row(
                          children: [
                            MTag(
                              title: note.folder!.title.getOr(),
                              style: textTheme.microMedium,
                            ),
                          ],
                        ),
                        Spaces.verticalSmall,
                      ],
                      MText(
                        content,
                        style: textTheme.captionRegular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: Insets.sm,
                        children: [
                          MText(
                            formattedDate,
                            style: textTheme.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            '•',
                            style: textTheme.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            formattedTime,
                            style: textTheme.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spaces.horizontalSmall,
                if (showAddButton)
                  SizedBox.square(
                    dimension: Insets.lg,
                    child: Icon(
                      selected ? Icons.check_circle : MIcons.plus_circle,
                      size: 20,
                    ),
                  )
                else
                  _MoreButton(note: note),
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
      dimension: 16,
      child: IconButton(
        icon: const Icon(MIcons.dots_vertical),
        padding: EdgeInsets.zero,
        color: colors.onDisabledContainer,
        iconSize: 20,
        onPressed: () => router.push(Routes.noteCardOptionsModal, extra: note),
      ),
    );
  }
}
