import 'package:flutter/material.dart';

class OutlinedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color fillColor;
  final Color outlineColor;
  final double outlineWidth;

  const OutlinedIcon({
    required this.icon,
    this.size = 32,
    this.fillColor = Colors.yellow,
    this.outlineColor = Colors.black,
    this.outlineWidth = 3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: size,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        Text(
          String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: size,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}
