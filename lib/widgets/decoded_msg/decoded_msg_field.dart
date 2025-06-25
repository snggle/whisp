import 'dart:io';

import 'package:flutter/material.dart';

class DecodedMsgField extends StatelessWidget {
  final List<String> decodedMessagePartList;
  final List<int> brokenMessageIndexList;

  const DecodedMsgField({
    required this.decodedMessagePartList,
    this.brokenMessageIndexList = const <int>[],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: List<TextSpan>.generate(
          decodedMessagePartList.length,
          (int index) => TextSpan(
            text: decodedMessagePartList[index],
            style: TextStyle(
              color: brokenMessageIndexList.contains(index) ? Colors.transparent : Colors.black87,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontFamily: 'Kalam',
              fontWeight: FontWeight.bold,
              shadows: <Shadow>[
                Shadow(
                  blurRadius: Platform.isWindows ? 0.8 : 3.0,
                  color: Colors.black.withOpacity(0.5),
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
