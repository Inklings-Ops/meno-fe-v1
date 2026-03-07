import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:timeago/timeago.dart' as timeago;

class BroadcastDraftModal extends WatchingWidget {
  const BroadcastDraftModal._({
    required this.onDraftSelected,
    required this.onCreateNew,
  }) : super(key: null);

  final ValueChanged<BroadcastDraft> onDraftSelected;
  final VoidCallback onCreateNew;

  static Future<dynamic> show(
    BuildContext context, {
    required ValueChanged<BroadcastDraft> onDraftSelected,
    required VoidCallback onCreateNew,
  }) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      builder: (context) => BroadcastDraftModal._(
        onDraftSelected: onDraftSelected,
        onCreateNew: onCreateNew,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final colors = MColorScheme.of(context);

    final manager = di<BroadcastEditorManager>();
    final drafts = watchValue((BroadcastEditorManager m) => m.drafts);

    return MModal(
      title: 'Resume or Create New',
      builder: (context) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const .symmetric(vertical: Insets.lg),
              itemCount: drafts.length + 1,
              separatorBuilder: (_, __) => Spaces.verticalLarge,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return MText(
                    '''You have ${drafts.length} saved draft${drafts.length == 1 ? '' : 's'}''',
                    style: textTheme.captionRegular.copyWith(
                      color: colors.onBackgroundVariant,
                    ),
                  );
                }

                final draft = drafts[index - 1];
                if (draft == null) return const SizedBox.shrink();

                return _DraftItem(
                  key: ValueKey(draft.id),
                  draft: draft,
                  onTap: () {
                    Navigator.pop(context);
                    onDraftSelected(draft);
                  },
                  onDelete: () async {
                    final confirmed = await _showDeleteConfirmation(context);
                    if (confirmed ?? false) manager.deleteDraft.run(draft.id);
                  },
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Create new button
          Padding(
            padding: const .only(top: 16),
            child: MPrimaryButton(
              label: 'Create New Broadcast',
              onPressed: () {
                Navigator.pop(context);
                onCreateNew();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: MText('Delete Draft?', style: textTheme.heading3Medium),
        content: MText(
          'This draft will be permanently deleted. This cannot be undone.',
          style: textTheme.bodyRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: MText('Cancel', color: colors.onBackgroundVariant),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: MText('Delete', color: colors.error),
          ),
        ],
      ),
    );
  }
}

class _DraftItem extends StatelessWidget {
  const _DraftItem({
    required this.draft,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final BroadcastDraft draft;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final colors = MColorScheme.of(context);

    final imageFile = draft.image?.getFile();
    final hasPartialCreation = draft.hasPartialCreation;

    return Dismissible(
      key: ValueKey(draft.id),
      direction: .endToStart,
      confirmDismiss: (direction) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const .only(right: 20),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: .circular(8),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(Icons.delete_outline, color: colors.onError, size: 24),
            const SizedBox(height: 4),
            MText(
              'Delete',
              style: textTheme.microMedium.copyWith(color: colors.onError),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(8),
        child: Container(
          padding: const .symmetric(horizontal: Insets.sm, vertical: Insets.lg),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(8),
          ),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 79,
                height: 64,
                decoration: ShapeDecoration(
                  color: colors.disabled,
                  shape: RoundedSuperellipseBorder(
                    borderRadius: .circular(Insets.md),
                  ),
                  image: imageFile != null
                      ? DecorationImage(
                          image: FileImage(imageFile),
                          fit: .cover,
                        )
                      : null,
                ),
                child: imageFile == null
                    ? Icon(
                        Icons.mic_rounded,
                        color: colors.onBackgroundVariant,
                        size: 24,
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MText(
                            draft.title.getOrCrash().isEmpty
                                ? 'Untitled Broadcast'
                                : draft.title.getOrCrash(),
                            style: textTheme.captionMedium,
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                        ),
                        if (hasPartialCreation) ...[
                          const SizedBox(width: 8),
                          _CreationStepBadge(step: draft.creationStep),
                        ],
                      ],
                    ),
                    Spaces.verticalMicro,
                    MText(
                      draft.description.getOrCrash().isEmpty
                          ? 'No description'
                          : draft.description.getOrCrash(),
                      style: textTheme.captionRegular,
                      color: colors.onBackgroundVariant,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    Spaces.verticalMicro,
                    MText(
                      'Last edited ${timeago.format(draft.lastModified)}',
                      style: textTheme.microRegular,
                      color: colors.onBackgroundVariant,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.onBackgroundVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreationStepBadge extends StatelessWidget {
  const _CreationStepBadge({required this.step});

  final BroadcastCreationStep step;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final (label, color) = switch (step) {
      BroadcastCreationStep.created => ('Created', colors.warning),
      BroadcastCreationStep.started => ('Started', colors.tertiary),
      BroadcastCreationStep.saved => ('Ready', colors.success),
      _ => ('', Colors.transparent),
    };

    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: .circular(4),
      ),
      child: MText(label, style: textTheme.microMedium.copyWith(color: color)),
    );
  }
}
