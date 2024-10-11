import 'package:audio_analyser/audio/audio_engine.dart';
import 'package:audio_analyser/audio/meters_state.dart';
import 'package:flutter/material.dart';

class Meters extends StatefulWidget {
  const Meters({
    super.key,
    required this.engine,
  });

  final AudioEngine engine;

  @override
  State<Meters> createState() => _MetersState();
}

class _MetersState extends State<Meters> {
  MetersState? state;

  @override
  void initState() {
    super.initState();

    widget.engine.meters.listen((event) => setState(() => state = event));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Meters(state: state);
  }
}

class _Meters extends StatelessWidget {
  const _Meters({
    required this.state,
  });

  final MetersState? state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Meter'),
              onPressed: null,
            ),
          ],
        ),
        Container(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Column(
            children: [
              Wrap(
                children: [
                  _Meter(
                    label: const Text('RMS Level'),
                    value: state?.rms,
                    unit: const Text('V'),
                  ),
                  const _Meter(
                    label: Text('Meter 2'),
                    value: 2,
                    unit: Text('dB'),
                  ),
                  const _Meter(
                    label: Text('Meter 3'),
                    value: 3,
                    unit: Text('Vrms'),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Meter extends StatelessWidget {
  const _Meter({
    required this.label,
    required this.value,
    required this.unit,
  });

  final Widget label;
  final double? value;
  final Widget unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: 200,
        height: 100,
        child: Column(
          children: [
            const SizedBox(height: 4),
            DefaultTextStyle(
                style: Theme.of(context).textTheme.headlineSmall!,
                child: label),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  const Spacer(),
                  if (value != null)
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyLarge!,
                      child: Text(
                        value!.toString(),
                      ),
                    ),
                  const SizedBox(width: 8),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyLarge!,
                    child: unit,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
