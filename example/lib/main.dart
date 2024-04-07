import 'package:audio_plot/audio_plot.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

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
    return AudioPlot();
  }
}
