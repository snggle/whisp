import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/square_button.dart';
import 'package:flutter/material.dart';

class ButtonsPanel extends StatelessWidget {
  final bool emissionInProgressBool;
  final bool msgEmptyBool;
  final ThemeAssets themeAssets;
  final VoidCallback onSaveButtonPressed;
  final VoidCallback onPlayButtonPressed;
  final VoidCallback onStopButtonPressed;
  final VoidCallback onShareButtonPressed;

  const ButtonsPanel({
    required this.emissionInProgressBool,
    required this.msgEmptyBool,
    required this.themeAssets,
    required this.onSaveButtonPressed,
    required this.onPlayButtonPressed,
    required this.onStopButtonPressed,
    required this.onShareButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool buttonsDisabledBool = emissionInProgressBool || msgEmptyBool;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SquareButton(
            backgroundColor: themeAssets.primaryColor,
            onTap: buttonsDisabledBool ? null : onSaveButtonPressed,
            height: 80,
            width: 80,
            borderWidth: 2.5,
            borderRadius: 16,
            child: const Icon(
              Icons.save_alt,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          SquareButton(
            backgroundColor: themeAssets.primaryColor,
            onTap: msgEmptyBool
                ? null
                : emissionInProgressBool
                    ? onStopButtonPressed
                    : onPlayButtonPressed,
            width: 110,
            height: 108,
            borderWidth: 2.5,
            borderRadius: 20,
            child: Icon(
              emissionInProgressBool ? Icons.stop_rounded : Icons.play_arrow_rounded,
              size: 80,
              color: emissionInProgressBool ? const Color(0xff244064) : const Color(0xff396521),
            ),
          ),
          const SizedBox(width: 20),
          SquareButton(
            backgroundColor: themeAssets.primaryColor,
            onTap: buttonsDisabledBool ? null : onShareButtonPressed,
            height: 80,
            width: 80,
            borderWidth: 2.5,
            borderRadius: 16,
            child: const Icon(
              Icons.share,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
