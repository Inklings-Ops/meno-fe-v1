
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';


class RegisterForm extends HookWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RegisterNameField(),
          Spaces.verticalXLarge,
          RegisterEmail(),
          Spaces.verticalXLarge,
          RegisterPasswordField(),
          Spaces.verticalSmall,
          PasswordRulesWidget(),
          Spaces.verticalLarge,
          RememberMeCheckboxTile(),
          Spaces.verticalXXLarge,
          RegisterButton(),
        ],
      ),
    );
  }
}
