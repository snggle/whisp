import 'package:flutter/material.dart';
import 'package:whisp/widgets/custom_app_bar.dart';

class TabLayout extends StatelessWidget {
  final CustomAppBar customAppBar;
  final Widget? topWidget;
  final Widget? bottomWidget;
  final Widget? middleSpacerArea;
  final Widget? bottomSpacerArea;

  const TabLayout({
    required this.customAppBar,
    this.topWidget,
    this.bottomWidget,
    this.middleSpacerArea,
    this.bottomSpacerArea,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          customAppBar,
          if (topWidget != null) Expanded(flex: 7, child: topWidget!) else const Spacer(flex: 7),
          if (middleSpacerArea != null) Expanded(child: middleSpacerArea!) else const Spacer(),
          if (bottomWidget != null) Expanded(flex: 4, child: bottomWidget!) else const Spacer(flex: 4),
          if (bottomSpacerArea != null) Expanded(child: bottomSpacerArea!) else const Spacer(),
        ],
      ),
    );
  }
}
