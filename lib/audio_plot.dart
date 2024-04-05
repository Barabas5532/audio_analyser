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
    return SizedBox(
      height: 500,
      width: 700,
      child: Column(
        children: [
          Row(
            children: [
              _YAxis(
                axis: yAxis,
                updateAxis: (min, max) => setState(
                    () => yAxis = yAxis.copyWith(minimum: min, maximum: max)),
              ),
              _AudioPlotLineArea(
                xAxis: xAxis,
                yAxis: yAxis,
                translateAxes: (delta) {
                  setState(() {
                    xAxis = xAxis.copyWith(
                        minimum: xAxis.minimum - delta.dx,
                        maximum: xAxis.maximum - delta.dx);
                    yAxis = yAxis.copyWith(
                        minimum: yAxis.minimum + delta.dy,
                        maximum: yAxis.maximum + delta.dy);
                  });
                },
                zoomXAxis: (double delta, double r) {
                  final factor = m.log(delta.abs()) / 3;
                  final ratio = delta < 0 ? factor : 1 / factor;

                  var a = xAxis.minimum;
                  var b = xAxis.maximum;
                  {
                    final f = a + (b - a) * r;
                    final aPrime = f - r * (b - a) / ratio;
                    final bPrime = aPrime + (b - a) / ratio;
                    setState(() {
                      xAxis = xAxis.copyWith(minimum: aPrime, maximum: bPrime);
                    });
                  }
                },
                zoomYAxis: (delta, r) {
                  final factor = m.log(delta.abs()) / 3;
                  final ratio = delta < 0 ? factor : 1 / factor;

                  final a = yAxis.maximum;
                  final b = yAxis.minimum;

                  {
                    final f = a + (b - a) * r;
                    final aPrime = f - r * (b - a) / ratio;
                    final bPrime = aPrime + (b - a) / ratio;
                    setState(() {
                      yAxis = yAxis.copyWith(minimum: bPrime, maximum: aPrime);
                    });
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _XAxis(
                axis: xAxis,
                updateAxis: (min, max) => setState(
                    () => xAxis = xAxis.copyWith(minimum: min, maximum: max)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AudioPlotLineArea extends StatelessWidget {
  const _AudioPlotLineArea({
    required this.xAxis,
    required this.yAxis,
    required this.translateAxes,
    required this.zoomXAxis,
    required this.zoomYAxis,
  });

  final AxisParameters xAxis;
  final AxisParameters yAxis;

  final void Function(Offset offset) translateAxes;
  final void Function(double scale, double about) zoomXAxis;
  final void Function(double scale, double about) zoomYAxis;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (data) {
        const width = 680;
        const height = 480;

        final delta = Offset(data.delta.dx / width * xAxis.range,
            data.delta.dy / height * yAxis.range);

        translateAxes(delta);
      },
      child: SizedBox(
        width: 680,
        height: 480,
        child: Listener(
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
                const width = 680;
                const height = 480;

                final delta = scrollEvent.scrollDelta.dy;
                {
                  final r = (scrollEvent.localPosition.dx / width);
                  zoomXAxis(delta, r);
                }

                {
                  final r = (scrollEvent.localPosition.dy / height);
                  zoomYAxis(delta, r);
                }
            }
          },
          child: ClipRect(
            child: CustomPaint(
              painter: _AudioPlotPainter(
                xAxis: xAxis,
                yAxis: yAxis,
                xPoints: [1, 2, 3],
                yPoints: [5, 1, 3],
                tickTextStyle: Theme.of(context).textTheme.labelMedium!,
                labelTextStyle: Theme.of(context).textTheme.bodyMedium!,
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

  @override
  void paint(Canvas canvas, Size size) {
    final lineArea = Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width,
        height: size.height);
    final framePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final framePath = Path()
      ..addRect(lineArea.deflate(1))
      ..close();
    canvas.drawPath(framePath, framePaint);

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

class _YAxis extends StatelessWidget {
  const _YAxis({required this.axis, required this.updateAxis});

  final AxisParameters axis;
  final void Function(double min, double max) updateAxis;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // TODO swap to grabbing when mouse down
      cursor: SystemMouseCursors.grab,
      child: GestureDetector(
        onVerticalDragUpdate: (data) {
          const width = 680;
          final delta = data.delta.dy / width * axis.range;
          updateAxis(axis.minimum + delta, axis.maximum + delta);
        },
        behavior: HitTestBehavior.translucent,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
                const height = 480;
                final a = axis.maximum;
                final b = axis.minimum;
                final r = (scrollEvent.localPosition.dy / height);

                final delta = scrollEvent.scrollDelta.dy;
                final factor = m.log(delta.abs()) / 3;
                final ratio = delta < 0 ? factor : 1 / factor;

                final f = a + (b - a) * r;
                final aPrime = f - r * (b - a) / ratio;
                final bPrime = aPrime + (b - a) / ratio;
                updateAxis(bPrime, aPrime);
            }
          },
          child: const SizedBox(width: 20, height: 480),
        ),
      ),
    );
  }
}

class _XAxis extends StatelessWidget {
  const _XAxis({required this.axis, required this.updateAxis});

  final AxisParameters axis;
  final void Function(double min, double max) updateAxis;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // TODO swap to grabbing when mouse down
      cursor: SystemMouseCursors.grab,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (data) {
          const width = 680;
          final delta = data.delta.dx / width * axis.range;
          updateAxis(axis.minimum - delta, axis.maximum - delta);
        },
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
                const width = 680;
                final a = axis.minimum;
                final b = axis.maximum;
                final r = (scrollEvent.localPosition.dx / width);

                final delta = scrollEvent.scrollDelta.dy;
                final factor = m.log(delta.abs()) / 3;
                final ratio = delta < 0 ? factor : 1 / factor;

                final f = a + (b - a) * r;
                final aPrime = f - r * (b - a) / ratio;
                final bPrime = aPrime + (b - a) / ratio;
                updateAxis(aPrime, bPrime);
            }
          },
          child: const SizedBox(width: 680, height: 20),
        ),
      ),
    );
  }
}

@freezed
class AxisParameters with _$AxisParameters {
  factory AxisParameters({
    required double minimum,
    required double maximum,
    required Iterable<double> ticks,
    required String label,
  }) = _AxisParameters;

  AxisParameters._();

  get range => maximum - minimum;
}
