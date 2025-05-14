import 'dart:math';

import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

class MessageForm extends StatelessWidget {
  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  );

  final bool clearButtonDisabledBool;
  final bool emissionInProgressBool;
  final bool showPlaceholderBool;
  final FocusNode focusNode;
  final ThemeAssets themeAssets;
  final TextEditingController messageTextController;
  final SvgPicture dicePicture;
  final VoidCallback onDiceButtonPressed;
  final VoidCallback onClearButtonPressed;

  MessageForm({
    required this.clearButtonDisabledBool,
    required this.emissionInProgressBool,
    required this.showPlaceholderBool,
    required this.focusNode,
    required this.themeAssets,
    required this.messageTextController,
    required this.dicePicture,
    required this.onDiceButtonPressed,
    required this.onClearButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontFamily: 'Pacifico',
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
      fontSize: 18,
      color: themeAssets.textColor,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 128),
          Stack(
            children: <Widget>[
              TextFormField(
                maxLength: 300,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                focusNode: focusNode,
                controller: messageTextController,
                enabled: emissionInProgressBool == false,
                maxLines: 6,
                cursorColor: Colors.black,
                cursorHeight: 26,
                style: const TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'Kalam'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: themeAssets.primaryColor,
                  counter: const SizedBox.shrink(),
                  enabledBorder: _outlineInputBorder,
                  focusedBorder: _outlineInputBorder,
                  disabledBorder: _outlineInputBorder,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 30),
                ),
              ),
              if (showPlaceholderBool)
                Positioned(
                  left: 14,
                  top: 16,
                  child: Text('Type your message',
                      style: TextStyle(color: emissionInProgressBool ? Colors.black38 : Colors.black38, fontSize: 22, fontFamily: 'Kalam')),
                ),
              Positioned(
                right: 8,
                bottom: 11,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: messageTextController,
                  builder: (BuildContext context, TextEditingValue textEditingValue, _) {
                    return Text('${textEditingValue.text.length}/300', style: textStyle.copyWith(fontSize: 16, color: Colors.black54));
                  },
                ),
              ),
              Positioned(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Particles(
                      awayRadius: 150,
                      particles: _createParticles(),
                      height: 248,
                      width: MediaQuery.of(context).size.width,
                      onTapAnimation: true,
                      awayAnimationDuration: const Duration(milliseconds: 100),
                      awayAnimationCurve: Curves.linear,
                      enableHover: true,
                      hoverRadius: 90,
                      connectDots: false,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SquareButton(
                backgroundColor: themeAssets.primaryColor,
                onTap: emissionInProgressBool ? null : onDiceButtonPressed,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: dicePicture,
                ),
              ),
              const SizedBox(width: 15),
              SquareButton(
                  backgroundColor: themeAssets.primaryColor,
                  onTap: clearButtonDisabledBool ? null : onClearButtonPressed,
                  child: const Icon(
                    Icons.close,
                    size: 30,
                  ))
            ],
          ),
        ],
      ),
    );
  }

  List<Particle> _createParticles() {
    Random rng = Random();
    List<Particle> particles = <Particle>[];
    for (int i = 0; i < 10; i++) {
      particles.add(Particle(
        color: themeAssets.particlesColor,
        size: rng.nextDouble() * 10,
        velocity: Offset(rng.nextDouble() * 50 * _randomSign(), rng.nextDouble() * 50 * _randomSign()),
      ));
    }
    return particles;
  }

  double _randomSign() {
    Random rng = Random();
    return rng.nextBool() ? 1 : -1;
  }
}
