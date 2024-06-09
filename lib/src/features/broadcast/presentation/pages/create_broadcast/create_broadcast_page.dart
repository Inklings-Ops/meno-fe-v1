import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/broadcast_form/broadcast_form_cubit.dart';
import 'create_broadcast_form.dart';

class CreateBroadcastPage extends StatelessWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight.r),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: MHeader(
            title: 'Go Live Now',
            action: InkWell(
              onTap: context.pop,
              child: MText(
                'Cancel',
                color: MColorScheme.of(context)!.onBackgroundVariant,
              ),
            ),
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: CreateBroadcastForm(),
      ),
      persistentFooterButtons: const [_CreateButton()],
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BroadcastFormCubit>();

    return Container(
      height: 77.h,
      padding: const EdgeInsets.symmetric(horizontal: MCore.small).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
            bloc: bloc,
            buildWhen: (p, c) => p.loading != c.loading,
            builder: (context, state) => MPrimaryButton(
              label: 'Start Broadcast',
              loading: state.loading,
              onPressed: () {
                context.clearSnackBars();
                FocusScope.of(context).unfocus();
                if (bloc.isValid) {
                  bloc.create();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
