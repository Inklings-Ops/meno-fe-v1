import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'folder_form_event.dart';
part 'folder_form_state.dart';

class FolderFormBloc extends Bloc<FolderFormEvent, FolderFormState> {
  FolderFormBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(FolderFormLoadSuccess(Folder.empty)) {
    on<FolderFormInitializeRequested>(_onInit);
    on<FolderFormTitleChanged>(_onTitleChanged);
    on<FolderFormSubmitRequested>(_onSubmit);
  }
  final INoteFacade _facade;

  void _onInit(
    FolderFormInitializeRequested event,
    Emitter<FolderFormState> emit,
  ) {
    emit(FolderFormLoadSuccess(event.folder));
  }

  void _onTitleChanged(
    FolderFormTitleChanged event,
    Emitter<FolderFormState> emit,
  ) {
    if (state is! FolderFormLoadSuccess) return;
    final f = (state as FolderFormLoadSuccess).folder.copyWith(
          title: event.title,
        );
    return emit(FolderFormLoadSuccess(f));
  }

  Future<void> _onSubmit(
    FolderFormSubmitRequested event,
    Emitter<FolderFormState> emit,
  ) async {
    if (state is FolderFormSubmitInProgress) return;

    final folder = (state as FolderFormLoadSuccess).folder;

    if (folder.title.isValid) {
      emit(const FolderFormSubmitInProgress());

      final failureOrF = folder.id.isValid
          ? await _facade.updateFolder(folder: folder)
          : await _facade.createFolder(folder);

      emit(
        failureOrF.fold(
          FolderFormSubmitFailed.new,
          FolderFormSubmitSuccess.new,
        ),
      );
    }
  }
}
