import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/application/notes/notes_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/delete_folder_alert_dialog.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/remove_note_from_folder_alert_dialog.dart';
import 'package:meno_fe_v1/src/router/router.dart';

import '../../features/chat/presentation/widgets/delete_comment_alert_dialog.dart';
import '../../features/notes/presentation/widgets/delete_note_alert_dialog.dart';

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
        onDelete: () {
          context.read<NotesBloc>().add(NotesEvent.deleteNote(note));
          context
              .read<FolderListBloc>()
              .add(const FolderListEvent.getAllFolders());
          context.pop();
          context.pop();
        },
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
