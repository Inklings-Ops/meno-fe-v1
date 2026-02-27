import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/discover/applications/applications.dart';
import 'package:meno/features/discover/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverSearchView extends WatchingWidget {
  const DiscoverSearchView({required this.onCancel, super.key});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final filter = watchValue((DiscoverManager m) => m.filter);

    final scrollController = createOnce(() {
      final controller = ScrollController();
      controller.addListener(() {
        if (!controller.hasClients) return;

        final maxScroll = controller.position.maxScrollExtent;
        final currentScroll = controller.position.pixels;
        const distance = 120.0; // trigger distance

        if (maxScroll - currentScroll <= distance) {
          return switch (filter) {
            .all => null,
            .nowLive => di<DiscoverNowLiveManager>().fetchMore.run(),
            .recentlyLive => di<DiscoverRecentlyLiveManager>().fetchMore.run(),
            .accounts => null,
          };
        }
      });
      return controller;
    });

    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: DiscoverSearchBar(
            height: 32,
            autofocus: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            showCancelButton: true,
            onCancel: onCancel,
            onChanged: (value) {},
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: const SearchResults(),
      ),
    );
  }
}
