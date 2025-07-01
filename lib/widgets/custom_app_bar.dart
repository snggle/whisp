import 'package:flutter/material.dart';
import 'package:whisp/widgets/icons_alignment.dart';

class CustomAppBar extends StatelessWidget {
  final double iconsOpacity;
  final IconsAlignment iconsAlignment;
  final List<Widget> iconButtons;
  final int totalSlots;

  const CustomAppBar({
    this.iconsOpacity = 1,
    this.iconsAlignment = IconsAlignment.start,
    this.iconButtons = const <Widget>[],
    this.totalSlots = 7,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> fittedWidgets = iconButtons
        .take(totalSlots)
        .map((Widget iconButton) => Expanded(
                child: FittedBox(
              fit: BoxFit.scaleDown,
              child: iconButton,
            )))
        .toList();

    int spacerCount = totalSlots - fittedWidgets.length;
    List<Widget> spacers = List<Widget>.generate(
      spacerCount.clamp(0, totalSlots),
      (_) => Expanded(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.18,
        ),
      ),
    );

    List<Widget> finalChildren = iconsAlignment == IconsAlignment.start ? <Widget>[...fittedWidgets, ...spacers] : <Widget>[...spacers, ...fittedWidgets];

    return Opacity(
      opacity: iconsOpacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: finalChildren),
      ),
    );
  }
}
