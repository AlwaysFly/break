import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color? color;
  final double opacity;

  BackgroundOverlay({
    Key? key,
    required Animation<double> animation,
    this.color = Colors.white,
    this.opacity = 0.8,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    // final Animation<double> animation = listenable as Animation<double>;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 5.0),
        child: Container(
          color: Colors.transparent,
          // color: color?.withOpacity(animation.value * opacity),
        ),
      ),
    );
  }
}
