import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/application.dart';
import 'package:meno_fe_v1/src/features/chat/application/chat_notifier.dart';
import 'package:meno_fe_v1/src/features/chat/domain/domain.dart';

import 'reactions.dart';

class ChatInputContainer extends HookConsumerWidget {
  final ScrollController scrollController;
  const ChatInputContainer({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final textController = useTextEditingController();
    final isSendVisible = useState(textController.text.isNotEmpty);

    useEffect(() {
      textController.addListener(() {
        isSendVisible.value = textController.text.isNotEmpty;
      });
      return null;
    }, [textController.text]);

    void onSubmit() {
      final time = DateTime.now();
      final senderId = ref.read(userProvider).id;
      final chat = Chat(
        id: time.toIso8601String(),
        content: IChatContent(textController.text),
        createdAt: time,
        senderId: senderId,
        broadcastId: "broadcastId",
      );
      ref.read(chatNotifierProvider.notifier).post(chat);
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      textController.clear();
    }

    final isReactionsVisible = useState<bool>(false);

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        if (isReactionsVisible.value) const ReactionButton(),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8).r,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: TextFormField(
                    style: MTextStyle.captionRegular,
                    controller: textController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      hintText: "Type your comment here...",
                    ),
                  ),
                ),
              ),
              MCore.large.horizontalSpace,
              MIconButton(
                size: 40.r,
                iconSize: 20.r,
                icon: const Icon(Icons.face),
                isFilled: true,
                fillColor: colorScheme.outlineVariant2,
                onPressed: () =>
                    isReactionsVisible.value = !isReactionsVisible.value,
              ),
              if (isSendVisible.value) ...[
                MCore.small.horizontalSpace,
                MIconButton(
                  icon: const Icon(MIcons.send),
                  isFilled: true,
                  fillColor: colorScheme.primary,
                  color: colorScheme.onPrimary,
                  size: 40.r,
                  iconSize: 20.r,
                  onPressed: onSubmit,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ReactionButton extends StatelessWidget {
  const ReactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Positioned(
      bottom: 60.r,
      right: 16.r,
      child: Container(
        height: 56.h,
        padding: const EdgeInsets.all(MCore.small).r,
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(MCore.circle).r,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, i) => MCore.small.horizontalSpace,
          scrollDirection: Axis.horizontal,
          itemCount: reactions.length,
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredList(
              position: i,
              duration: const Duration(milliseconds: 260),
              child: SlideAnimation(
                verticalOffset: (15 + i * 15).r,
                child: FadeInAnimation(
                  child: MIconButton(
                    size: 40.r,
                    iconSize: 20.r,
                    icon: reactions[i].icon,
                    isFilled: true,
                    fillColor: colorScheme.outlineVariant2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
