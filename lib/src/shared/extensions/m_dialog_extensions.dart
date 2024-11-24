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

  // Future<Note?> showDeleteNoteDialog(Note note) {
  //   return showDialog<Note?>(
  //     context: this,
  //     builder: (context) => DeleteNoteAlertDialog(note: note),
  //   );
  // }

  Future<bool?> showDeleteFolderDialog(Folder folder) {
    return showDialog<bool>(
      context: this,
      builder: (context) => DeleteFolderAlertDialog(
        onDelete: () {},
        folder: folder,
      ),
    );
  }

  // Future<bool?> showRemoveNoteFromFolderDialog(Note note) {
  //   return showDialog<bool>(
  //     context: this,
  //     builder: (context) => RemoveNoteFromFolderAlertDialog(),
  //   );
  // }
}
