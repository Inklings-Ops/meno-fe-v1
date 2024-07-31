import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/services/meno/meno_bloc.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

class StreamPage extends HookWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MenoBloc, MenoState>(
          listener: (context, state) {
            state.whenOrNull(
              endedBroadcast: (_) {
                context.go(Routes.home);
                context.read<StreamBloc>().dispose();
              },
            );
          },
        ),
        BlocListener<StreamBloc, StreamState>(
          listener: (context, state) {
            state.whenOrNull(
              loading: () => null,
              failure: (exception) => context.showBroadcastError(exception),
              joinFailed: (e) => context.showErrorSnackBar(e.toString()),
              leaveSuccess: () {
                context.go(Routes.home);
                context.read<StreamBloc>().dispose();
              },
            );
          },
        ),
      ],
      child: BlocBuilder<StreamBloc, StreamState>(
        builder: (context, state) => state.maybeWhen(
          orElse: () => const SizedBox(),
          loading: () => const Scaffold(body: MLoadingIndicator.box()),
          joinFailed: (e) => Scaffold(body: Center(child: MText(e.toString()))),
          failure: (exception) => Scaffold(
            body: Center(
              child: MText(exception.maybeWhen(
                message: (message) => message,
                orElse: () => 'An unknown error occurred',
                serverError: () => 'A server error occurred',
                timeOutError: () => 'Request timed out. Go back & try again',
              ),),
            ),
          ),
          joinSuccess: (_) => const LiveStreamScaffold(
            tabs: [
              Tab(text: 'Broadcast'),
              Tab(text: 'Chats'),
              Tab(text: 'Live Bible'),
              Tab(text: 'Notes'),
            ],
            tabViews: [
              StreamTab(),
              StreamChatTab(),
              LiveBibleTab(),
              NotesTab(),
            ],
          ),
        ),
      ),
    );
  }
}
