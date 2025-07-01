import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whisp/widgets/square_button.dart';

class DiceButton extends StatefulWidget {
  final bool disabledBool;
  final int maxRollNumber;
  final Color color;
  final ValueChanged<int> onRoll;

  const DiceButton({
    required this.disabledBool,
    required this.maxRollNumber,
    required this.color,
    required this.onRoll,
    super.key,
  });

  @override
  State<DiceButton> createState() => _DiceButtonState();
}

class _DiceButtonState extends State<DiceButton> {
  final List<String> _diceIconsPaths = <String>[
    'assets/dice-1.svg',
    'assets/dice-2.svg',
    'assets/dice-3.svg',
    'assets/dice-4.svg',
    'assets/dice-5.svg',
    'assets/dice-6.svg',
  ];
  int _diceIndex = Random().nextInt(6);

  @override
  Widget build(BuildContext context) {
    return SquareButton.small(
      backgroundColor: widget.color,
      onTap: widget.disabledBool ? null : _rollDice,
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
      int randomIndex = Random().nextInt(widget.maxRollNumber - 1);
      widget.onRoll(randomIndex);
      _diceIndex = Random().nextInt(6);
    });
  }
}
