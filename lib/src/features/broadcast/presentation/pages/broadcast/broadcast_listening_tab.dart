import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets/co_host_item.dart';
import 'broadcast_listeners_modal.dart';
import 'listener_info_modal.dart';

class BroadcastListeningTab extends HookWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        24.verticalSpace,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 34,
          child: Row(
            children: [
              const Row(
                children: [
                  Icon(MIcons.hearing, size: 16),
                  MSize.horizontalSpaceSmall,
                  MText("23", style: MTextStyle.captionMedium),
                ],
              ),
              const Spacer(),
              MPrimaryButton.icon(
                label: "Expand",
                icon: const Icon(MIcons.expand_01),

                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.9,
                  ),
                  builder: (context) => const BroadcastListenersModal(),
                ),
                // TODO: Handle button theme
                style: MButtonStyle.of(context)!.primary!.override(),
              ),
            ],
          ),
        ),
        MSize.verticalSpaceLarge,
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: MCore.small,
              mainAxisSpacing: 24,
              childAspectRatio: 80 / 90,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return CoHostItem(
                isCohost: index == 0,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const ListenerInfoModal(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
