import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class MenoBlocListeners extends StatelessWidget {
  const MenoBlocListeners({required this.child, super.key});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final myId = context.select(
      (SessionBloc bloc) => switch (bloc.state) {
        SessionAuthenticated(:final user) => user.id.getOrCrash(),
        _ => null,
      },
    );

    final broadcastBloc = context.read<BroadcastBloc>();
    final participantsBloc = context.read<ParticipantsBloc>();
    final chatsBloc = context.read<ChatListBloc>();
    final timerBloc = context.read<TimerCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<SessionBloc, SessionState>(
          listener: (ctx, state) {
            switch (state) {
              case SessionAuthenticated():
                ctx.read<NowLiveBloc>().add(const NowLiveStarted());
                ctx.read<RecentlyLiveBloc>().add(const RecentlyLiveStarted());
                ctx.read<NotesBloc>().add(const NotesFetchNotesRequested());
                ctx.read<FoldersBloc>().add(const FoldersGetFoldersRequested());
              default:
            }
          },
        ),
        BlocListener<AccountBloc, AccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            switch (state) {
              case AccountLoadSuccess():
                router.refresh();
              case AccountLoadFailure(:final exception):
                context.pop();
                context.showErrorSnackBar(exception.message);
              default:
            }
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            switch (state) {
              case SocketConnected():
                log('SocketService: WebSocket Client connected');
              case SocketDisconnected():
                log('SocketService: WebSocket Client disconnected');
              case SocketHostDisconnectedReceived(:final value):
                Logger().w('The host has been disconnected. $value');
              case SocketHostReconnectedReceived(:final value):
                Logger().w('The host has been reconnected. $value');
              // broadcastBloc.add(const BroadcastReconnectRequested());
              case SocketNotificationReceived(:final notification):
                context.showNotificationBanner(notification);
              case SocketEndedBroadcastReceived(:final data):
                context.showSnackBar(data.reason.message);
              case SocketNewParticipantReceived(:final participant):
                final userFullName = participant.fullName.getOrCrash();
                final role = participant.role;
                final participantId = participant.id.getOrCrash();
                final hasBroadcast = broadcastBloc.state.broadcast.isNotEmpty;

                // Check if new participant is the host and if this participant
                // is also me (currently authenticated user)
                final isHost = role == ParticipantRole.HOST;
                final isMeAsHost = isHost && (myId == participantId);

                if (!hasBroadcast && isMeAsHost) {
                  // If the broadcast bloc has no broadcast yet and if the
                  // new participant is a host and is also me, reconnect
                  // as the host
                  log('Reconnecting as host... $userFullName');
                  broadcastBloc.add(const BroadcastReconnectRequested());
                }

                // Check if new participant is the listener and if this
                // participant is also me (currently authenticated user)
                final isListener = role == ParticipantRole.LISTENER;
                final isMeAsListener = isListener && (myId == participantId);
                if (!hasBroadcast && isMeAsListener) {
                  // If the broadcast bloc has no broadcast yet and if the
                  // new participant is a listener and is also me, reconnect
                  // as listener (rejoin the stream)
                  log('Reconnecting as listener... $userFullName');
                  broadcastBloc.add(
                    const BroadcastReconnectRequested(isStream: true),
                  );
                }
                context.showSnackBar('$userFullName joined the broadcast.');

              case SocketParticipantLeftReceived(:final participant):
                final userFullName = participant.fullName.getOrCrash();
                context.showSnackBar('$userFullName left the broadcast.');

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
              case LiveBroadcastStatus.reconnecting:
              case LiveBroadcastStatus.offAir:
                return;
              case LiveBroadcastStatus.left:
                if (router.state.name != Routes.broadcastTab) {
                  participantsBloc.add(const ParticipantsResetRequested());
                  chatsBloc.add(const ChatResetRequested());
                  timerBloc.stop();
                  router.go(Routes.home);
                }
              case LiveBroadcastStatus.joined:
                if (state.isReconnect && state.isStream) {
                  participantsBloc.add(ParticipantsFetchRequested(broadcastId));
                  chatsBloc.add(ChatGetMessagesRequested(broadcastId));
                  Logger().w(state.broadcast.startTime);
                  timerBloc.setAndStart(state.broadcast.startTime);
                  router.push<void>(Routes.broadcastTab, extra: true);
                }
              case LiveBroadcastStatus.started:
                if (state.isReconnect) {
                  participantsBloc.add(ParticipantsFetchRequested(broadcastId));
                  chatsBloc.add(ChatGetMessagesRequested(broadcastId));
                  timerBloc.setAndStart(state.broadcast.startTime);
                  router.push<void>(Routes.broadcastTab);
                }
              case LiveBroadcastStatus.ended:
                if (router.state.name != Routes.broadcastTab) {
                  participantsBloc.add(ParticipantsFetchRequested(broadcastId));
                  chatsBloc.add(const ChatResetRequested());
                  timerBloc.stop();
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
