import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

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
          child: const MScaffold(
            appBar: _Header(),
            body: SingleChildScrollView(child: CreateBroadcastForm()),
            persistentFooterButtons: [CreateBroadcastButton()],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget implements PreferredSizeWidget {
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.toScale);
}
