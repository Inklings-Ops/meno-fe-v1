import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../../application/chat_bloc.dart';
import 'reactions.dart';

class ChatInputContainer extends HookWidget {
  final String broadcastId;
  final ScrollController scrollController;

  const ChatInputContainer({
    super.key,
    required this.broadcastId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final bloc = context.read<ChatBloc>();

    final contentController = useTextEditingController();
    final isSendVisible = useState(contentController.text.isNotEmpty);

    useEffect(() {
      contentController.addListener(() {
        isSendVisible.value = contentController.text.isNotEmpty;
      });
      return null;
    }, [contentController.text]);

    final isReactionsVisible = useState<bool>(false);

    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (p, c) => p.onSend != c.onSend,
      listener: (context, state) {
        state.onSend.fold(() => null, (a) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        });
      },
      child: Stack(
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
                      controller: contentController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ).r,
                        hintText: 'Type your comment here...',
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
                  BlocBuilder<SessionCubit, SessionState>(
                    builder: (context, state) => state.maybeWhen(
                      orElse: () => const SizedBox(),
                      authenticated: (user, _) => MIconButton(
                        icon: const Icon(MIcons.send),
                        isFilled: true,
                        fillColor: colorScheme.primary,
                        color: colorScheme.onPrimary,
                        size: 40.r,
                        iconSize: 20.r,
                        onPressed: () {
                          bloc.add(
                            ChatEvent.sendMessage(
                              content: contentController.text,
                              broadcastId: broadcastId,
                            ),
                          );
                          scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          contentController.clear();
                          ChatEvent.getMessages(broadcastId);
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );*/

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
