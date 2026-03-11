import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/chat/manager/_manager.dart';
import 'package:meno/features/chat/model/_model.dart';
import 'package:meno/features/chat/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatMessageOptionsModal extends StatelessWidget {
  const ChatMessageOptionsModal._({
    required this.message,
    this.isHost = false,
    this.isSentByMe = false,
    super.key,
  });

  /// The currently selected message
  final MessageProxy message;

  /// Whether the message was sent by the current user
  final bool isHost;

  final bool isSentByMe;

  static Future<dynamic> show(
    BuildContext context, {
    required MessageProxy message,
    bool isHost = false,
    bool isSentByMe = false,
  }) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (ctx) => ChatMessageOptionsModal._(
        key: ObjectKey(message),
        message: message,
        isHost: isHost,
        isSentByMe: isSentByMe,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return MModal(
      title: isSentByMe ? 'My Comment' : "User's Comment",
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
                di<ChatManager>().startEditing.run(message.target);
                context.pop<void>();
              },
            ),
          if ((isHost || isSentByMe) && message.isDeletable)
            MModalListTile(
              leading: Icon(MIcons.trash, color: colors.error),
              title: 'Delete',
              onTap: () async => handleDeleteMessage(context),
              titleColor: colors.error,
            ),
          if (!isSentByMe)
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
    if (context.mounted) message.deleteMessage.run();
  }
}
