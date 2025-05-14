import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onTap;
  final double height;
  final double width;
  final double borderWidth;
  final double borderRadius;

  const SquareButton({
    required this.backgroundColor,
    required this.child,
    required this.onTap,
    this.height = 50,
    this.width = 50,
    this.borderWidth = 2,
    this.borderRadius = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.black,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}