// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:meno/_core/_core.dart' as core;
import 'package:meno/features/broadcast/model/entities/broadcast.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class FavouriteBroadcast with EquatableMixin {
  FavouriteBroadcast({
    required this.broadcastId,
    required this.ownerId,
    required this.title,
    required this.creatorName,
    required this.savedAt,
    this.imageUrl,
  });

  @Id()
  int id = 0;

  @Index()
  final String broadcastId;

  final String ownerId;

  final String title;

  final String creatorName;

  @Property(type: PropertyType.date)
  final DateTime savedAt;

  final String? imageUrl;

  @override
  List<Object?> get props => throw UnimplementedError();
}

extension FavouriteToBroadcastX on Broadcast {
  FavouriteBroadcast toFavourite({required core.Id ownerId}) {
    return FavouriteBroadcast(
      broadcastId: id.getOrCrash(),
      ownerId: ownerId.getOrCrash(),
      title: title.getOrCrash(),
      creatorName: hostName.getOrCrash(),
      savedAt: DateTime.now(),
      imageUrl: imageUrl,
    );
  }
}

extension BroadcastToFavouriteX on FavouriteBroadcast {
  Broadcast get toBroadcast {
    return Broadcast(
      id: core.Id.fromString(broadcastId),
      title: core.SingleLineString(title),
      description: core.MultiLineString.empty,
      imageUrl: imageUrl,
      creatorFullName: core.SingleLineString(creatorName),
      fullName: core.SingleLineString(creatorName),
    );
  }
}
