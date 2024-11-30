import 'package:audio_analyser/backend/generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneratorPanel extends StatelessWidget {
  const GeneratorPanel({super.key, required GeneratorService service})
      : _service = service;

  final GeneratorService _service;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GeneratorService>.value(
      value: _service,
      builder: (context, _) {
        final settings = context.watch<GeneratorService>().settings;

        return Column(
          children: [
            const Text('Generator'),
            SwitchListTile(
              title: const Text('Enable'),
              value: settings?.enabled ?? false,
              onChanged: settings == null
                  ? null
                  : (v) => _service
                      .setGeneratorSettings(settings.copyWith(enabled: v)),
            ),
            const TextField(
                decoration:
                    InputDecoration(label: Text('Level'), suffix: Text('V'))),
            const TextField(
                decoration: InputDecoration(
                    label: Text('Frequency'), suffix: Text('Hz'))),
          ],
        );
      },
    );
  }
}
