import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/presentation/widgets/participant_item.dart';
import 'package:meno/shared/application/user_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ParticipantList extends WatchingWidget {
  const ParticipantList({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final currentUserIdOption = watchValue((UserManager m) => m.currentUserId);
    final currentUserId = currentUserIdOption.toNullable();

    return GridView.builder(
      shrinkWrap: true,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: Insets.sm,
        mainAxisSpacing: Insets.lg,
        childAspectRatio: 80 / 88,
      ),
      itemCount: fakeParticipants.length,
      itemBuilder: (context, index) {
        final participant = fakeParticipants[index];
        final id = participant.id;
        return ParticipantItem(
          key: ValueKey(participant.id.getOrNull()),
          participant: participant,
          onTap: () {
            if (id == currentUserId) return;
            // context.showModal<void>(
            //   BlocProvider(
            //     create: (_) => OthersProfileCubit(
            //       facade: di<IProfileFacade>(),
            //       userId: id,
            //     )..fetch(),
            //     child: ParticipantInfoModal(participant: participant),
            //   ),
            //   isScrollControlled: true,
            //   useRootNavigator: true,
            // );
          },
        );
      },
    );
  }
}
