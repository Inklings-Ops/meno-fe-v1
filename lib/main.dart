import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/injector/injector.dart';
import 'package:meno_fe_v1/router/m_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MenoApp());
}

class MenoApp extends StatefulWidget {
  const MenoApp({super.key});

  @override
  State<MenoApp> createState() => _MenoAppState();
}

class _MenoAppState extends State<MenoApp> {
  final _mRouter = MRouter();

  @override
  Widget build(BuildContext context) {
    final isLight =
        MediaQuery.platformBrightnessOf(context) == Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isLight ? MColor.white : MColor.primary700,
    ));

    return MaterialApp.router(
      theme: MTheme.light,
      darkTheme: MTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: _mRouter.config(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MAppBar.secondary(
//         title: "New Account",
//         actions: [
//           MIconButton(onPressed: () {}, icon: MIcons.dots_horizontal),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: const Body(),
//     );
//   }
// }

// class Body extends StatefulWidget {
//   const Body({super.key});

//   @override
//   State<Body> createState() => _BodyState();
// }

// class _BodyState extends State<Body> {
//   final formKey = GlobalKey<FormState>();
//   final textEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 30),
//             const MBadge.small(),
//             const SizedBox(height: 30),
//             const MBadge.large(value: "33"),
//             const SizedBox(height: 30),
//             const MBadge.live(count: "33K"),
//             const SizedBox(height: 30),
//             MCard.recentlyLive(
//               title: "This is the Title of the Broadcast",
//               host: "This is the Host",
//             ),
//             const SizedBox(height: 30),
//             MBadge.newBadge(context),
//             const SizedBox(height: 30),
//             MCard.live(
//               title: "This is the Title of the Broadcast",
//               host: "This is the Host",
//             ),
//             const SizedBox(height: 30),
//             MTextFormField(
//               prefixIcon: MIcons.key,
//               labelIcon: MIcons.info_circle,
//               isPassword: true,
//               label: "Password",
//               hint: "Must be at least 8 characters",
//               validator: (value) {
//                 if (value?.isEmpty == true) {
//                   return "Required";
//                 }

//                 return null;
//               },
//             ),
//             const SizedBox(height: 30),
//             MTextFormField(
//               enabled: false,
//               controller: textEditingController,
//               maxLines: 4,
//               prefixIcon: MIcons.user,
//               suffixIcon: MIcons.chevron_down,
//               label: "Input label",
//               hint: "Placeholder Text",
//             ),
//             const SizedBox(height: 30),
//             MPrimaryButton(
//               label: "Submit",
//               onPressed: () => formKey.currentState?.validate(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
