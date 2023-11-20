import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveStreamScaffold extends HookWidget {
  final List<Widget> tabs;
  final List<Widget> tabViews;
  const LiveStreamScaffold({
    Key? key,
    required this.tabs,
    required this.tabViews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 4);

    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48.h),
        child: Padding(
          padding: MediaQuery.viewPaddingOf(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0).r,
            constraints: const BoxConstraints(minHeight: 32).r,
            child: TabBar(controller: tabController, tabs: tabs),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: tabViews,
      ),
    );
  }
}
