import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum AssetsImage {
  defaultIcon(
      description: 'E-Dutainment - Default Icon',
      path: 'icons/default',
      extension: 'png'),
  levelsGif(
      description: 'E-Dutainment - Levels',
      path: 'icons/levels',
      extension: 'gif'),
  backgroundPosters(
      description: 'E-Dutainment - Posters Background',
      path: 'backgrounds/posters-background',
      extension: 'png'),
  bannerColor(
      description: 'Marmignon Brothers - Banner with Color',
      path: 'banners/banner-color',
      extension: 'png'),
  a1(
      description: 'E-Dutainment - A1 Profile',
      path: 'profile/a1',
      extension: 'png'),
  a2(
      description: 'E-Dutainment - A2 Profile',
      path: 'profile/a2',
      extension: 'png'),
  b1(
      description: 'E-Dutainment - B1 Profile',
      path: 'profile/b1',
      extension: 'png'),
  b2(
      description: 'E-Dutainment - B2 Profile',
      path: 'profile/b2',
      extension: 'png'),
  c1(
      description: 'E-Dutainment - C1 Profile',
      path: 'profile/c1',
      extension: 'png'),
  c2(
      description: 'E-Dutainment - C2 Profile',
      path: 'profile/c2',
      extension: 'png'),
  ;

  final String _description, _path, _extension;

  String get description => _description;

  String get path => _path;

  String get extension => _extension;

  const AssetsImage(
      {required String description,
      required String path,
      required String extension})
      : _description = description,
        _path = 'assets/images/$path.$extension',
        _extension = extension;

  SvgPicture toSvg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
  }) =>
      SvgPicture.asset(
        path,
        key: key,
        matchTextDirection: matchTextDirection,
        bundle: bundle,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder: placeholderBuilder,
        semanticsLabel: semanticsLabel,
        excludeFromSemantics: excludeFromSemantics,
        clipBehavior: clipBehavior,
        theme: theme!,
      );

  Image toImage(
          {Key? key,
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
          int? cacheHeight}) =>
      Image.asset(path,
          key: key,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
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
          cacheHeight: cacheHeight);
}
