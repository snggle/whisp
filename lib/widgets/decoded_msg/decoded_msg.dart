import 'package:flutter/material.dart';
import 'package:whisp/widgets/decoded_msg/decoded_msg_field.dart';

class DecodedMsg extends StatefulWidget {
  final AnimationController fadeInAnimationController;
  final List<int> brokenMessageIndexList;
  final List<String>? decodedMessagePartList;

  const DecodedMsg({
    required this.fadeInAnimationController,
    required this.brokenMessageIndexList,
    required this.decodedMessagePartList,
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
        child: widget.decodedMessagePartList == null
            ? const SizedBox()
            : DecodedMsgField(
                brokenMessageIndexList: widget.brokenMessageIndexList,
                decodedMessagePartList: widget.decodedMessagePartList!,
              ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }
}
