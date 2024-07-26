import 'package:meno_fe_v1/meno.dart';

class MenoScaffold extends StatelessWidget {
  const MenoScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {    
    return LayoutBuilder(
      builder: (context, constraints) {
        return MenoInit(child: child);
      },
    );
  }
}











/*
 return MenoInit(
       child: DefaultTextStyle(
         style: $styles.text.bodyRegular,
         // child: BlocListener<NetworkCubit, NetworkState>(
         //   bloc: context.read<NetworkCubit>(),
         //   listenWhen: (p, c) => p.status != c.status,
         //   listener: (context, state) {
         //     FToast toast = FToast().init(context);
         //     switch (state.status) {
         //       case NetworkStatus.disconnected:
         //         context.showNetworkError(toast);
         //         break;
         //       case NetworkStatus.connected:
         //         context.showNetworkSuccess(toast);
         //         context.closeAllToasts;
         //         break;
         //     }
         //   },
           child: child,
         // ),
       ),
    );
*/