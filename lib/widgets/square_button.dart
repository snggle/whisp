import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onTap;
  final double sideLength;
  final double borderWidth;
  final double borderRadius;

  const SquareButton({
    required this.backgroundColor,
    required this.child,
    required this.onTap,
    this.sideLength = 50,
    this.borderWidth = 2,
    this.borderRadius = 10,
    super.key,
  });

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
