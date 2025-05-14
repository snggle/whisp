import 'package:flutter/material.dart';

class DecodedMessageField extends StatelessWidget {
  final List<String> decodedMessageParts;
  final List<int> brokenMessageIndexes;

  const DecodedMessageField({
    required this.decodedMessageParts,
    this.brokenMessageIndexes = const <int>[],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: List<TextSpan>.generate(
          decodedMessageParts.length,
          (int index) => TextSpan(
            text: decodedMessageParts[index],
            style: TextStyle(
              color: brokenMessageIndexes.contains(index) ? Colors.transparent : Colors.black87,
              fontSize: 25,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              shadows: <Shadow>[
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
