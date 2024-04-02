library audio_plot;

import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:math' as m;

import 'package:logging/logging.dart';

part 'audio_plot.freezed.dart';

final _log = Logger('audio_plot');

class AudioPlot extends StatefulWidget {
  const AudioPlot({super.key});

  @override
  State<AudioPlot> createState() => _AudioPlotState();
}

class _AudioPlotState extends State<AudioPlot> {
  AxisParameters xAxis = AxisParameters(
    label: "X Axis",
    minimum: 0,
    maximum: 5,
    ticks: [0, 1, 2, 3, 4, 5],
  );

  AxisParameters yAxis = AxisParameters(
    label: "Y Axis",
    minimum: 1,
    maximum: 6,
    ticks: [1, 2, 3, 4, 5, 6],
  );

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // TODO swap to grabbing when mouse down
      cursor: SystemMouseCursors.grab,
      child: GestureDetector(
        onPanUpdate: (data) {
          const width = 700;
          const height = 500;

          final delta = Offset(data.delta.dx / width * xAxis.range, data.delta.dy / height * yAxis.range);

          setState(() {
            xAxis = xAxis.copyWith(minimum: xAxis.minimum - delta.dx, maximum: xAxis.maximum - delta.dx);
            yAxis = yAxis.copyWith(minimum: yAxis.minimum + delta.dy, maximum: yAxis.maximum + delta.dy);
          });
        },
        child: SizedBox(
          height: 500,
          width: 700,
          child: Listener(
            onPointerSignal: (pointerSignal) {
              switch(pointerSignal) {
                case PointerScrollEvent scrollEvent:
                  _log.info('scroll: ${scrollEvent.localPosition}');
                  const width = 700;
                  final a = xAxis.minimum;
                  final b = xAxis.maximum;
                  final r = (scrollEvent.localPosition.dx / width);
                  final f = a + (b - a) * r;

                  final delta = scrollEvent.scrollDelta.dy.abs();
                  final factor = m.log(delta) / 3.5;
                  final ratio = scrollEvent.scrollDelta.dy > 0 ? factor : 1 / factor;

                  final a_prime = f - r * (b - a) / ratio;
                  final b_prime = a_prime + (b - a) / ratio;
                  setState(() {
                    xAxis = xAxis.copyWith(minimum: a_prime, maximum: b_prime);
                  });
              }
            },
            child: ClipRect(
              child: CustomPaint(
                painter: _AudioPlotPainter(
                  xAxis: xAxis,
                  yAxis: yAxis,
                  xPoints: [1, 2, 3],
                  yPoints: [5, 1, 3],
                  tickTextStyle: Theme
                      .of(context)
                      .textTheme
                      .labelMedium!,
                  labelTextStyle: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AudioPlotPainter extends CustomPainter {
  _AudioPlotPainter({
    required this.xAxis,
    required this.yAxis,
    required this.xPoints,
    required this.yPoints,
    required this.tickTextStyle,
    required this.labelTextStyle,
  });

  final AxisParameters xAxis;
  final AxisParameters yAxis;

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

    final xLabel = xAxis.label;
    final yLabel = yAxis.label;

    final xSpan = TextSpan(text: xLabel, style: labelTextStyle);
    final ySpan = TextSpan(text: yLabel, style: labelTextStyle);

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
    final linePath = Path();

    final xMinOffset = lineArea.left;
    final xMaxOffset = lineArea.right;
    final yMinOffset = lineArea.bottom;
    final yMaxOffset = lineArea.top;
    bool first = true;
    for (final point in IterableZip([xPoints, yPoints])) {
      final x = (point[0] - xAxis.minimum) / xAxis.range;
      final y = (point[1] - yAxis.minimum) / yAxis.range;

      final xOffset = lerpDouble(xMinOffset, xMaxOffset, x)!;
      final yOffset = lerpDouble(yMinOffset, yMaxOffset, y)!;

      if (first) {
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

@freezed
class AxisParameters with _$AxisParameters{
  factory AxisParameters({
    required double minimum,
    required double maximum,
    required Iterable<double> ticks,
    required String label,
  }) = _AxisParameters;

  AxisParameters._();

  get range => maximum - minimum;
}
