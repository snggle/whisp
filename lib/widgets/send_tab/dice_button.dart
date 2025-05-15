import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whisp/widgets/square_button.dart';
import 'package:whisp/shared/utils/predefined_messages.dart';

class DiceButton extends StatefulWidget {
  final bool emissionInProgressBool;
  final Color color;
  final TextEditingController messageTextController;

  const DiceButton({
    required this.emissionInProgressBool,
    required this.color,
    required this.messageTextController,
    super.key,
  });

  @override
  State<DiceButton> createState() => _DiceButtonState();
}

class _DiceButtonState extends State<DiceButton> {
  final List<String> _diceIconsPaths = <String>[
    'assets/dice-1-svgrepo-com.svg',
    'assets/dice-2-svgrepo-com.svg',
    'assets/dice-3-svgrepo-com.svg',
    'assets/dice-4-svgrepo-com.svg',
    'assets/dice-5-svgrepo-com.svg',
    'assets/dice-6-svgrepo-com.svg',
  ];
  int _diceIndex = Random().nextInt(6);

  @override
  Widget build(BuildContext context) {
    return SquareButton(
      backgroundColor: widget.color,
      onTap: widget.emissionInProgressBool ? null : _rollDice,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SvgPicture.asset(
          _diceIconsPaths[_diceIndex],
        ),
      ),
    );
  }

  void _rollDice() {
    setState(() {
      int randomIndex = Random().nextInt(PredefinedMessages.exampleMessages.length - 1);
      widget.messageTextController.text = PredefinedMessages.exampleMessages[randomIndex];
      _diceIndex = Random().nextInt(6);
    });
  }
}
