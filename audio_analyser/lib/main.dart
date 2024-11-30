import 'dart:developer';
import 'dart:io';

import 'package:audio_analyser/generator.dart';

import 'audio/fake_audio_engine.dart';
import 'meters.dart';
import 'rate_counter.dart';
import 'audio_plot.dart';
import 'backend/proto/generated/audio_analyser.pbgrpc.dart' as grpc;
import 'trigger.dart';
import 'audio/audio_engine.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'dart:math' as m;

const _kXAxisSize = 39.0;
const _kYAxisSize = 67.0;

final _log = Logger('main');

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final logSink = File("/tmp/xembed-logs").openWrite();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final message = '${record.level.name}: ${record.time}: ${record.message}';

    debugPrint(message);
    logSink.write(message);
    logSink.write('\n');
  });

  _log.info((await Service.getInfo()).serverUri);

  _log.info(args);

  final port = int.tryParse(const String.fromEnvironment("BACKEND_PORT")) ??
      ((1 == args.length) ? int.tryParse(args.single) : null);

  late AudioEngine audioEngine;

  // TODO get rate from backend
  const rate = 48000.0;

  if (port != null) {
    /*
    final native = NativePlatformMethodChannel();
    final wId = await native.getWindowId();

    _log.info("wId = $wId");
     */

    final channel = grpc.ClientChannel(
      'localhost',
      port: port,
      options: grpc.ChannelOptions(
        credentials: const grpc.ChannelCredentials.insecure(),
        codecRegistry: grpc.CodecRegistry(
            codecs: [const grpc.GzipCodec(), const grpc.IdentityCodec()]),
      ),
    );

    /*
    final client = grpc.AudioAnalyserClient(channel);
    AudioBackend(client: client).sendWindowId(wId);
     */

    final streamingClient = grpc.AudioStreamingClient(channel);
    audioEngine = GrpcAudioEngine(streamingClient: streamingClient, generatorClient: grpc.AudioGeneratorClient(channel));
  } else {
    const bufferSize = 512;
    audioEngine = FakeAudioEngine(rate, bufferSize);
  }

  _log.info("app starting");

  runApp(MyApp(
    engine: audioEngine,
    rate: rate,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.engine, required this.rate});

  final AudioEngine engine;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Analyser'),
        ),
        body: Row(
          children: [
            SizedBox(width: 300, child: GeneratorPanel(service: engine.generator,)),
            Flexible(
              child: Column(
                children: [
                  Flexible(child: Oscilloscope(rate: rate, engine: engine)),
                  const Divider(),
                  Flexible(child: Meters(engine: engine)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Oscilloscope extends StatefulWidget {
  const Oscilloscope({super.key, required this.engine, required this.rate});

  final AudioEngine engine;
  final double rate;

  @override
  State<Oscilloscope> createState() => _OscilloscopeState();
}

class _OscilloscopeState extends State<Oscilloscope> {
  final trigger = Trigger();

  int lastScreenBufferSize = 0;
  int lastPostTriggerBufferSize = 0;

  List<double>? waveform;

  final rateCounter = RateCounter();

  @override
  void initState() {
    super.initState();

    widget.engine.audio.listen(_process);

    trigger.triggered.listen((event) {
      setState(() {
        waveform = event;
      });
    });

    rateCounter.rateStream.listen(
      (rate) => _log.info('Audio block rate: $rate Hz'),
    );
  }

  @override
  void dispose() {
    super.dispose();

    widget.engine.dispose();
    trigger.dispose();
  }

  AxisParameters _xAxis = AxisParameters(
    label: "X Axis",
    minimum: -10e-3,
    maximum: 10e-3,
    ticks: () {
      final ticks = makeTicks(-10e-3, 10e-3, 6);
      return ticks.map((e) => TickLabel(
          value: e.toDouble(), label: formatTick(e, ticks.maxMagnitude())));
    }(),
  );

  AxisParameters _yAxis = AxisParameters(
    label: "Y Axis",
    minimum: -1.2,
    maximum: 1.2,
    ticks: () {
      final ticks = makeTicks(-1.2, 1.2, 6);
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
    final xPoints =
        waveform?.indexed.map((e) => xAxis.minimum + e.$1 / widget.rate) ?? [];
    final yPoints = waveform ?? [];

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
    // do not allow moving the trigger point out of the screen
    if (xAxis.minimum - dx > 0) {
      dx = xAxis.minimum;
    }

    if (xAxis.maximum - dx < 0) {
      dx = xAxis.maximum;
    }

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

  void _process(AudioBuffer buffer) {
    rateCounter.tick();

    final screenBufferSize = (xAxis.range * widget.rate).toInt();
    if (lastScreenBufferSize != screenBufferSize) {
      _log.info('update screen $screenBufferSize');

      lastScreenBufferSize = screenBufferSize;
      trigger.setScreenBufferSize(screenBufferSize);
    }

    final postTriggerBufferSize =
        (screenBufferSize * (1 - triggerRatio)).toInt();
    if (lastPostTriggerBufferSize != postTriggerBufferSize) {
      _log.info('update post trigger $postTriggerBufferSize');

      lastPostTriggerBufferSize = postTriggerBufferSize;
      trigger.setPostTriggerBufferSize(postTriggerBufferSize);
    }

    if (iter > 100) {
      iter = 0;
      _log.info('screen $screenBufferSize post trigger $postTriggerBufferSize');
    } else {
      iter++;
    }
    trigger.process(buffer);
  }

  int iter = 0;

  double get triggerRatio => xAxis.minimum.abs() / xAxis.range;
}

extension DoubleMagnitudeEx on double {
  NumberMagnitude get magnitude => switch (abs()) {
        final a when a >= 1e9 => NumberMagnitude.larger,
        final a when a >= 1e6 => NumberMagnitude.mega,
        final a when a >= 1e3 => NumberMagnitude.kilo,
        final a when a >= 1e0 => NumberMagnitude.base,
        final a when a >= 1e-3 => NumberMagnitude.milli,
        final a when a >= 1e-6 => NumberMagnitude.micro,
        final a when a >= 1e-9 => NumberMagnitude.nano,
        final a when a >= 1e-12 => NumberMagnitude.pico,
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
