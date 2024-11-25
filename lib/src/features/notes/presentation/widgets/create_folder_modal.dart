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
      listener: (context, state) {
        state.whenOrNull(
          failure: context.showNoteError,
          submitted: (folder) {
            context.read<FoldersBloc>().add(UpdateFolderList(folder));
            router.pop(folder);
          },
        );
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
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

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
      listener: (context, state) {
        bloc.state.whenOrNull(
          loaded: (folder) {
            if (folder.title.isValid) {
              textController.text = folder.title.getOr();
            } else {
              textController.text = '';
            }
          },
        );
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => TextFormField(
        autofocus: true,
        style: textTheme.heading1Regular,
        controller: textController,
        textAlign: TextAlign.center,
        enabled: state is! FolderFormSubmitInProgress,
        onChanged: (value) => bloc.add(FolderTitleChanged(FolderTitle(value))),
        validator: (_) => state.whenOrNull(
          loaded: (folder) => context.validator(folder.title.value),
        ),
        decoration: InputDecoration(
          hintText: 'Title',
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          disabledBorder: disabledBorder,
          hintStyle: textTheme.heading1Regular?.copyWith(
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
        label: state.maybeWhen(
          orElse: () => '',
          failure: (_) => 'Try again',
          loaded: (f) => f.id.isValid ? 'Rename Folder' : 'Create Folder',
          submitted: (f) => 'Done',
        ),
        loading: state is FolderFormSubmitInProgress,
        disabled: state.maybeWhen(
          orElse: () => true,
          loaded: (folder) => !folder.title.isValid,
        ),
        onPressed: () => bloc.add(const SubmitFolderForm()),
      ),
    );
  }
}
