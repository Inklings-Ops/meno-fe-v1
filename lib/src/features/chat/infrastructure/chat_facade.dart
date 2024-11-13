import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/constants/constants.dart';
import 'package:meno_fe_v1/src/shared/value_objects/uid.dart';

@Injectable(as: IChatFacade)
class ChatFacade implements IChatFacade {
  const ChatFacade({
    required ChatRemoteDatasource remote,
    required NetworkService network,
  })  : _remote = remote,
        _network = network;

  final ChatRemoteDatasource _remote;
  final NetworkService _network;

  @override
  Future<Either<String, List<Chat?>>> getChatMessages(
    Uid<Broadcast> broadcastId,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(MErrorMessages.networkError);

    try {
      final res = await _remote.chatMessages(broadcastId: broadcastId.getOr());
      final chats = res.data?.chatMessages.map((c) => c?.toDomain).toList();
      return right(chats ?? []);
    } catch (e) {
      return left(e.toString());
    }
  }
}
