import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onTap;
  final double sideLength;
  final double borderWidth;
  final double borderRadius;

  const SquareButton.small({
    required this.backgroundColor,
    required this.child,
    required this.onTap,
    super.key,
  })  : sideLength = 60,
        borderWidth = 2,
        borderRadius = 10;

  const SquareButton.medium({
    required this.backgroundColor,
    required this.child,
    required this.onTap,
    super.key,
  })  : sideLength = 80,
        borderWidth = 2.5,
        borderRadius = 16;

  const SquareButton.big({
    required this.backgroundColor,
    required this.child,
    required this.onTap,
    super.key,
  })  : sideLength = 110,
        borderWidth = 2.5,
        borderRadius = 20;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Opacity(
              opacity: onTap == null ? 0.5 : 1,
              child: Container(
                height: sideLength,
                width: sideLength,
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
          ),
        ),
      ),
    );
  }
}
