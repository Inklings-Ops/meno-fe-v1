import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_form/folder_form_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class CreateFolderModal extends StatefulWidget {
  const CreateFolderModal({super.key, this.initialFolder});

  final Folder? initialFolder;

  @override
  State<CreateFolderModal> createState() => _CreateFolderModalState();
}

class _CreateFolderModalState extends State<CreateFolderModal> {
  @override
  void initState() {
    super.initState();

    if (widget.initialFolder != null) {
      context.read<FolderFormCubit>().init(widget.initialFolder!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialFolder != null;

    final folderListBloc = context.read<FolderListBloc>();

    return BlocListener<FolderFormCubit, FolderFormState>(
      listenWhen: (p, c) => p.option != c.option,
      listener: (context, state) {
        state.option.fold(
          () {},
          (either) => either.fold(
            (failure) => context.showNoteError(failure),
            (folder) {
              if (isEdit) {
                context.pop();
                context.pop();
              } else {
                context.pop();
                folderListBloc.add(FolderListEvent.updateList(folder));
                context.push(Routes.folder, extra: {'folder': folder});
              }
            },
          ),
        );
      },
      child: Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: MModal(
          title: isEdit ? 'Rename Your Folder' : 'Give Your Folder a Name',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              10.verticalSpace,
              _TitleField(initialTitle: widget.initialFolder?.title),
              56.verticalSpace,
              const _SubmitButton(),
              132.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({this.initialTitle});

  final FolderTitle? initialTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).inputDecorationTheme;

    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.border!.borderSide.color),
    );

    final errorBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.errorBorder!.borderSide.color),
    );

    final disabledBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.disabledBorder!.borderSide.color),
    );

    final bloc = context.watch<FolderFormCubit>();

    return TextFormField(
      autofocus: true,
      style: MTextStyle.heading1Regular,
      initialValue: initialTitle?.getOr(),
      textAlign: TextAlign.center,
      onChanged: bloc.titleChanged,
      enabled: !bloc.state.loading,
      decoration: InputDecoration(
        hintText: 'Title',
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: disabledBorder,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<FolderFormCubit>();
    final isEdit = bloc.state.initialFolder != null;

    return MPrimaryButton(
      label: isEdit ? 'Rename Folder' : 'Create Folder',
      loading: bloc.state.loading,
      disabled: bloc.state.loading || !bloc.state.title.isValid,
      onPressed: bloc.onSubmit,
    );
  }
}
