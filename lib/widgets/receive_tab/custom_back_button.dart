import 'package:flutter/material.dart';

class CustomBackButton extends StatefulWidget {
  final Color color;
  final AnimationController fadeInAnimationController;
  final VoidCallback? onPopInvoked;

  const CustomBackButton({
    required this.color,
    required this.fadeInAnimationController,
    required this.onPopInvoked,
    super.key,
  });

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(widget.fadeInAnimationController)..addListener(_rebuild);
  }

  @override
  void dispose() {
    _fadeInAnimation.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.onPopInvoked == null,
      onPopInvoked: (bool didPop) => widget.onPopInvoked?.call(),
      child: Opacity(
        opacity: _fadeInAnimation.value,
        child: IconButton(
          onPressed: widget.onPopInvoked,
          icon: Icon(
            Icons.arrow_back,
            color: widget.color,
            size: 30,
          ),
        ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }
}
