import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: const MText(
        "Forgot Password?",
        style: MTextStyle.captionMedium,
      ),
    );
  }
}
