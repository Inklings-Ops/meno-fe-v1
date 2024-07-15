import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class SearchPage extends HookWidget {
  const SearchPage({super.key, required this.onCancel});
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    useEffect(() {
      final bloc = context.read<SearchBloc>();
      scrollController.addListener(() {
        final pixels = scrollController.position.pixels;
        final maxScrollExtent = scrollController.position.maxScrollExtent;
        if (pixels >= maxScrollExtent && bloc.state.hasMore) {
          final page = bloc.state.page + 1;
          bloc.add(SearchResultsFetched(page));
        }
      });
      return null;
    }, const []);
    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: DiscoverSearchBar(
            height: 32.h,
            autofocus: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4).r,
            showCancelButton: true,
            onCancel: onCancel,
            onChanged: (value) {
              context.read<SearchBloc>().add(SearchBarChanged(value));
            },
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
