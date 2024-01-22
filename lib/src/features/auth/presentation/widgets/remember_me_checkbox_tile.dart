import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/application.dart';

class RememberMeCheckboxTile extends StatelessWidget {
  const RememberMeCheckboxTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegisterCubit, RegisterState, bool>(
      selector: (state) => state.rememberMe,
      builder: (context, state) => Row(
        children: [
          SizedBox(
            height: 20.r,
            width: 20.r,
            child: Checkbox(
              value: state,
              onChanged: context.read<RegisterCubit>().onRememberMeChanged,
            ),
          ),
          10.horizontalSpace,
          const MText('Remember me', style: MTextStyle.captionMedium),
        ],
      ),
    );
  }
}
