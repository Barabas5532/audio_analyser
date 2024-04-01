library audio_plot;

import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

class AudioPlot extends StatelessWidget {
  const AudioPlot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 700,
      child: CustomPaint(
        painter: _AudioPlotPainter(
          xAxis: _AxisParameters(
            minimum: 0,
            maximum: 5,
            ticks: [0, 1, 2, 3, 4, 5],
          ),
          yAxis: _AxisParameters(
            minimum: 1,
            maximum: 6,
            ticks: [1, 2, 3, 4, 5, 6],
          ),
          xPoints: [1, 2, 3],
          yPoints: [5, 1, 3],
          tickTextStyle: Theme.of(context).textTheme.labelMedium!,
          labelTextStyle: Theme.of(context).textTheme.bodyMedium!,
        ),
      ),
    );
  }
}

class _AudioPlotPainter extends CustomPainter {
  _AudioPlotPainter({
    super.repaint,
    required this.xAxis,
    required this.yAxis,
    required this.xPoints,
    required this.yPoints,
    required this.tickTextStyle,
    required this.labelTextStyle,
  });

  final _AxisParameters xAxis;
  final _AxisParameters yAxis;

  final Iterable<double> xPoints;
  final Iterable<double> yPoints;

  final TextStyle tickTextStyle;
  final TextStyle labelTextStyle;

  static const axisArea = 30.0;

  @override
  void paint(Canvas canvas, Size size) {
    final lineArea = Rect.fromPoints(
      size.topLeft(const Offset(3 * axisArea, 0)),
      size.bottomRight(const Offset(0, -2 * axisArea)),
    );

    final framePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final framePath = Path()
      ..addRect(lineArea)
      ..close();
    canvas.drawPath(framePath, framePaint);

    final yLabel = "Y Axis";
    final xLabel = "X Axis";

    final ySpan = TextSpan(text: yLabel, style: labelTextStyle);
    final xSpan = TextSpan(text: xLabel, style: labelTextStyle);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = xSpan;
    textPainter.layout();
    final xLabelOffset = Offset(size.width / 2, size.height - axisArea);
    final textCentreOffset = textPainter.size.center(Offset.zero);
    textPainter.paint(canvas, xLabelOffset - textCentreOffset);

    canvas.save();
    textPainter.text = ySpan;
    final yLabelOffset = Offset(axisArea, size.height / 2);
    canvas.translate(yLabelOffset.dx, yLabelOffset.dy);
    canvas.rotate(-m.pi / 2);
    textPainter.layout();
    textPainter.paint(canvas, -textPainter.size.center(Offset.zero));
    canvas.restore();

    // TODO remove off screen points and do not draw them
    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final linePath = Path()..moveTo(xPoints.first, yPoints.first);

    final xMinOffset = lineArea.left;
    final xMaxOffset = lineArea.right;
    final yMinOffset = lineArea.bottom;
    final yMaxOffset = lineArea.top;
    bool first = true;
    for(final point in IterableZip([xPoints, yPoints])) {
      final x = (point[0] - xAxis.minimum) / xAxis.range;
      final y = (point[1] - yAxis.minimum) / yAxis.range;

      final xOffset = lerpDouble(xMinOffset, xMaxOffset, x)!;
      final yOffset = lerpDouble(yMinOffset, yMaxOffset, y)!;

      if(first) {
        linePath.moveTo(xOffset, yOffset);
        first = false;
      } else {
        linePath.lineTo(xOffset, yOffset);
      }
    }
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _AxisParameters {
  final double minimum;
  final double maximum;
  final Iterable<double> ticks;

  _AxisParameters(
      {required this.minimum, required this.maximum, required this.ticks});

  get range => maximum - minimum;
}
