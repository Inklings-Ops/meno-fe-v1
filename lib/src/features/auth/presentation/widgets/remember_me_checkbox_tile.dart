

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class RememberMeCheckboxTile extends StatelessWidget {
  const RememberMeCheckboxTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegisterCubit, RegisterState, bool>(
      selector: (state) => state.rememberMe,
      builder: (context, state) => Row(
        children: [
          SizedBox(
            height: 20.toScale,
            width: 20.toScale,
            child: Checkbox(
              value: state,
              onChanged: context.read<RegisterCubit>().onRememberMeChanged,
            ),
          ),
          10.hSpace,
          MText('Remember me', style: $styles.text.captionMedium),
        ],
      ),
    );
  }
}
