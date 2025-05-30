import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class CreateFolderModal extends StatelessWidget {
  const CreateFolderModal({super.key, this.initialFolder});
  final Folder? initialFolder;

  @override
  Widget build(BuildContext context) {
    final isEdit = initialFolder != null;

    return BlocListener<FolderFormBloc, FolderFormState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        switch (state) {
          case FolderFormSubmitFailed(:final exception):
            ctx.showErrorSnackBar(exception.message);
          case FolderFormSubmitSuccess(:final folder):
            ctx.read<FoldersBloc>().add(FoldersUpdateFoldersRequested(folder));
            router.pop(folder);
          default:
        }
      },
      child: Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: MModal(
          title: isEdit ? 'Rename Your Folder' : 'Give Your Folder a Name',
          builder: (context) => ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 292),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                FolderFormTitleField(),
                SizedBox(height: 56),
                _SubmitButton(),
                Spaces.verticalXXLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FolderFormTitleField extends HookWidget {
  const FolderFormTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).inputDecorationTheme;
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final textController = useTextEditingController();

    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.border!.borderSide.color),
    );

    final errorBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.errorBorder!.borderSide.color),
    );

    final disabledBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.disabledBorder!.borderSide.color),
    );

    final bloc = context.watch<FolderFormBloc>();

    return BlocConsumer<FolderFormBloc, FolderFormState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        switch (state) {
          case FolderFormLoadSuccess(:final folder):
            if (folder.title.isValid) {
              textController.text = folder.title.getOrCrash();
            } else {
              textController.text = '';
            }
          default:
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => TextFormField(
        autofocus: true,
        style: textTheme.heading1Regular,
        controller: textController,
        textAlign: TextAlign.center,
        enabled: state is! FolderFormSubmitInProgress,
        onChanged: (value) => bloc.add(
          FolderFormTitleChanged(SingleLineString(value)),
        ),
        validator: (_) => switch (state) {
          FolderFormLoadSuccess(:final folder) =>
            folder.title.failureOrNull?.message,
          _ => null,
        },
        decoration: InputDecoration(
          hintText: 'Title',
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          disabledBorder: disabledBorder,
          hintStyle: textTheme.heading1Regular.copyWith(
            color: colors.onBackgroundVariant,
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FolderFormBloc>();
    return BlocBuilder<FolderFormBloc, FolderFormState>(
      builder: (context, state) => MPrimaryButton(
        label: switch (state) {
          FolderFormSubmitFailed() => 'Try again',
          FolderFormLoadSuccess(:final folder) =>
            folder.id.isValid ? 'Rename Folder' : 'Create Folder',
          FolderFormSubmitSuccess() => 'Done',
          _ => '',
        },
        loading: state is FolderFormSubmitInProgress,
        disabled: switch (state) {
          FolderFormLoadSuccess(:final folder) => !folder.title.isValid,
          _ => true,
        },
        onPressed: () => bloc.add(const FolderFormSubmitRequested()),
      ),
    );
  }
}
