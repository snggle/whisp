import 'package:flutter/material.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/square_button.dart';

class ActionButton extends StatefulWidget {
  final bool recordingInProgressBool;
  final bool recordingFinishingBool;
  final AnimationController fadeOutAnimationController;
  final ThemeAssets themeAssets;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const ActionButton({
    required this.recordingInProgressBool,
    required this.recordingFinishingBool,
    required this.fadeOutAnimationController,
    required this.themeAssets,
    required this.onStartRecording,
    required this.onStopRecording,
    super.key,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  late Animation<double> _buttonFadeOutAnimation;

  @override
  void initState() {
    super.initState();
    _buttonFadeOutAnimation = Tween<double>(begin: 1, end: 0).animate(widget.fadeOutAnimationController)..addListener(_rebuild);
  }

  @override
  void dispose() {
    _buttonFadeOutAnimation.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _buttonFadeOutAnimation.value,
      child: SquareButton.big(
        backgroundColor: widget.themeAssets.primaryColor,
        onTap: widget.recordingFinishingBool
            ? null
            : widget.recordingInProgressBool
                ? widget.onStopRecording
                : widget.onStartRecording,
        child: Icon(
          widget.recordingFinishingBool
              ? Icons.stop_rounded
              : widget.recordingInProgressBool
                  ? Icons.stop_rounded
                  : Icons.circle,
          size: widget.recordingFinishingBool
              ? 80
              : widget.recordingInProgressBool
                  ? 80
                  : 50,
          color: widget.recordingFinishingBool
              ? const Color(0xff244064)
              : widget.recordingInProgressBool
                  ? const Color(0xff244064)
                  : const Color(0xff652121),
        ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }
}
