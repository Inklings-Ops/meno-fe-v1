import 'package:injectable/injectable.dart';

import '../../domain/entities/broadcast_list_entity.dart';
import '../dtos/broadcast_list_dto.dart';
import 'broadcast_mapper.dart';

@singleton
class BroadcastListMapper {
  final _mapper = BroadcastMapper();

  BroadcastListEntity? toDomain(BroadcastListDto? dto) {
    if (dto == null) return null;

    return BroadcastListEntity(
      broadcasts: dto.broadcasts.map(_mapper.broadcastToDomain).toList(),
      currentPage: dto.currentPage,
      totalItems: dto.totalItems,
      totalPages: dto.totalPages,
    );
  }

  BroadcastListDto? toDto(BroadcastListEntity? domain) {
    if (domain == null) return null;

    return BroadcastListDto(
      broadcasts: domain.broadcasts.map(_mapper.broadcastToDto).toList(),
      currentPage: domain.currentPage,
      totalItems: domain.totalItems,
      totalPages: domain.totalPages,
    );
  }
}
