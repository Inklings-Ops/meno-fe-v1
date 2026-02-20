import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:meno/features/notes/domain/entities/note.dart';
import 'package:meno/shared/domain/value_objects/multi_line_string.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    required this.note,
    required this.onTap,
    required this.onOptionsTap,
    super.key,
    this.showAddButton = false,
    this.selected = false,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onOptionsTap;
  final bool showAddButton;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final content = _getContent(note.content);

    final timeStamp = note.updatedAt ?? note.createdAt ?? DateTime.now();
    final formattedDate = DateFormat('d MMM yyyy').format(timeStamp);
    final formattedTime = DateFormat('h:mm a').format(timeStamp);

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
                        note.title.getOrCrash(),
                        style: textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spaces.verticalSmall,
                      if (note.folder != null) ...[
                        Skeleton.leaf(
                          child: Row(
                            children: [
                              MTag(
                                title: note.folder!.title.getOrCrash(),
                                style: textTheme.microMedium,
                              ),
                            ],
                          ),
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
                  SizedBox.square(
                    dimension: 16,
                    child: IconButton(
                      icon: const Icon(MIcons.dots_vertical),
                      padding: EdgeInsets.zero,
                      color: colors.onDisabledContainer,
                      iconSize: 20,
                      onPressed: onOptionsTap,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _getContent(MultiLineString content) {
  String value;
  try {
    final json = content.getOrCrash();
    value = Document.fromJson(jsonDecode(json) as List<dynamic>).toPlainText();
  } catch (e) {
    value = BoneMock.longParagraph;
  }
  return value;
}
