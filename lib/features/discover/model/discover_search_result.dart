import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/model/entities/broadcast.dart';
import 'package:meno/features/profile/model/entities/profile.dart';

sealed class DiscoverSearchResult with EquatableMixin {
  const DiscoverSearchResult();
}

final class BroadcastResult extends DiscoverSearchResult {
  const BroadcastResult(this.broadcast);

  final Broadcast broadcast;

  @override
  List<Object?> get props => [broadcast];
}

final class ProfileResult extends DiscoverSearchResult {
  const ProfileResult(this.profile);

  final Profile profile;

  @override
  List<Object?> get props => [profile];
}
