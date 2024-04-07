import 'package:audio_plot/audio_plot.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AudioPlot(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          xAxisSize: _kXAxisSize,
          yAxisSize: _kYAxisSize,
        ),
    );
  }
}
