import 'package:flutter/material.dart';
import 'package:whisp/widgets/outlined_icon.dart';

class SettingsButton extends StatefulWidget {
  final AnimationController fadeOutAnimationController;
  final Color color;
  final VoidCallback? onPressed;

  const SettingsButton({
    required this.fadeOutAnimationController,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
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
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5),
        child: IconButton(
          icon: OutlinedIcon(
            icon: Icons.settings,
            outlineColor: Colors.black,
            fillColor: widget.color,
            outlineWidth: 4,
            size: 40,
          ),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }
}
