import 'package:flutter/material.dart';
import 'package:whisp/widgets/decoded_message_field.dart';

class DecodedMsg extends StatefulWidget {
  final AnimationController fadeInAnimationController;
  final List<int> brokenMessageIndexes;
  final List<String>? decodedMessageParts;

  const DecodedMsg({
    required this.fadeInAnimationController,
    required this.brokenMessageIndexes,
    required this.decodedMessageParts,
    super.key,
  });

  @override
  State<DecodedMsg> createState() => _DecodedMsgState();
}

class _DecodedMsgState extends State<DecodedMsg> {
  late Animation<double> _msgFadeInAnimation;

  @override
  void initState() {
    super.initState();
    _msgFadeInAnimation = Tween<double>(begin: 0, end: 1).animate(widget.fadeInAnimationController)..addListener(_rebuild);
  }

  @override
  void dispose() {
    _msgFadeInAnimation.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _msgFadeInAnimation.value,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.decodedMessageParts == null
            ? const SizedBox()
            : DecodedMessageField(
                brokenMessageIndexes: widget.brokenMessageIndexes,
                decodedMessageParts: widget.decodedMessageParts!,
              ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }
}
