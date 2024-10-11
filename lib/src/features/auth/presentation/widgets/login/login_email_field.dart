import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.email != c.email || p.loading != c.loading,
      builder: (context, state) => MTextFormField(
        label: 'Email Address',
        hint: 'example@gmail.com',
        prefixIcon: MIcons.mail,
        keyboardType: TextInputType.emailAddress,
        enabled: !state.loading,
        onChanged: context.read<LoginCubit>().emailChanged,
        validator: (_) => context.validator(state.email.value),
      ),
    );
  }
}
