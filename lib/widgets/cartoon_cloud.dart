import 'package:flutter/material.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';

class CartoonCloud extends StatefulWidget {
  final bool cloudMovingBool;
  final bool recordingFinishingBool;
  final AnimationController fadeInAnimationController;
  final AnimationController expansionAnimationController;
  final AnimationController snggleFaceFadeInController;
  final ThemeAssets themeAssets;

  const CartoonCloud({
    required this.cloudMovingBool,
    required this.recordingFinishingBool,
    required this.fadeInAnimationController,
    required this.expansionAnimationController,
    required this.snggleFaceFadeInController,
    required this.themeAssets,
    super.key,
  });

  @override
  State<CartoonCloud> createState() => _CartoonCloudState();
}

class _CartoonCloudState extends State<CartoonCloud> {
  late Animation<double> _fadeInAnimation;
  late Animation<double> _enlargeAnimation;
  late Animation<double> _snggleFaceFadeInAnimation;

  @override
  void initState() {
    super.initState();
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(widget.fadeInAnimationController)..addListener(_rebuild);
    _enlargeAnimation = Tween<double>(begin: 1, end: 10).animate(widget.expansionAnimationController)..addListener(_rebuild);
    _snggleFaceFadeInAnimation = Tween<double>(begin: 0, end: 1).animate(widget.snggleFaceFadeInController)..addListener(_rebuild);
  }

  @override
  void dispose() {
    _fadeInAnimation.removeListener(_rebuild);
    _enlargeAnimation.removeListener(_rebuild);
    _snggleFaceFadeInAnimation.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _enlargeAnimation.value,
      child: ClipRect(
        child: Align(
          heightFactor: 0.8,
          widthFactor: 0.8,
          alignment: Alignment.center,
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (widget.cloudMovingBool) widget.themeAssets.cloudMoving else widget.themeAssets.cloudStill,
                Positioned.fill(
                  bottom: 40,
                  child: Opacity(
                    opacity: _snggleFaceFadeInAnimation.value,
                    child: FractionallySizedBox(
                      widthFactor: 0.3,
                      child: Image.asset(
                        'assets/snggle_face.gif',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }
}
