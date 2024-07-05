import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_form/folder_form_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/application/note_list/notes_bloc.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/empty_folder_list_widget.dart';
import 'package:meno_fe_v1/src/router/routes.dart';

import 'folder_list_failure_widget.dart';
import 'folder_list_tile.dart';

class FolderListWidget extends StatelessWidget {
  const FolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<FolderListBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<FolderFormCubit, FolderFormState>(
          listenWhen: (p, c) => p.option != c.option,
          listener: (context, state) {
            state.option.fold(
              () {},
              (either) => either.fold(
                (l) => null,
                (newFolder) => bloc.add(FolderListEvent.updateList(newFolder)),
              ),
            );
          },
        ),
        BlocListener<NotesBloc, NotesState>(
          listener: (context, state) {
            // TODO: implement listener
          },
        ),
      ],
      child: BlocBuilder<FolderListBloc, FolderListState>(
        bloc: bloc,
        buildWhen: (p, c) => p != c,
        builder: (context, state) => state.when(
          failure: (_) => const FolderListFailureWidget(),
          loading: () => const MLoadingIndicator.box(),
          success: (folders) {
            if (folders.isEmpty) return const EmptyFolderListWidget();

            return ListView.separated(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: MCore.large).r,
              itemCount: folders.length,
              separatorBuilder: (context, index) => MCore.large.verticalSpace,
              itemBuilder: (context, i) {
                final folder = folders[i]!;
                return FolderListTile(
                  folder: folder,
                  onTap: () {
                    context.push(Routes.folder, extra: {'folder': folder});
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
