import 'package:audio_plot/audio_plot.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:math' as m;

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
  const AudioPlotExample({super.key});

  @override
  State<AudioPlotExample> createState() => _AudioPlotExampleState();
}

extension DoubleMagnitudeEx on double {
  NumberMagnitude get magnitude => switch (this) {
        final _ when this >= 1e9 => NumberMagnitude.larger,
        final _ when this >= 1e6 => NumberMagnitude.mega,
        final _ when this >= 1e3 => NumberMagnitude.kilo,
        final _ when this >= 1e0 => NumberMagnitude.base,
        final _ when this >= 1e-3 => NumberMagnitude.milli,
        final _ when this >= 1e-6 => NumberMagnitude.micro,
        final _ when this >= 1e-9 => NumberMagnitude.nano,
        final _ when this >= 1e-12 => NumberMagnitude.pico,
        _ => NumberMagnitude.larger,
      };
}

extension DoubleLabelFormatEx on double {
  String toLabelFormat() {
    if (abs() < 1) {
      return toStringAsFixed(2);
    }

    return toStringAsPrecision(3);
  }
}

extension on Iterable<double> {
  NumberMagnitude maxMagnitude() {
    final sorted = toList()..sort();
    return sorted.last.magnitude;
  }
}

class _AudioPlotExampleState extends State<AudioPlotExample> {
  final xPoints = <double>[1, 2, 3];
  final yPoints = <double>[5, 1, 3];

  AxisParameters _xAxis = AxisParameters(
    label: "X Axis",
    minimum: 0,
    maximum: 5,
    ticks: () {
      final ticks = makeTicks(0, 5, 6);
      return ticks.map((e) => TickLabel(
          value: e.toDouble(), label: formatTick(e, ticks.maxMagnitude())));
    }(),
  );

  AxisParameters _yAxis = AxisParameters(
    label: "Y Axis",
    minimum: 1,
    maximum: 6,
    ticks: () {
      final ticks = makeTicks(1, 6, 6);
      return ticks.map((e) => TickLabel(
          value: e.toDouble(), label: formatTick(e, ticks.maxMagnitude())));
    }(),
  );

  set xAxis(AxisParameters value) {
    final ticks = makeTicks(value.minimum, value.maximum, 6);
    _xAxis = value.copyWith(
        ticks: ticks.map((e) => TickLabel(
            value: e.toDouble(), label: formatTick(e, ticks.maxMagnitude()))));
  }

  AxisParameters get xAxis => _xAxis;

  set yAxis(AxisParameters value) {
    final ticks = makeTicks(value.minimum, value.maximum, 6);
    _yAxis = value.copyWith(
        ticks: ticks.map((e) => TickLabel(
            value: e.toDouble(), label: formatTick(e, ticks.maxMagnitude()))));
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
  var interval = (max - min) / (maxTickCount - 1);

  var (sig, exp) = getExponentAndSignificant(interval);

  if (sig < 2) {
    sig = 2;
  } else if (sig < 5) {
    sig = 5;
  } else {
    sig = 10;
  }

  interval = sig * exp;

  for (var i = 0; i < maxTickCount; i++) {
    yield min + i * interval;
  }
}

(double, double) getExponentAndSignificant(double number) {
  final str = number.toStringAsExponential();
  int exponent = str.contains('e')
      ? int.parse(str.split('e')[1])
      : (number.floor() > 0 ? number.floor().toString().length - 1 : 0);

  double significant = number / m.pow(10, exponent);

  return (significant, m.pow(10, exponent).toDouble());
}

enum NumberMagnitude {
  larger,
  mega,
  kilo,
  base,
  milli,
  micro,
  nano,
  pico,
  smaller,
}

String formatTick(double value, NumberMagnitude magnitude) {
  String fallback(double value) {
    return value.toStringAsPrecision(3);
  }

  final sign = value.sign;
  value = value.abs();

  final number = switch (magnitude) {
    NumberMagnitude.mega => '${(value / 1e6).toLabelFormat()}M',
    NumberMagnitude.kilo => '${(value / 1e3).toLabelFormat()}k',
    NumberMagnitude.base => value.toLabelFormat(),
    NumberMagnitude.milli => '${(value * 1e3).toLabelFormat()}m',
    NumberMagnitude.micro => '${(value * 1e6).toLabelFormat()}u',
    NumberMagnitude.nano => '${(value * 1e9).toLabelFormat()}n',
    NumberMagnitude.pico => '${(value * 1e12).toLabelFormat()}p',
    _ => fallback(value),
  };

  return switch (sign) {
    -1.0 => '-$number',
    _ => number,
  };
}
