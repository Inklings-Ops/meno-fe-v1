import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/chat/manager/chat_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EditingMessageWidget extends WatchingWidget {
  const EditingMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final messageToEdit = watchValue((ChatManager m) => m.messageToEdit);
    if (messageToEdit == null) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(maxHeight: 80),
      width: double.infinity,
      padding: const .fromLTRB(16, 8, 16, 8),
      color: colors.disabledContainer,
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: Border(
                left: BorderSide(color: colors.secondary, width: 8),
              ),
              child: Padding(
                padding: const .fromLTRB(24, 4, 24, 4),
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .stretch,
                  children: [
                    MText(
                      'You',
                      style: textTheme.captionMedium,
                      color: colors.informational,
                    ),
                    Spaces.verticalMicro,
                    MText(
                      messageToEdit.content.getOrCrash(),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spaces.horizontalSmall,
          IconButton(
            onPressed: di<ChatManager>().stopEditing.run,
            icon: const Icon(MIcons.x_close),
          ),
        ],
      ),
    );
  }
}
