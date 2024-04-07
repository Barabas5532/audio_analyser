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
  const AudioPlot({
    super.key,
    required this.width,
    required this.height,
    required this.xAxisSize,
    required this.yAxisSize,
  });

  final double width;
  final double height;
  final double xAxisSize;
  final double yAxisSize;

  @override
  State<AudioPlot> createState() => _AudioPlotState();
}

class _AudioPlotState extends State<AudioPlot> {
  final xPoints = <double>[1, 2, 3];
  final yPoints = <double>[5, 1, 3];

  AxisParameters xAxis = AxisParameters(
    label: "X Axis",
    minimum: 0,
    maximum: 5,
    ticks: [0, 1, 2, 3, 4, 5]
        .map((e) => TickLabel(value: e.toDouble(), label: e.toString())),
  );

  AxisParameters yAxis = AxisParameters(
    label: "Y Axis",
    minimum: 1,
    maximum: 6,
    ticks: [1, 2, 3, 4, 5, 6]
        .map((e) => TickLabel(value: e.toDouble(), label: e.toString())),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Row(
            children: [
              _YAxis(
                width: widget.yAxisSize,
                height: widget.height - widget.xAxisSize,
                axis: yAxis,
                translateAxis: translateYAxis,
                zoomAxis: zoomYAxis,
              ),
              _AudioPlotLineArea(
                width: widget.width - widget.yAxisSize,
                height: widget.height - widget.xAxisSize,
                xAxis: xAxis,
                yAxis: yAxis,
                translateAxes: (delta) {
                  translateXAxis(delta.dx);
                  translateYAxis(delta.dy);
                },
                zoomXAxis: zoomXAxis,
                zoomYAxis: zoomYAxis,
                xPoints: xPoints,
                yPoints: yPoints,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _XAxis(
                width: widget.width - widget.yAxisSize,
                height: widget.xAxisSize,
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
    required this.width,
    required this.height,
    required this.xAxis,
    required this.yAxis,
    required this.translateAxes,
    required this.zoomXAxis,
    required this.zoomYAxis,
    required this.xPoints,
    required this.yPoints,
  });

  final double width;
  final double height;

  final AxisParameters xAxis;
  final AxisParameters yAxis;

  final Iterable<double> xPoints;
  final Iterable<double> yPoints;

  final void Function(Offset offset) translateAxes;
  final void Function(double scale, double about) zoomXAxis;
  final void Function(double scale, double about) zoomYAxis;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (data) {
        final delta = Offset(data.delta.dx / width * xAxis.range,
            data.delta.dy / height * yAxis.range);

        translateAxes(delta);
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Listener(
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
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
                xPoints: xPoints,
                yPoints: yPoints,
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
    paintGrid(canvas, size);
    paintLine(canvas, size);
    paintFrame(canvas, size);
  }

  void paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0
      ..style = PaintingStyle.stroke;

    final xRange = xAxis.range;
    for (final tick in xAxis.ticks) {
      final x = (tick.value - xAxis.minimum) / xRange * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final yRange = yAxis.range;
    for (final tick in yAxis.ticks) {
      final y = (yAxis.maximum - tick.value) / yRange * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void paintLine(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final linePath = Path();

    bool first = true;
    final xRange = xAxis.range;
    final yRange = yAxis.range;

    for (final point in IterableZip([xPoints, yPoints])) {
      final x = (point[0] - xAxis.minimum) / xRange;
      final y = (yAxis.maximum - point[1]) / yRange;

      final xOffset = size.width * x;
      final yOffset = size.height * y;

      if (first) {
        linePath.moveTo(xOffset, yOffset);
        first = false;
      } else {
        linePath.lineTo(xOffset, yOffset);
      }
    }
    canvas.drawPath(linePath, linePaint);
  }

  void paintFrame(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height + 1).deflate(1),
        framePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _YAxis extends StatelessWidget {
  const _YAxis(
      {required this.height,
      required this.width,
      required this.axis,
      required this.translateAxis,
      required this.zoomAxis});

  final double width;
  final double height;

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
          final delta = data.delta.dy / height * axis.range;
          translateAxis(delta);
        },
        behavior: HitTestBehavior.translucent,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (pointerSignal) {
            switch (pointerSignal) {
              case PointerScrollEvent scrollEvent:
                final r = (scrollEvent.localPosition.dy / height);

                final delta = scrollEvent.scrollDelta.dy;
                zoomAxis(delta, r);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final tick in axis.ticks)
                Positioned(
                  right: 7,
                  top: _getPosition(tick.value),
                  child: FractionalTranslation(
                    translation: const Offset(0, -0.5),
                    child: Text(tick.label),
                  ),
                ),
              Positioned(
                left: 0,
                bottom: height / 2,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, 0),
                    child: Text(axis.label),
                  ),
                ),
              ),
              SizedBox(width: width, height: height),
            ],
          ),
        ),
      ),
    );
  }

  double _getPosition(double tick) {
    final r = (axis.maximum - tick) / axis.range;
    return r * height;
  }
}

class _XAxis extends StatelessWidget {
  const _XAxis(
      {
        required this.width,
        required this.height,
        required this.axis,
      required this.translateAxis,
      required this.zoomAxis});

  final double width;
  final double height;

  final AxisParameters axis;
  final void Function(double offset) translateAxis;
  final void Function(double delta, double r) zoomAxis;

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
          child: Stack(clipBehavior: Clip.none, children: [
            for (final tick in axis.ticks)
              Positioned(
                top: 5,
                left: _getPosition(tick.value),
                child: FractionalTranslation(
                  translation: const Offset(-0.5, 0),
                  child: Text(tick.label),
                ),
              ),
            Positioned(
              bottom: 0,
              left: width / 2,
              child: FractionalTranslation(
                translation: const Offset(-0.5, 0),
                child: Text(axis.label),
              ),
            ),
            SizedBox(width: width, height: height),
          ]),
        ),
      ),
    );
  }

  double _getPosition(double tick) {
    final r = (tick - axis.minimum) / axis.range;
    return r * width;
  }
}

@freezed
class AxisParameters with _$AxisParameters {
  factory AxisParameters({
    required double minimum,
    required double maximum,
    required Iterable<TickLabel> ticks,
    required String label,
  }) = _AxisParameters;

  AxisParameters._();

  double get range => maximum - minimum;
}

@freezed
class TickLabel with _$TickLabel {
  factory TickLabel({
    required double value,
    required String label,
  }) = _TickLabel;
}
