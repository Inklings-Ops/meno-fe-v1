import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class CreateBroadcastPage extends HookWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return BlocProvider(
      create: (_) => BroadcastFormCubit(
        facade: RepositoryProvider.of<IBroadcastFacade>(context),
        mediaService: di<MediaService>(),
      ),
      child: BlocListener<BroadcastFormCubit, BroadcastFormState>(
        listener: (context, state) {
          state.option.fold(
            () => null,
            (either) => either.fold(
              (exception) => context.showBroadcastError(exception),
              (broadcast) async {
                // final id = broadcast.id;
                // context.read<BroadcastBloc>().add(BroadcastStartRequested(id));
                context.replace(Routes.broadcast, extra: broadcast);
              },
            ),
          );
        },
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: MScaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight.r),
              child: const _Header(),
            ),
            body: const SingleChildScrollView(child: CreateBroadcastForm()),
            persistentFooterButtons: const [CreateBroadcastButton()],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}
