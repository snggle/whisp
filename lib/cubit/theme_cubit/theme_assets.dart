import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:whisp/widgets/outlined_icon.dart';

class ThemeAssets extends Equatable {
  final Image cloudStill;
  final Image cloudMoving;
  final Image snggleFace;
  final Color backgroundColor;
  final Color primaryColor;
  final Color particlesColor;
  final Color textColor;
  final OutlinedIcon themeChangeIcon;

  const ThemeAssets({
    required this.cloudStill,
    required this.cloudMoving,
    required this.snggleFace,
    required this.backgroundColor,
    required this.primaryColor,
    required this.particlesColor,
    required this.textColor,
    required this.themeChangeIcon,
  });

  @override
  List<Object?> get props => <Object>[cloudStill, cloudMoving, snggleFace, backgroundColor, primaryColor, particlesColor, textColor, themeChangeIcon];
}
