import 'package:equatable/equatable.dart';
import 'package:meno/features/broadcast/model/entities/broadcast.dart';
import 'package:meno/features/profile/model/proxies/user_profile_proxy.dart';

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
  const ProfileResult(this.proxy);

  final UserProfileProxy proxy;

  @override
  List<Object?> get props => [proxy];
}
