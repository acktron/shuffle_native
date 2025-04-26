import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PacmanLoadingIndicator extends StatelessWidget {
  final List<Color> colors;
  final double size;
  final Color backgroundColor;

  const PacmanLoadingIndicator({
    super.key,
    this.colors = const [Colors.greenAccent, Colors.lightGreenAccent, Colors.green],
    this.size = 75.0,
    this.backgroundColor = const Color.fromRGBO(0, 0, 0, 0.5), // Semi-transparent black
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: LoadingIndicator(
            indicatorType: Indicator.pacman,
            colors: colors,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
