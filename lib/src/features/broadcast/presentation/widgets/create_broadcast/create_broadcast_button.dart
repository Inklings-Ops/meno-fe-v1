import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_form/broadcast_form_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class CreateBroadcastButton extends StatelessWidget {
  const CreateBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastFormCubit>();
    return Container(
      height: 77.h,
      padding: const EdgeInsets.symmetric(horizontal: MCore.small).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MPrimaryButton(
            label: 'Start Broadcast',
            loading: bloc.state.loading,
            disabled: bloc.state.loading || !bloc.state.isFormValid,
            onPressed: () {
              context.clearSnackBars();
              FocusScope.of(context).unfocus();
              if (Form.of(context).validate()) {
                bloc.create();
              }
            },
          ),
        ],
      ),
    );
  }
}
