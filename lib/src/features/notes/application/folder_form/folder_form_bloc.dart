import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'folder_form_bloc.freezed.dart';
part 'folder_form_event.dart';
part 'folder_form_state.dart';

class FolderFormBloc extends Bloc<FolderFormEvent, FolderFormState> {
  FolderFormBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(FolderFormLoaded(Folder.empty())) {
    on<InitializeFolderForm>(_onInit);
    on<FolderTitleChanged>(_onTitleChanged);
    on<SubmitFolderForm>(_onSubmit);
  }
  final INoteFacade _facade;

  void _onInit(InitializeFolderForm event, Emitter<FolderFormState> emit) {
    emit(FolderFormLoaded(event.folder));
  }

  void _onTitleChanged(
    FolderTitleChanged event,
    Emitter<FolderFormState> emit,
  ) {
    if (state is! FolderFormLoaded) return;
    final f = (state as FolderFormLoaded).folder.copyWith(title: event.title);
    return emit(FolderFormLoaded(f));
  }

  Future<void> _onSubmit(
    SubmitFolderForm event,
    Emitter<FolderFormState> emit,
  ) async {
    if (state is FolderFormSubmitInProgress) return;

    final folder = (state as FolderFormLoaded).folder;

    if (folder.title.isValid) {
      emit(const FolderFormSubmitInProgress());

      final failureOrF = folder.id.isValid
          ? await _facade.updateFolder(folder: folder)
          : await _facade.createFolder(folder);

      emit(failureOrF.fold(FolderFormFailure.new, FolderFormSubmitted.new));
    }
  }
}
