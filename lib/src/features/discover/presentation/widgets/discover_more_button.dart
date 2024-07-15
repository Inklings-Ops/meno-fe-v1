// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meno_design_system/meno_design_system.dart';
// import 'package:meno_fe_v1/src/features/discover/application/search/search_cubit.dart';
// import 'package:meno_fe_v1/src/features/discover/domain/search_filter.dart';

// class DiscoverMoreButton extends StatelessWidget {
//   const DiscoverMoreButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SearchCubit, SearchState>(
//       buildWhen: (p, c) => p.isLoading != c.isLoading || p.hasMore != c.hasMore,
//       builder: (context, state) {
//         if (state.filter == SearchFilter.suggestedAccounts) {
//           return const SizedBox();
//         }

//         String labelText = 'Load more';
//         Widget? icon = const Icon(Icons.refresh);

//         if (state.broadcasts[state.filter]?.isEmpty == true) {
//           return const SizedBox();
//         }

//         if (!state.hasMore) {
//           labelText = 'You\'ve reached the end';
//           icon = const Icon(Icons.celebration);
//         }

// if (state.isLoading) {
//   return const Center(child: MLoadingIndicator.box());
// } else {
//           return MTextButton.icon(
//             label: labelText,
//             icon: icon,
//             onPressed: state.isLoading || !state.hasMore
//                 ? null
//                 : context.read<SearchCubit>().fetchMore,
//           );
//         }
//       },
//     );
//   }
// }
