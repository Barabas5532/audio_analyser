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

const _kWidth = 700.0;
const _kHeight = 500.0;

const _kAxisSize = 37.0;

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
      width: _kWidth,
      height: _kHeight,
      child: Column(
        children: [
          Row(
            children: [
              _YAxis(
                axis: yAxis,
                translateAxis: translateYAxis,
                zoomAxis: zoomYAxis,
              ),
              _AudioPlotLineArea(
                xAxis: xAxis,
                yAxis: yAxis,
                translateAxes: (delta) {
                  final dx = delta.dx;
                  final dy = delta.dy;

                  translateXAxis(dx);
                  translateYAxis(dy);
                },
                zoomXAxis: zoomXAxis,
                zoomYAxis: zoomYAxis,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _XAxis(
                axis: xAxis,
                translateAxis: translateXAxis,
                zoomAxis: zoomXAxis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void translateYAxis(double dy) {
    setState(() {
      yAxis = yAxis.copyWith(
          minimum: yAxis.minimum + dy, maximum: yAxis.maximum + dy);
    });
  }

  void translateXAxis(double dx) {
    setState(() {
      xAxis = xAxis.copyWith(
          minimum: xAxis.minimum - dx, maximum: xAxis.maximum - dx);
    });
  }

  void zoomYAxis(delta, r) {
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
  }

  void zoomXAxis(double delta, double r) {
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
        const width = _kWidth;
        const height = _kHeight;

        final delta = Offset(data.delta.dx / width * xAxis.range,
            data.delta.dy / height * yAxis.range);

        translateAxes(delta);
      },
      child: SizedBox(
        width: _kWidth - _kAxisSize,
        height: _kHeight - _kAxisSize,
        child: Listener(
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
                const width = _kWidth - _kAxisSize;
                const height = _kHeight - _kAxisSize;

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
  const _YAxis(
      {required this.axis,
      required this.translateAxis,
      required this.zoomAxis});

  final AxisParameters axis;
  final void Function(double offset) translateAxis;
  final void Function(double delta, double r) zoomAxis;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // TODO swap to grabbing when mouse down
      cursor: SystemMouseCursors.grab,
      child: GestureDetector(
        onVerticalDragUpdate: (data) {
          const width = _kWidth - _kAxisSize;
          final delta = data.delta.dy / width * axis.range;
          translateAxis(delta);
        },
        behavior: HitTestBehavior.translucent,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
                const height = _kHeight - _kAxisSize;
                final r = (scrollEvent.localPosition.dy / height);

                final delta = scrollEvent.scrollDelta.dy;
                zoomAxis(delta, r);
            }
          },
          child:
              const SizedBox(width: _kAxisSize, height: _kHeight - _kAxisSize),
        ),
      ),
    );
  }
}

class _XAxis extends StatelessWidget {
  const _XAxis(
      {required this.axis,
      required this.translateAxis,
      required this.zoomAxis});

  final AxisParameters axis;
  final void Function(double offset) translateAxis;
  final void Function(double delta, double r) zoomAxis;
  static const width = _kWidth - _kAxisSize;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // TODO swap to grabbing when mouse down
      cursor: SystemMouseCursors.grab,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (data) {
          final delta = data.delta.dx / width * axis.range;
          translateAxis(delta);
        },
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
                final r = (scrollEvent.localPosition.dx / width);
                final delta = scrollEvent.scrollDelta.dy;
                zoomAxis(delta, r);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
              children: [
            for (final tick in axis.ticks)
              Positioned(
                top: 0,
                left: _getXPosition(tick),
                child: FractionalTranslation(
                  translation: Offset(-0.5, 0),
                  child: Text('$tick'),
                ),
              ),
                Positioned(
                  bottom: 0,
                  left: width/2,
                  child: FractionalTranslation(
                    translation: Offset(-0.5, 0),
                    child: Text(axis.label),
                  ),
                ),
            const SizedBox(width: _kWidth - _kAxisSize, height: _kAxisSize),
          ]),
        ),
      ),
    );
  }

  double _getXPosition(double tick) {
    final r = (tick - axis.minimum) / axis.range;
    return r * width;
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

  double get range => maximum - minimum;
}
