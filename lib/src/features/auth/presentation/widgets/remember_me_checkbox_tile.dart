

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class RememberMeCheckboxTile extends StatelessWidget {
  const RememberMeCheckboxTile({super.key});

  @override
  Widget build(BuildContext context) {
        final textTheme = MTextTheme.of(context)!;
    return BlocSelector<RegisterCubit, RegisterState, bool>(
      selector: (state) => state.rememberMe,
      builder: (context, state) => Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              value: state,
              onChanged: context.read<RegisterCubit>().onRememberMeChanged,
            ),
          ),
          const SizedBox(width: 10),
          MText('Remember me', style: textTheme.captionMedium),
        ],
      ),
    );
  }
}
