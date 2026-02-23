import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/presentation/widgets/error_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddNotesToFolderModal extends WatchingWidget {
  const AddNotesToFolderModal({required this.folder, super.key});

  final NoteFolder folder;

  static Future<dynamic> show(
    BuildContext context, {
    required NoteFolder folder,
  }) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      builder: (context) => AddNotesToFolderModal(folder: folder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = watchStream((INotesRepository repo) => repo.watchNotes());

    Widget child = const SizedBox.shrink();

    final isLoading = snapshot.connectionState == ConnectionState.waiting;
    final hasError = snapshot.hasError;

    if (isLoading) {
      child = Expanded(
        child: Skeletonizer(
          child: NotesList(
            notes: fakeNotes,
            padding: .zero,
            showAddButton: true,
          ),
        ),
      );
    }

    if (hasError) {
      child = MenoErrorWidget(error: snapshot.error);
    }

    if (snapshot.hasData) {
      final notes = snapshot.data?.where((n) => n.folder == null).toList();
      child = Expanded(
        child: NotesList(
          notes: notes ?? [],
          padding: .zero,
          showAddButton: true,
        ),
      );
    }

    return MModal(
      title: 'Add to Folder',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spaces.verticalLarge,
          child,
          if (!isLoading && !hasError) ...[
            Spaces.verticalLarge,
            MPrimaryButton(label: 'Done', onPressed: () {}),
          ],
        ],
      ),
    );
  }
}
