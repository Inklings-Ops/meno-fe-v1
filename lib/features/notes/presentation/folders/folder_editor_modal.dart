import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/shared/extensions/m_snack_bar_extension.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderEditorModal extends WatchingWidget {
  const FolderEditorModal({super.key, this.folderId});

  final String? folderId;

  static Future<bool?> show(BuildContext context, [String? folderId]) {
    return showModalBottomSheet<bool?>(
      context: context,
      builder: (context) => FolderEditorModal(folderId: folderId),
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingleton<FolderEditorManager>(() {
          return FolderEditorManager(
            folderId: folderId,
            repository: di<INotesRepository>(),
          );
        }, onCreated: (instance) => instance.initialize.run());
      },
    );

    registerHandler(
      select: (FolderEditorManager m) => m.submit.errors,
      handler: (context, errors, cancel) {
        if (errors == null) return;
        final error = errors.error;
        if (error is MenoException) {
          context.showErrorSnackBar(error.message);
        } else {
          context.showErrorSnackBar(error.toString());
        }
      },
    );

    registerHandler(
      select: (FolderEditorManager m) => m.submit,
      handler: (context, newValue, cancel) => context.pop(true),
    );

    return const _EditorContent();
  }
}

class _EditorContent extends WatchingWidget {
  const _EditorContent();

  @override
  Widget build(BuildContext context) {
    // Wait for initialize to complete before building the form
    final isEdit = watchValue((FolderEditorManager m) => m.isEdit);
    final isLoading = watchValue(
      (FolderEditorManager m) => m.initialize.isRunning,
    );

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: MLoadingIndicator.box()),
      );
    }

    return Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child: MModal(
        title: isEdit ? 'Rename Your Folder' : 'Give Your Folder a Name',
        builder: (context) => const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            FolderFormTitleField(),
            SizedBox(height: 56),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class FolderFormTitleField extends WatchingWidget {
  const FolderFormTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).inputDecorationTheme;
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.border!.borderSide.color),
    );

    final errorBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.errorBorder!.borderSide.color),
    );

    final disabledBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.disabledBorder!.borderSide.color),
    );

    final manager = di<FolderEditorManager>();
    final folder = watchValue((FolderEditorManager m) => m.folder);

    final controller = createOnce(() {
      final currentTitle = folder.title.getOrElse((_) => '');
      return TextEditingController(text: currentTitle);
    });

    return TextFormField(
      autofocus: true,
      style: textTheme.heading1Regular,
      controller: controller,
      textAlign: TextAlign.center,
      enabled: !watchValue((FolderEditorManager m) => m.submit.isRunning),
      onChanged: manager.onTitleChanged,
      validator: (_) => folder.title.failureOrNull?.msg,
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
    );
  }
}

class _SubmitButton extends WatchingWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final manager = di<FolderEditorManager>();
    final isEdit = watchValue((FolderEditorManager m) => m.isEdit);
    final isLoading = watchValue((FolderEditorManager m) => m.submit.isRunning);
    return MPrimaryButton(
      label: isEdit ? 'Save Changes' : 'Create Folder',
      loading: isLoading,
      disabled: isLoading,
      onPressed: manager.submit.run,
    );
  }
}
