import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

extension MDialogX on BuildContext {
  Future<void> showLoadingDialog() {
    return showDialog(
      context: this,
      builder: (context) => const MLoadingIndicator.box(),
    );
  }

  Future<bool?> showEndBroadcastDialog() {
    return showDialog<bool>(
      context: this,
      builder: (_) => const BroadcastExitAlertDialog(),
    );
  }

  Future<bool?> showLeaveBroadcastDialog() {
    return showDialog<bool>(
      context: this,
      builder: (_) => const BroadcastExitAlertDialog(isBroadcasting: false),
    );
  }

  Future<bool?> showDeleteCommentDialog() {
    return showDialog<bool>(
      context: this,
      builder: (context) => const DeleteCommentAlertDialog(),
    );
  }

  Future<bool?> showDeleteNoteDialog(Note note) {
    return showDialog<bool>(
      context: this,
      builder: (context) => DeleteNoteAlertDialog(
        onDelete: () => context
          ..read<NotesBloc>().add(NotesEvent.deleteNote(note))
          ..read<FolderListBloc>().add(const FolderListEvent.getAllFolders())
          ..pop()
          ..pop(),
      ),
    );
  }

  Future<bool?> showDeleteFolderDialog(Folder f) {
    return showDialog<bool>(
      context: this,
      builder: (context) => BlocListener<FolderListBloc, FolderListState>(
        listenWhen: (c, p) => p != c,
        listener: (context, state) => state.whenOrNull(
          success: (folders) => context.go(Routes.notes),
        ),
        child: DeleteFolderAlertDialog(
          onDelete: () {
            context.read<FolderListBloc>().add(FolderListEvent.deleteFolder(f));
          },
        ),
      ),
    );
  }

  Future<bool?> showRemoveNoteFromFolderDialog(Note note) {
    return showDialog<bool>(
      context: this,
      builder: (context) => BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          // state.whenOrNull(
          //   success: (_) {
          //     context
          //         .read<FolderListBloc>()
          //         .add(const FolderListEvent.getAllFolders());
          //     context.pop();
          //     context.pop();
          //   },
          // );
        },
        child: DeleteNoteFromFolderAlertDialog(
          onDelete: () => context
              .read<NotesBloc>()
              .add(NotesEvent.removeFromFolder(note.folder!, note)),
        ),
      ),
    );
  }
}
