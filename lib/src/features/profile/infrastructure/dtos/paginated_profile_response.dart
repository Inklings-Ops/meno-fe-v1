import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_profile_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
final class PaginatedProfileResponse<ProfileDto> with EquatableMixin {
  const PaginatedProfileResponse({
    required this.profiles,
    required this.totalPages,
    required this.totalItems,
    required this.currentPage,
  });

  factory PaginatedProfileResponse.fromJson(
    Map<String, dynamic> json,
    ProfileDto Function(Object?) fromJsonT,
  ) =>
      _$PaginatedProfileResponseFromJson(json, fromJsonT);

  final List<ProfileDto?> profiles;
  final int totalPages;
  final int totalItems;
  final int currentPage;

  @override
  List<Object?> get props => [profiles, totalItems, totalPages, currentPage];

  Map<String, dynamic> toJson(Object? Function(ProfileDto value) toJsonT) =>
      _$PaginatedProfileResponseToJson(this, toJsonT);

  @override
  bool? get stringify => true;
}
