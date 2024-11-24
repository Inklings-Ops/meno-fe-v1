import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({super.key, this.showAddButton = false});

  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NotesBloc>();
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => RefreshIndicator.adaptive(
        onRefresh: () async => bloc.add(const GetNotesRequested()),
        child: state.maybeWhen(
          orElse: () => const NotesListSkeleton(),
          failure: (failure) => const NoteListFailureWidget(),
          loadSuccess: (notes) {
            if (notes.isEmpty) return const EmptyNoteListWidget();
            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Insets.lg),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notes.length,
              separatorBuilder: (context, index) => Spaces.verticalLarge,
              itemBuilder: (context, index) {
                final note = notes[index]!;
                return NoteCard(
                  note: note,
                  showAddButton: showAddButton,
                  onTap: () async {
                    final bloc = context.read<NotesBloc>();
                    final newNote = await router.push<Note?>(
                      Routes.noteEditor,
                      extra: note,
                    );
                    if (newNote != null) return bloc.add(NoteReceived(newNote));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NotesListSkeleton extends StatelessWidget {
  const NotesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 1,
      padding: const EdgeInsets.all(Insets.lg),
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        final colors = MColorScheme.of(context)!;
        final textTheme = MTextTheme.of(context)!;
        return Skeletonizer(
          child: Container(
            padding: const EdgeInsets.all(Insets.lg),
            constraints: const BoxConstraints.tightForFinite(height: 160),
            decoration: BoxDecoration(
              color: colors.surfaceTint,
              borderRadius: Corners.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rabbi: The need for a Bible Teacher',
                        style: textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spaces.verticalSmall,
                      MText(
                        '''Romans 12:2 Allow the will of God for your life and for you to allow, you need to know the will of God.''',
                        style: textTheme.captionRegular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spaces.verticalSmall,
                      const Skeleton.leaf(
                        child: Row(
                          children: [MTag(title: "Believer's Authority")],
                        ),
                      ),
                      Spaces.verticalSmall,
                      Wrap(
                        spacing: Insets.sm,
                        children: [
                          MText(
                            '09 Mar, 2023',
                            style: textTheme.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            '•',
                            style: textTheme.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                          MText(
                            '9:00 AM',
                            style: textTheme.captionRegular,
                            color: colors.onBackgroundVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spaces.horizontalSmall,
                const Icon(MIcons.dots_vertical),
              ],
            ),
          ),
        );
      },
    );
  }
}
