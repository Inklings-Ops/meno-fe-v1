import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets/chat_input_container.dart';
import '../widgets/chat_list.dart';

class ChatPage extends HookWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final FocusScopeNode focusScope = useFocusScopeNode();

    return MScaffold(
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: true,
      appBar: MAppBar.secondary(title: "Chat"),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => focusScope.unfocus(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ChatList(controller: scrollController),
                ),
              ),
            ),
            SizedBox(
              height: 52.h,
              width: constraints.maxWidth,
              child: ChatInputContainer(scrollController: scrollController),
            ),
          ],
        );
      }),
    );
  }
}
