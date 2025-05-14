import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';

class DecodedMsgBackground extends StatefulWidget {
  final AnimationController fadeInAnimationController;
  final ThemeAssets themeAssets;

  const DecodedMsgBackground({
    required this.fadeInAnimationController,
    required this.themeAssets,
    super.key,
  });

  @override
  State<DecodedMsgBackground> createState() => _DecodedMsgBackgroundState();
}

class _DecodedMsgBackgroundState extends State<DecodedMsgBackground> {
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(widget.fadeInAnimationController)..addListener(_rebuild);
  }

  @override
  void dispose() {
    _fadeInAnimation.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _fadeInAnimation.value,
      child: Container(
        color: widget.themeAssets.primaryColor,
        child: Particles(
          awayRadius: 150,
          particles: _createParticles(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          onTapAnimation: true,
          awayAnimationDuration: const Duration(milliseconds: 100),
          awayAnimationCurve: Curves.linear,
          enableHover: true,
          hoverRadius: 90,
          connectDots: false,
        ),
      ),
    );
  }

  List<Particle> _createParticles() {
    Random rng = Random();
    List<Particle> particles = <Particle>[];
    for (int i = 0; i < 70; i++) {
      particles.add(
        Particle(
          color: widget.themeAssets.particlesColor,
          size: rng.nextDouble() * 10,
          velocity: Offset(rng.nextDouble() * 50 * _randomSign(), rng.nextDouble() * 50 * _randomSign()),
        ),
      );
    }
    return particles;
  }

  double _randomSign() {
    Random rng = Random();
    return rng.nextBool() ? 1 : -1;
  }

  void _rebuild() {
    setState(() {});
  }
}
