import 'package:equatable/equatable.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';

abstract class AThemeState extends Equatable {
  final ThemeAssets themeAssets;

  const AThemeState({
    required this.themeAssets,
  });
}
