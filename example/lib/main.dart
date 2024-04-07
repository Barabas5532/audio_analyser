import 'package:audio_plot/audio_plot.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:math' as m;

const _kWidth = 700.0;
const _kHeight = 500.0;

const _kXAxisSize = 39.0;
const _kYAxisSize = 67.0;

void main() {
  Logger.root.onRecord.listen((record) => debugPrint(record.toString()));
  Logger.root.level = Level.ALL;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: AudioPlotExample(),
        ),
      ),
    );
  }
}

class AudioPlotExample extends StatefulWidget {
  const AudioPlotExample({
    super.key,
  });

  @override
  State<AudioPlotExample> createState() => _AudioPlotExampleState();
}

class _AudioPlotExampleState extends State<AudioPlotExample> {
  final xPoints = <double>[1, 2, 3];
  final yPoints = <double>[5, 1, 3];

  AxisParameters _xAxis = AxisParameters(
    label: "X Axis",
    minimum: 0,
    maximum: 5,
    ticks: makeTicks(0, 5, 6)
        .map((e) => TickLabel(value: e.toDouble(), label: formatTick(e))),
  );

  AxisParameters _yAxis = AxisParameters(
    label: "Y Axis",
    minimum: 1,
    maximum: 6,
    ticks: makeTicks(1, 6, 6)
        .map((e) => TickLabel(value: e.toDouble(), label: formatTick(e))),
  );

  set xAxis(AxisParameters value) {
    _xAxis = value.copyWith(
        ticks: makeTicks(value.minimum, value.maximum, 6)
            .map((e) => TickLabel(value: e.toDouble(), label: formatTick(e))));
  }

  AxisParameters get xAxis => _xAxis;

  set yAxis(AxisParameters value) {
    _yAxis = value.copyWith(
        ticks: makeTicks(value.minimum, value.maximum, 6)
            .map((e) => TickLabel(value: e.toDouble(), label: formatTick(e))));
  }

  AxisParameters get yAxis => _yAxis;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AudioPlot(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        xAxisSize: _kXAxisSize,
        yAxisSize: _kYAxisSize,
        xPoints: xPoints,
        yPoints: yPoints,
        translateXAxis: translateXAxis,
        translateYAxis: translateYAxis,
        zoomXAxis: zoomXAxis,
        zoomYAxis: zoomYAxis,
        xAxis: xAxis,
        yAxis: yAxis,
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

Iterable<double> makeTicks(double min, double max, int maxTickCount) sync* {
  for (var i = 0; i < maxTickCount; i++) {
    final r = i / (maxTickCount.toDouble() - 1);
    yield min + r * (max - min);
  }
}

String formatTick(double value) {
  String fallback(double value) {
    return value.toStringAsPrecision(3);
  }

  final sign = value.sign;

  final number = switch (value.abs()) {
    final value when value >= 1e9 => fallback(value),
    final value when value >= 1e6 => '${(value / 1e6).toStringAsPrecision(3)}M',
    final value when value >= 1e3 => '${(value / 1e3).toStringAsPrecision(3)}k',
    final value when value >= 1e0 => '${value.toStringAsPrecision(3)}',
    final value when value >= 1e-3 => '${(value * 1e3).toStringAsPrecision(3)}m',
    final value when value >= 1e-6 => '${(value * 1e6).toStringAsPrecision(3)}u',
    final value when value >= 1e-9 => '${(value * 1e9).toStringAsPrecision(3)}n',
    final value when value >= 1e-12 => '${(value * 1e12).toStringAsPrecision(3)}p',
    _ => fallback(value),
  };

  return switch(sign) {
    -1.0 => '-$number',
    _ => '$number',
  };
}
