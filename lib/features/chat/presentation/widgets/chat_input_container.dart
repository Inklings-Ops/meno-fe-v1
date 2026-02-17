import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/chat/applications/applications.dart';
import 'package:meno/features/chat/presentation/presentation.dart';
import 'package:meno/shared/domain/value_objects/multi_line_string.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChatInputContainer extends WatchingWidget {
  const ChatInputContainer({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _ChatTextField()),
              Spaces.horizontalLarge,
              HorizontalPopupMenu(
                icon: MIconButton(
                  size: 40,
                  iconSize: 20,
                  icon: const Icon(Icons.face),
                  isFilled: true,
                  fillColor: colors.outlineVariant2,
                ),
                items: mainReactions.map((reaction) {
                  return MIconButton(
                    size: 40,
                    iconSize: 20,
                    icon: reaction.icon,
                    isFilled: true,
                    fillColor: colors.outlineVariant2,
                    onPressed: () {},
                  );
                }).toList(),
              ),
              Spaces.horizontalSmall,
              ChatSendButton(scrollController: scrollController),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatTextField extends WatchingStatefulWidget {
  const _ChatTextField();

  @override
  State<_ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<_ChatTextField> {
  FocusNode? _focusNode;
  TextEditingController? _controller;

  final manager = di<ChatManager>();

  @override
  void initState() {
    super.initState();

    final initialValue = manager.content.value.getOrElse((_) => '');
    _controller = TextEditingController(text: initialValue);

    manager.content.listen((MultiLineString newValue, _) {
      _syncControllerWithManager(newValue);
    });

    _focusNode = FocusNode();
  }

  void _syncControllerWithManager(MultiLineString newValue) {
    final text = newValue.getOrElse((_) => '');
    if (_controller?.text != text) {
      _controller?.text = text;
      _controller?.selection = TextSelection.collapsed(offset: text.length);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      style: MTextTheme.of(context).captionRegular,
      controller: _controller,
      onChanged: manager.onContentChange,
      maxLines: 5,
      minLines: 1,
      maxLength: 244,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Type your comment here...',
        counter: SizedBox(),
        contentPadding: EdgeInsets.symmetric(
          vertical: Insets.sm,
          horizontal: Insets.md,
        ),
      ),
    );
  }
}
