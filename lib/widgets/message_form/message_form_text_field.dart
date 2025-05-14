import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageFormTextField extends StatelessWidget {
  final bool emissionInProgressBool;
  final Color fillColor;
  final FocusNode focusNode;
  final InputBorder outlineInputBorder;
  final TextEditingController messageTextController;

  const MessageFormTextField({
    required this.emissionInProgressBool,
    required this.fillColor,
    required this.focusNode,
    required this.outlineInputBorder,
    required this.messageTextController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 300,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      focusNode: focusNode,
      controller: messageTextController,
      enabled: emissionInProgressBool == false,
      maxLines: null,
      expands: true,
      cursorColor: Colors.black,
      cursorHeight: 22,
      style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.06, fontFamily: 'Kalam'),
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        counter: const SizedBox.shrink(),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 4, 30),
      ),
    );
  }
}
