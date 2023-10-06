/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/clapping hands.svg
  String get clappingHands => 'assets/images/clapping hands.svg';

  /// File path: assets/images/collision.svg
  String get collision => 'assets/images/collision.svg';

  /// File path: assets/images/facebook.svg
  String get facebook => 'assets/images/facebook.svg';

  /// File path: assets/images/finger snap.svg
  String get fingerSnap => 'assets/images/finger snap.svg';

  /// File path: assets/images/flame.svg
  String get flame => 'assets/images/flame.svg';

  /// File path: assets/images/geometric lines.svg
  String get geometricLines => 'assets/images/geometric lines.svg';

  /// File path: assets/images/google.svg
  String get google => 'assets/images/google.svg';

  /// File path: assets/images/high voltage.svg
  String get highVoltage => 'assets/images/high voltage.svg';

  /// File path: assets/images/image 1357.svg
  String get image1357 => 'assets/images/image 1357.svg';

  /// File path: assets/images/loading.gif
  AssetGenImage get loading => const AssetGenImage('assets/images/loading.gif');

  /// File path: assets/images/logo-dark.svg
  String get logoDark => 'assets/images/logo-dark.svg';

  /// File path: assets/images/logo-light.svg
  String get logoLight => 'assets/images/logo-light.svg';

  /// File path: assets/images/meno-purple.png
  AssetGenImage get menoPurple =>
      const AssetGenImage('assets/images/meno-purple.png');

  /// File path: assets/images/meno-white.png
  AssetGenImage get menoWhite =>
      const AssetGenImage('assets/images/meno-white.png');

  /// File path: assets/images/onboarding-1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/images/onboarding-1.png');

  /// File path: assets/images/onboarding-2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/images/onboarding-2.png');

  /// File path: assets/images/onboarding-3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/images/onboarding-3.png');

  /// File path: assets/images/onboarding-4.png
  AssetGenImage get onboarding4 =>
      const AssetGenImage('assets/images/onboarding-4.png');

  /// File path: assets/images/raising hands.svg
  String get raisingHands => 'assets/images/raising hands.svg';

  /// File path: assets/images/red heart.svg
  String get redHeart => 'assets/images/red heart.svg';

  /// File path: assets/images/sparkles.svg
  String get sparkles => 'assets/images/sparkles.svg';

  /// File path: assets/images/thumbs up.svg
  String get thumbsUp => 'assets/images/thumbs up.svg';

  /// File path: assets/images/waving hand.svg
  String get wavingHand => 'assets/images/waving hand.svg';

  /// File path: assets/images/writing hand.svg
  String get writingHand => 'assets/images/writing hand.svg';

  /// List of all assets
  List<dynamic> get values => [
        clappingHands,
        collision,
        facebook,
        fingerSnap,
        flame,
        geometricLines,
        google,
        highVoltage,
        image1357,
        loading,
        logoDark,
        logoLight,
        menoPurple,
        menoWhite,
        onboarding1,
        onboarding2,
        onboarding3,
        onboarding4,
        raisingHands,
        redHeart,
        sparkles,
        thumbsUp,
        wavingHand,
        writingHand
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
