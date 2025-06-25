import 'package:flutter/material.dart';
import 'package:whisp/cubit/theme_cubit/a_theme_state.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/outlined_icon.dart';

class ThemeLightState extends AThemeState {
  ThemeLightState()
      : super(
          themeAssets: ThemeAssets(
            cloudStill: Image.asset('assets/cream_cloud.png', fit: BoxFit.cover),
            cloudMoving: Image.asset('assets/cream_cloud_anim.webp', fit: BoxFit.cover, filterQuality: FilterQuality.none),
            snggleFace: Image.asset('assets/snggle_face.gif', fit: BoxFit.contain),
            backgroundColor: const Color(0xffecad9d),
            primaryColor: const Color(0xffffead2),
            particlesColor: const Color(0xff726a60).withOpacity(0.1),
            textColor: Colors.black,
            themeChangeIcon: const OutlinedIcon(
              icon: Icons.sunny,
              outlineWidth: 4,
              outlineColor: Colors.black,
              fillColor: Color(0xffffead2),
              size: 40,
            ),
          ),
        );

  @override
  List<Object?> get props => <Object>[themeAssets];
}
