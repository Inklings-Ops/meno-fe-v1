import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/domain/exceptions/note_exception.dart';

part 'folder_form_cubit.freezed.dart';
part 'folder_form_state.dart';

@lazySingleton
class FolderFormCubit extends Cubit<FolderFormState> {
  final INoteFacade _facade;
  FolderFormCubit({
    required INoteFacade facade,
  })  : _facade = facade,
        super(FolderFormState.initial());

  void init(Folder initialFolder) {
    emit(FolderFormState.initial().copyWith(
      initialFolder: initialFolder,
      title: initialFolder.title,
    ));
  }

  void titleChanged(String title) {
    emit(state.copyWith(title: FolderTitle(title)));
  }

  Future<void> onSubmit() async {
    final isTitleValid = state.title.isValid;

    if (isTitleValid) {
      emit(state.copyWith(loading: true));

      final result = state.initialFolder == null
          ? await _facade.createFolder(state.title)
          : await _facade.updateFolder(
              id: state.initialFolder!.id,
              title: state.title,
            );

      emit(state.copyWith(
        option: some(result),
        loading: false,
      ));
    }
  }
}
