import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/manager/user_manager.dart';
import 'package:meno/features/broadcast/manager/live_session_manager.dart';
import 'package:meno/features/broadcast/model/_model.dart';
import 'package:meno/features/broadcast/services/broadcast_local_service.dart';
import 'package:meno/features/broadcast/widgets/broadcast_exit_alert_dialog.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveSessionBanner extends WatchingWidget {
  const LiveSessionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = watchValue((UserManager m) => m.currentUserId);

    final isReady = watchFuture<GetIt, void>(
      (getIt) => getIt.allReady(timeout: const Duration(seconds: 30)),
      target: di,
      initialValue: null,
    );

    final session = watchStream(
      (BroadcastLocalService s) => s.watchActiveSession(currentUserId),
      target: di<BroadcastLocalService>(),
      initialValue: BroadcastSession.empty,
    );

    if (!isReady.hasData || !session.hasData) return const SizedBox.shrink();
    if (session.data == null) return const SizedBox.shrink();

    callOnceAfterThisBuild(
      (_) async => Future.delayed(const Duration(seconds: 5), di.allReady),
    );

    return _SessionBannerContent(key: key, broadcast: session.data!.broadcast);
  }
}

class _SessionBannerContent extends WatchingWidget {
  const _SessionBannerContent({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final status = watchValue((LiveSessionManager m) => m.status);
    final isHost = watchValue((LiveSessionManager m) => m.isHost);

    if (status.isNotLive) return const SizedBox.shrink();

    return _Banner(
      key: ValueKey('broadcastBanner-${broadcast.id.getOrCrash()}'),
      broadcastTitle: broadcast.title.getOrCrash(),
      broadcastCreatorName: broadcast.hostName.getOrElse((_) => ''),
      badgeTitle: isHost ? status.hostTitle : status.participantTitle,
      actionButtonLabel: isHost ? 'End' : 'Leave',
      action: () => _handleAction(context, isHost),
      onTap: () => context.push<void>(R.broadcastTab),
    );
  }

  Future<void> _handleAction(BuildContext context, bool isHost) async {
    final result = await BroadcastExitAlertDialog.show(context, isHost);
    if (result ?? false) di<LiveSessionManager>().endSession.run();
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.badgeTitle,
    required this.broadcastTitle,
    required this.broadcastCreatorName,
    this.actionButtonLabel,
    this.onTap,
    this.action,
    super.key,
  });

  final String badgeTitle;
  final String broadcastTitle;
  final String broadcastCreatorName;
  final VoidCallback? onTap;
  final String? actionButtonLabel;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: .circular(Insets.lg),
      child: Card(
        margin: const .symmetric(horizontal: Insets.lg),
        shape: RoundedSuperellipseBorder(borderRadius: .circular(Insets.lg)),
        child: Padding(
          padding: const .all(14),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: colors.secondaryContainer,
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: colors.secondary,
                          ),
                        ),
                        Spaces.horizontalMicro,
                        MText(
                          badgeTitle,
                          style: textTheme.microMedium,
                          color: colors.error,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 24,
                      alignment: Alignment.centerLeft,
                      child: MText(
                        broadcastTitle,
                        style: MTextTheme.of(context).captionMedium,
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                    MText(
                      broadcastCreatorName,
                      color: colors.onBackgroundVariant,
                      style: textTheme.captionRegular,
                    ),
                  ],
                ),
              ),
              Spaces.horizontalMedium,
              LimitedBox(
                maxHeight: 32,
                maxWidth: 79,
                child: MDangerButton(
                  label: actionButtonLabel ?? '',
                  onPressed: action,
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: Corners.sm,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
