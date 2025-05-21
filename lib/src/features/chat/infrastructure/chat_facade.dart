import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/core.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart'
    show Broadcast;
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
  Future<Either<ChatException, PaginatedList<Chat?>>> getChatMessages({
    required Uid<Broadcast> broadcastId,
    OrderBy? orderBy = OrderBy.DESC,
    int? page = 1,
    int? size = 50,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const ChatNoInternetException());

    try {
      final response = await _remote.chatMessages(
        broadcastId: broadcastId.getOr(),
        orderBy: orderBy?.lowercaseName,
        page: page,
        size: size,
      );
      final data = response.data!;
      final paginatedList = PaginatedList(
        items: data.chatMessages.map((dto) => dto?.toDomain).toList(),
        currentPage: data.currentPage,
        totalItems: data.totalItems,
        totalPages: data.totalPages,
      );
      return right(paginatedList);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return Left(error);
    } on TimeoutException {
      return const Left(ChatTimeoutException());
    }
  }
}

ChatException _handleDioException(DioException error) {
  final errorData = error.response?.data;

  if (errorData == null) return const ChatUnknownException();

  final baseError = errorData as Map<String, dynamic>;
  final base = BaseResponse.fromJson(baseError, (_) => null);

  return switch (base.error) {
    final Map<String, dynamic> errors => ChatValidationException(errors),
    _ => ChatExceptionWithMessage(base.message ?? 'Unknown error'),
  };
}
