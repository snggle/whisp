import 'package:flutter/material.dart';
import 'package:whisp/cubit/theme_cubit/a_theme_state.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/outlined_icon.dart';

class ThemeDarkState extends AThemeState {
  ThemeDarkState()
      : super(
          themeAssets: ThemeAssets(
            cloudStill: Image.asset('assets/blue_cloud.png', fit: BoxFit.cover),
            cloudMoving: Image.asset('assets/blue_cloud_anim.webp', fit: BoxFit.cover, filterQuality: FilterQuality.none),
            snggleFace: Image.asset('assets/snggle_face.gif', fit: BoxFit.contain),
            backgroundColor: const Color(0xff245161),
            primaryColor: const Color(0xffd6e7f2),
            particlesColor: const Color(0xff5e676c).withOpacity(0.1),
            textColor: Colors.white,
            themeChangeIcon: const OutlinedIcon(
              icon: Icons.nightlight,
              outlineWidth: 4,
              outlineColor: Colors.black,
              fillColor: Color(0xffd6e7f2),
              size: 40,
            ),
          ),
        );

  @override
  List<Object?> get props => <Object>[themeAssets];
}
