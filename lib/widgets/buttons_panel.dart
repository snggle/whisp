import 'package:flutter/material.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/square_button.dart';

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
          const Spacer(flex: 2),
          Expanded(
            flex: 8,
            child: SquareButton.medium(
              backgroundColor: themeAssets.primaryColor,
              onTap: buttonsDisabledBool ? null : onSaveButtonPressed,
              child: const Icon(
                Icons.save_alt,
                size: 40,
              ),
            ),
          ),
          const Spacer(flex: 2),
          Expanded(
            flex: 10,
            child: SquareButton.big(
              backgroundColor: themeAssets.primaryColor,
              onTap: msgEmptyBool
                  ? null
                  : emissionInProgressBool
                      ? onStopButtonPressed
                      : onPlayButtonPressed,
              child: Icon(
                emissionInProgressBool ? Icons.stop_rounded : Icons.play_arrow_rounded,
                size: 80,
                color: emissionInProgressBool ? const Color(0xff244064) : const Color(0xff396521),
              ),
            ),
          ),
          const Spacer(flex: 2),
          Expanded(
            flex: 8,
            child: SquareButton.medium(
              backgroundColor: themeAssets.primaryColor,
              onTap: buttonsDisabledBool ? null : onShareButtonPressed,
              child: const Icon(
                Icons.share,
                size: 40,
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
