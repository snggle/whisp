import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/shared/utils/predefined_messages.dart';
import 'package:whisp/widgets/dice_button.dart';
import 'package:whisp/widgets/message_form/message_form_text_field.dart';
import 'package:whisp/widgets/square_button.dart';

class MessageForm extends StatelessWidget {
  final bool clearButtonDisabledBool;
  final bool emissionInProgressBool;
  final bool showPlaceholderBool;
  final FocusNode focusNode;
  final ThemeAssets themeAssets;
  final TextEditingController messageTextController;
  final VoidCallback onClearButtonPressed;

  const MessageForm({
    required this.clearButtonDisabledBool,
    required this.emissionInProgressBool,
    required this.showPlaceholderBool,
    required this.focusNode,
    required this.themeAssets,
    required this.messageTextController,
    required this.onClearButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  children: <Widget>[
                    MessageFormTextField(
                      emissionInProgressBool: emissionInProgressBool,
                      fillColor: themeAssets.primaryColor,
                      focusNode: focusNode,
                      messageTextController: messageTextController,
                      outlineInputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    Positioned(
                      child: IgnorePointer(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Particles(
                            awayRadius: 150,
                            particles: _createParticles(),
                            height: constraints.maxHeight - 10,
                            width: constraints.maxWidth,
                            onTapAnimation: true,
                            awayAnimationDuration: const Duration(milliseconds: 100),
                            awayAnimationCurve: Curves.linear,
                            enableHover: true,
                            hoverRadius: 90,
                            connectDots: false,
                          ),
                        ),
                      ),
                    ),
                    if (showPlaceholderBool)
                      Positioned(
                        left: 14,
                        top: 8,
                        child: Text(
                          'Type your message',
                          style: TextStyle(color: Colors.black38, fontSize: MediaQuery.of(context).size.width * 0.06, fontFamily: 'Kalam'),
                        ),
                      ),
                    Positioned(
                      right: 8,
                      bottom: 11,
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: messageTextController,
                        builder: (BuildContext context, TextEditingValue textEditingValue, _) {
                          return Text(
                            '${textEditingValue.text.length}/300',
                            style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              color: Colors.black54,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DiceButton(
                  disabledBool: emissionInProgressBool,
                  maxRollNumber: PredefinedMessages.exampleMessages.length,
                  color: themeAssets.primaryColor,
                  onRoll: _onRoll,
                ),
                SquareButton.small(
                  backgroundColor: themeAssets.primaryColor,
                  onTap: clearButtonDisabledBool ? null : onClearButtonPressed,
                  child: const Icon(
                    Icons.close,
                    size: 36,
                  ),
                )
              ],
            ),
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

  void _onRoll(int result) {
    messageTextController.text = PredefinedMessages.exampleMessages[result];
  }
}
