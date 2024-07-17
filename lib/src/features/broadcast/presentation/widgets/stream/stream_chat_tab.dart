import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class StreamChatTab extends HookWidget {
  const StreamChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [MText('Waiting to join stream')],
        ),
        joinSuccess: (broadcast) => LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ChatList(controller: scrollController),
                ),
              ),
              SizedBox(
                height: 52.h,
                width: constraints.maxWidth,
                child: ChatInputContainer(scrollController: scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
