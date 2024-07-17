import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_form/broadcast_form_cubit.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/widgets/create_broadcast/create_broadcast_list_item.dart';

class RecordToggleSwitchField extends StatelessWidget {
  const RecordToggleSwitchField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) => p.shouldRecord != c.shouldRecord,
      builder: (context, state) => CreateBroadcastListItem(
        leadingText: 'Enable recording',
        subtitleText: 'Record your broadcast to listen back to later',
        trailing: SizedBox(
          width: 48.w,
          child: Switch(
            value: state.shouldRecord,
            onChanged: context.read<BroadcastFormCubit>().onRecordingChanged,
          ),
        ),
      ),
    );
  }
}
