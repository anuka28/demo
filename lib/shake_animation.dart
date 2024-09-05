// import 'package:flutter/material.dart';

// class Shake extends TweenAnimation<double> {
//   Shake({
//     required double begin,
//     required double end,
//     required TickerProvider vsync,
//   }) : super(begin: begin, end: end, vsync: vsync);

//   @override
//   double lerp(double t) {
//     final cycles = (t * 10).toInt(); // Adjust for number of shakes
//     final tOffset = t - ((cycles / 10).floor());
//     return begin + ((end - begin) * 0.5 * (1.0 + (tOffset - 0.5).abs()));
//   }
// }
