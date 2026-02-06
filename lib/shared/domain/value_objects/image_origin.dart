import 'dart:io' show File;

import 'package:equatable/equatable.dart';

sealed class ImageOrigin with EquatableMixin {
  const ImageOrigin();
}

final class NetworkImage extends ImageOrigin {
  const NetworkImage(this.url);

  final String url;

  @override
  List<Object?> get props => [url];
}

final class LocalImage extends ImageOrigin {
  const LocalImage(this.file);

  final File file;

  @override
  List<Object?> get props => [file];
}
