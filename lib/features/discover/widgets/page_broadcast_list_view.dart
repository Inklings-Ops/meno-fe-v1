// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:meno_fe_v1/src/features/broadcast/domain/entities/broadcast.dart';
// import 'package:meno_fe_v1/src/features/discover/application/search/search_cubit.dart';

// class PagedBroadcastListView extends HookWidget {
//   const PagedBroadcastListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.watch<SearchCubit>();

    // final pagingController = PagingController<int, Broadcast>(
    //   firstPageKey: 1,
    // );

//     useEffect(() {
//       pagingController.addPageRequestListener((pageKey) {});

//       return () {
//         pagingController.dispose();
//       };
//     }, const []);

//     Future<void> _fetch() async {
//       final previouslyFetchedItemsCount =
//           pagingController.itemList?.length ?? 0;

//       final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
//       final newItems = newPage.itemList;
//     }

//     return const SizedBox();
//   }
// }
