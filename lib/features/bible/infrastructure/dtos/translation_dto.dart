// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:meno/features/bible/domain/entities/translation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TranslationDto with EquatableMixin {
  TranslationDto({
    required this.name,
    required this.abbreviation,
    this.downloaded = false,
    this.available = false,
    this.id,
  });

  factory TranslationDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid translation JSON');
    }

    return TranslationDto(
      id: (json[_kId] as num?)?.toInt(),
      name: json[_kName] as String,
      abbreviation: json[_kAbbreviation] as String,
      downloaded: json[_kDownloaded] as bool,
      available: json[_kAvailable] as bool,
    );
  }

  @Id(assignable: true)
  int? id;
  final String name;
  final String abbreviation;
  final bool downloaded;
  final bool available;

  static const String _kId = 'id';
  static const String _kName = 'name';
  static const String _kAbbreviation = 'abbreviation';
  static const String _kDownloaded = 'downloaded';
  static const String _kAvailable = 'available';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kName: name,
    _kAbbreviation: abbreviation,
    _kDownloaded: downloaded,
    _kAvailable: available,
  };

  TranslationDto copyWith({
    String? name,
    String? abbreviation,
    int? id,
    bool? downloaded,
    bool? available,
  }) {
    return TranslationDto(
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      id: id ?? this.id,
      downloaded: downloaded ?? this.downloaded,
      available: available ?? this.available,
    );
  }

  @override
  List<Object?> get props => [name, abbreviation, id, downloaded, available];
}

extension TranslationDtoX on TranslationDto {
  Translation get toDomain {
    return Translation(
      id: id,
      name: name,
      abbreviation: abbreviation,
      downloaded: downloaded,
      available: available,
    );
  }
}
