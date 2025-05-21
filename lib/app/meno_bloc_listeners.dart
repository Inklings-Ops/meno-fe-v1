import 'dart:developer';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class MenoBlocListeners extends StatelessWidget {
  const MenoBlocListeners({required this.child, super.key});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final broadcastBloc = context.read<BroadcastBloc>();
    final participantsBloc = context.read<ParticipantsBloc>();
    final chatsBloc = context.read<ChatListBloc>();
    final timerBloc = context.read<TimerCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<SessionBloc, SessionState>(
          listener: (context, state) {
            state.whenOrNull(
              authenticated: (user, token) {
                context.read<AccountBloc>().add(const AccountInitialized());
                context.read<NowLiveBloc>().add(const NowLiveStarted());
                context.read<RecentlyLiveBloc>().add(const RecentlyLiveStarted());
                context.read<NotesBloc>().add(const GetNotesRequested());
                context.read<FoldersBloc>().add(const GetFoldersRequested());
              },
            );
          },
        ),
        BlocListener<AccountBloc, AccountState>(
          listenWhen: (p, c) => p is AccountLoaded != c is AccountLoaded,
          listener: (context, state) {
            state.whenOrNull(
              loaded: (credential, _) => router.refresh(),
              failure: (failure) => context
                ..pop()
                ..showLoginError(failure),
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            switch (state) {
              case SocketConnected():
                log('SocketService: WebSocket Client connected');
              case SocketDisconnected():
                log('SocketService: WebSocket Client disconnected');
              case SocketNotificationReceived(:final notification):
                context.showNotificationBanner(notification);
              case SocketEndedBroadcastReceived(:final data):
                context.showSnackBar(data.reason.message);
              case SocketNewParticipantReceived(:final participant):
                final role = participant.role;
                final isHost = [Role.HOST, Role.host].contains(role);
                if (!broadcastBloc.state.isStream && !isHost) {
                  broadcastBloc.add(
                    const BroadcastReconnectRequested(isStream: true),
                  );
                } else {
                  final userFullName = participant.fullName;
                  context.showSnackBar('$userFullName joined the broadcast.');
                }
              case SocketParticipantLeftReceived(:final participant):
                final userFullName = participant.fullName;
                context.showSnackBar('$userFullName left the broadcast.');
              case SocketHostDisconnectedReceived(:final value):
                if (value) {
                  context.showSnackBar('The host has been disconnected.');
                }
              case SocketHostReconnectedReceived(:final value):
                if (value) {
                  context.showSnackBar('The host has been reconnected.');
                  broadcastBloc.add(const BroadcastReconnectRequested());
                }
              default:
            }
          },
        ),
        BlocListener<BroadcastBloc, BroadcastState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            final broadcastId = state.broadcast.id;
            switch (state.status) {
              case LiveBroadcastStatus.initial:
              case LiveBroadcastStatus.loading:
              case LiveBroadcastStatus.left:
                participantsBloc.add(const ParticipantsResetRequested());
                chatsBloc.add(const ChatResetRequested());
                timerBloc.stop();
                if (router.state.name == Routes.broadcastTab) {
                  router.go(Routes.home);
                }
              case LiveBroadcastStatus.joined:
                if (state.isReconnect && state.isStream) {
                  participantsBloc.add(ParticipantsFetchRequested(broadcastId));
                  chatsBloc.add(ChatGetMessagesRequested(broadcastId));
                  timerBloc.setAndStart(state.broadcast.startTime);
                  router.push<void>(Routes.broadcastTab);
                }
              case LiveBroadcastStatus.started:
                participantsBloc.add(ParticipantsFetchRequested(broadcastId));
                chatsBloc.add(ChatGetMessagesRequested(broadcastId));
                if (state.isReconnect) {
                  timerBloc.setAndStart(state.broadcast.startTime);
                  router.push<void>(Routes.broadcastTab);
                } else {
                  timerBloc.start();
                  router.replace<void>(Routes.broadcastTab);
                }
              case LiveBroadcastStatus.ended:
                participantsBloc.add(ParticipantsFetchRequested(broadcastId));
                chatsBloc.add(const ChatResetRequested());
                timerBloc.stop();

                if (router.state.name == Routes.broadcastTab) {
                  router.replace<void>(Routes.endedBroadcast);
                } else {
                  router.push<void>(Routes.endedBroadcast);
                }
              case LiveBroadcastStatus.failure:
                final exception = state.exception;
                if (exception == null) return;
                context.showErrorSnackBar(exception.message);
            }
          },
        ),
      ],
      child: child ?? const SizedBox.shrink(),
    );
  }
}
