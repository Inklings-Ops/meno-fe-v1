
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';


class RegisterForm extends HookWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegisterNameField(),
          24.vSpace,
          const RegisterEmail(),
          24.vSpace,
          const RegisterPasswordField(),
          $styles.spaces.verticalSmall,
          const PasswordRulesWidget(),
          $styles.spaces.verticalLarge,
          const RememberMeCheckboxTile(),
          $styles.spaces.verticalXXLarge,
          const RegisterButton(),
        ],
      ),
    );
  }
}
