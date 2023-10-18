import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets/co_host_item.dart';
import 'listener_info_modal.dart';

class BroadcastListenersModal extends StatelessWidget {
  const BroadcastListenersModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: "Listening (23)",
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MTextFormField(
            label: "Search",
            prefixIcon: MIcons.search,
            showLabel: false,
            hint: "Search",
          ),
          MSize.verticalSpaceLarge,
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: MCore.small,
                mainAxisSpacing: 24,
                childAspectRatio: 80 / 91,
              ),
              itemCount: 14,
              itemBuilder: (context, i) => CoHostItem(
                isCohost: i == 0,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const ListenerInfoModal(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
