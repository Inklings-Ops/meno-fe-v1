part of 'broadcast_form_cubit.dart';

class BroadcastFormState with EquatableMixin {
  const BroadcastFormState({
    required this.title,
    required this.description,
    this.artwork,
    this.cohosts,
    this.shouldRecord = false,
    this.loading = false,
  });

  final SingleLineString title;
  final BroadcastDescription description;
  final BroadcastArtwork? artwork;
  final List<String>? cohosts;
  final bool shouldRecord;
  final bool loading;

  bool get isFormValid => title.isValid && description.isValid;

  BroadcastFormState copyWith({
    SingleLineString? title,
    BroadcastDescription? description,
    BroadcastArtwork? artwork,
    List<String>? cohosts,
    bool? shouldRecord,
    bool? loading,
  }) {
    return BroadcastFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      artwork: artwork ?? this.artwork,
      cohosts: cohosts ?? this.cohosts,
      shouldRecord: shouldRecord ?? this.shouldRecord,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        artwork,
        cohosts,
        shouldRecord,
        loading,
      ];
}
