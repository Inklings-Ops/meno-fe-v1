// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
// import 'package:meno_fe_v1/src/router/router.dart';
// import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

// import '../../../chat/presentation/widgets/chat_input_container.dart';
// import '../../../chat/presentation/widgets/chat_list.dart';

// class BroadcastPage extends StatelessWidget {
//   const BroadcastPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<BroadcastBloc, BroadcastState>(
//           bloc: context.read<BroadcastBloc>(),
//           listenWhen: (p, c) =>
//               p.onStarted != c.onStarted ||
//               p.onEnded != c.onEnded ||
//               p.onDeleted != c.onDeleted,
//           listener: (context, state) {
//             state.onStarted.fold(
//               () => null,
//               (either) => either.fold(
//                 (l) => context.showBroadcastError(l),
//                 (r) {
//                   context
//                       .read<LiveParticipantsBloc>()
//                       .add(FetchParticipants(r.id.getOr()));
//                 },
//               ),
//             );

//             state.onEnded.fold(
//               () => null,
//               (_) => context.showModal(
//                 const BroadcastEndedModal(),
//                 enableDrag: false,
//                 useRootNavigator: true,
//                 isDismissible: false,
//                 isScrollControlled: true,
//               ),
//             );

//             state.onDeleted.fold(
//               () => null,
//               (either) => either.fold(
//                 (l) => context.showBroadcastError(l),
//                 (r) => context.go(Routes.home),
//               ),
//             );
//           },
//         ),
//         BlocListener<BroadcastBloc, BroadcastState>(
//           listener: (context, state) {
//             // TODO: implement listener
//           },
//         ),
//       ],
//       child: const PopScope(
//         canPop: false,
//         child: LiveStreamScaffold(
//           tabs: [
//             Tab(text: 'Broadcast'),
//             Tab(text: 'Chats'),
//             Tab(text: 'Live Bible'),
//             Tab(text: 'Notes'),
//           ],
//           tabViews: [
//             BroadcastTab(),
//             _ChatTab(),
//             LiveBibleTab(),
//             NotesTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ChatTab extends HookWidget {
//   const _ChatTab();

//   @override
//   Widget build(BuildContext context) {
//     final scrollController = useScrollController();

//     return BlocBuilder<BroadcastBloc, BroadcastState>(
//       builder: (context, state) => LayoutBuilder(
//         builder: (context, constraints) => Column(
//           children: [
//             Expanded(
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: ChatList(
//                   broadcastId: state.broadcast.id.getOr(),
//                   controller: scrollController,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 52.h,
//               width: constraints.maxWidth,
//               child: ChatInputContainer(
//                 broadcastId: state.broadcast.id.getOr(),
//                 scrollController: scrollController,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
