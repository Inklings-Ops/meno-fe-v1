import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatMessageOptionsModal extends StatelessWidget {
  const ChatMessageOptionsModal._({
    required this.message,
    this.isHost = false,
    this.isIAmSender = false,
    super.key,
  });

  /// The currently selected message
  final Message message;

  /// Whether the message was sent by the current user
  final bool isHost;

  /// Whether the message was sent by the current user
  final bool isIAmSender;

  static Future<dynamic> show(
    BuildContext context, {
    required Message message,
    bool isHost = false,
    bool isIAmSender = false,
  }) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (ctx) => ChatMessageOptionsModal._(
        key: ObjectKey(message),
        message: message,
        isHost: isHost,
        isIAmSender: isIAmSender,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return MModal(
      title: isIAmSender ? 'My Comment' : "User's Comment",
      builder: (context) => Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        spacing: Insets.lg,
        children: [
          if (message.isEditable)
            MModalListTile(
              leading: const Icon(MIcons.edit_05),
              title: 'Edit',
              onTap: () {
                di<ChatManager>().startEditing.run(message);
                context.pop<void>();
              },
            ),
          if ((isHost || isIAmSender) && message.isDeletable)
            MModalListTile(
              leading: Icon(MIcons.trash, color: colors.error),
              title: 'Delete',
              onTap: () async => handleDeleteMessage(context),
              titleColor: colors.error,
            ),
          if (!isIAmSender)
            MModalListTile(
              leading: const Icon(Icons.flag),
              title: 'Report',
              onTap: () {},
            ),
        ],
      ),
    );
  }

  Future<void> handleDeleteMessage(BuildContext context) async {
    final result = await DeleteCommentAlertDialog.show(context);
    if (result == false) return;
    if (context.mounted) di<ChatListManager>().deleteMessage.run(message);
  }
}
