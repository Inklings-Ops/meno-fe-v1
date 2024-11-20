import 'package:meno_fe_v1/meno.dart';

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: MTextTheme.of(context)!.heading3Bold,
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: 'Enter Title',
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
