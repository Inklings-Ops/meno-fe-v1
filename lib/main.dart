import 'package:flutter/material.dart';
import 'package:meno_fe_v1/core/theme/m_color.dart';
import 'package:meno_fe_v1/core/theme/m_icons.dart';
import 'package:meno_fe_v1/core/theme/m_theme.dart';
import 'package:meno_fe_v1/core/theme/styles/m_text_style.dart';

import 'components/components.dart';

void main() {
  runApp(const MenoApp());
}

class MenoApp extends StatelessWidget {
  const MenoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MTheme.light,
      darkTheme: MTheme.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MDivider(),
                const SizedBox(height: 30),
                MOtpField(
                  validator: (value) {
                    if (value != null && value.length < 4) {
                      return "Required";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 30),
                MTextFormField(
                  prefixIcon: MIcons.key,
                  labelIcon: MIcons.info_circle,
                  isPassword: true,
                  label: "Password",
                  hint: "Must be at least 8 characters",
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return "Required";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 30),
                MTextFormField(
                  enabled: false,
                  controller: textEditingController,
                  maxLines: 4,
                  prefixIcon: MIcons.user,
                  suffixIcon: MIcons.chevron_down,
                  label: "Input label",
                  hint: "Placeholder Text",
                ),
                const SizedBox(height: 30),
                MPrimaryButton(
                  label: "Submit",
                  onPressed: () {
                    formKey.currentState?.validate();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MText extends StatelessWidget {
  final String data;
  final MColor? color;
  final MTextStyle? style;

  const MText(
    this.data, {
    super.key,
    this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontFamily: style?.fontFamily,
        fontSize: style?.fontSize,
        fontWeight: style?.fontWeight,
        height: style?.height,
        debugLabel: style?.debugLabel,
      ),
    );
  }
}
