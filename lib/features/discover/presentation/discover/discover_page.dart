import 'package:flutter/material.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScripturePicker(),
              MDivider(bottomSpace: 16),
              Expanded(child: BibleVerses()),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:meno_design_system/meno_design_system.dart';
//
// class DiscoverPage extends StatefulWidget {
//   const DiscoverPage({super.key});
//
//   @override
//   State<DiscoverPage> createState() => _DiscoverPageState();
// }
//
// class _DiscoverPageState extends State<DiscoverPage> {
//   // final filter = ValueNotifier<Filter>(Filter.all);
//
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       final pixels = _scrollController.position.pixels;
//       final maxScrollExtent = _scrollController.position.maxScrollExtent - 350;
//       if (pixels >= maxScrollExtent) {
//         // fetchMore(context, filter.value);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     // filter.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final isSearching = useState<bool>(false);
//
//     // void onSearchBarTapped() => isSearching.value = true;
//     // void onSearchCancelled() => isSearching.value = false;
//     //
//     // if (isSearching.value) {
//     //   return switch (filter.value) {
//     //     Filter.accounts => AccountsSearchPage(onCancel: onSearchCancelled),
//     //     _ => BroadcastsSearchPage(onCancel: onSearchCancelled),
//     //   };
//     // }
//
//     return MScaffold(
//       padding: EdgeInsets.zero,
//       appBar: AppBar(
//         title: const MHeader(
//           title: 'Discover',
//           padding: EdgeInsets.zero,
//           addTopMargin: true,
//         ),
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(110),
//           child: Column(
//             children: [
//               SizedBox(height: 6),
//               // switch (filter.value) {
//               // Filter.accounts => AccountsSearchBar(onTap: onSearchBarTapped),
//               //   _ => DiscoverSearchBar(onTap: onSearchBarTapped),
//               // },
//               Spaces.verticalXLarge,
//               // LimitedBox(
//               //   maxHeight: 32,
//               //   child: SearchFilterList(
//               //     filter: filter.value,
//               //     onSelected: (value) => filter.value = value,
//               //   ),
//               // ),
//               Spaces.verticalMicro,
//             ],
//           ),
//         ),
//       ),
//       body: RefreshIndicator.adaptive(
//         // onRefresh: () => refresh(context, filter.value),
//         onRefresh: () async {},
//         child: SingleChildScrollView(
//           controller: _scrollController,
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.only(bottom: Insets.xxxl),
//           // child: switch (filter.value) {
//           //   Filter.all => const AllBroadcastsWidget(),
//           //   Filter.nowLive => const NowLiveBroadcastsWidget(),
//           //   Filter.recentlyLive => const RecentlyLiveBroadcastsWidget(),
//           //   Filter.accounts => const SuggestAccountsWidget(),
//           // },
//         ),
//       ),
//     );
//   }
//
//   // Future<dynamic> refresh(BuildContext context, Filter filter) async {
//   //   return switch (filter) {
//   //     Filter.all => Future.wait([_nowLive(context), _recentlyLive(context)]),
//   //     Filter.nowLive => _nowLive(context),
//   //     Filter.recentlyLive => _recentlyLive(context),
//   //     Filter.accounts => null,
//   //   };
//   // }
//   //
//   // Future<dynamic> _nowLive(BuildContext context) async {
//   //   final nowLiveBloc = context.read<NowLiveBloc>();
//   //   final nowLive = nowLiveBloc.stream.first;
//   //   nowLiveBloc.add(const NowLiveStarted());
//   //   return Future<dynamic>.value(nowLive);
//   // }
//   //
//   // Future<dynamic> _recentlyLive(BuildContext context) async {
//   //   final recentlyLiveBloc = context.read<RecentlyLiveBloc>();
//   //   final recentlyLive = recentlyLiveBloc.stream.first;
//   //   recentlyLiveBloc.add(const RecentlyLiveStarted());
//   //   return Future<dynamic>.value(recentlyLive);
//   // }
//   //
//   // Future<void> fetchMore(BuildContext context, Filter filter) async {
//   //   final nowLive = context.read<NowLiveBloc>();
//   //   final recentlyLive = context.read<RecentlyLiveBloc>();
//   //
//   //   return switch (filter) {
//   //     Filter.all => null,
//   //     Filter.nowLive => nowLive.add(const NowLiveFetchMoreRequested()),
//   //     Filter.recentlyLive => recentlyLive.add(
//   //       const RecentlyLiveFetchMoreRequested(),
//   //     ),
//   //     Filter.accounts => null,
//   //   };
//   // }
// }
