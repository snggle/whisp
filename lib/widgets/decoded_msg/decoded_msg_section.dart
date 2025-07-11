import 'package:flutter/material.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/custom_app_bar.dart';
import 'package:whisp/widgets/custom_back_button.dart';
import 'package:whisp/widgets/decoded_msg/decoded_msg.dart';
import 'package:whisp/widgets/decoded_msg/decoded_msg_background.dart';

class DecodedMsgSection extends StatelessWidget {
  final AnimationController cloudBackgroundFadeInController;
  final AnimationController msgFadeInController;
  final AnimationController backButtonFadeInController;
  final ThemeAssets themeAssets;
  final VoidCallback onBackButtonPressed;
  final List<int> brokenMessageIndexList;
  final List<String>? decodedMessagePartList;

  const DecodedMsgSection({
    required this.cloudBackgroundFadeInController,
    required this.msgFadeInController,
    required this.backButtonFadeInController,
    required this.themeAssets,
    required this.onBackButtonPressed,
    required this.brokenMessageIndexList,
    required this.decodedMessagePartList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecodedMsgBackground(
            fadeInAnimationController: cloudBackgroundFadeInController,
            themeAssets: themeAssets,
          ),
        ),
        SafeArea(
          child: Column(
            children: <Widget>[
              CustomAppBar(
                iconButtons: <Widget>[
                  CustomBackButton(
                    fadeInAnimationController: backButtonFadeInController,
                    color: themeAssets.primaryColor,
                    onPopInvoked: onBackButtonPressed,
                  ),
                ],
              ),
              Expanded(
                flex: 8,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: DecodedMsg(
                      fadeInAnimationController: msgFadeInController,
                      decodedMessagePartList: decodedMessagePartList,
                      brokenMessageIndexList: brokenMessageIndexList,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
