import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveStreamScaffold extends HookWidget {
  final List<Widget> tabs;
  final List<Widget> tabViews;

  const LiveStreamScaffold({
    super.key,
    required this.tabs,
    required this.tabViews,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: tabs.length);

    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0).r,
            constraints: const BoxConstraints(minHeight: 32).r,
            child: TabBar(controller: controller, tabs: tabs),
          ),
        ),
      ),
      body: MTabBarView(
        controller: controller,
        children: tabViews,
        onPageChanged: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
