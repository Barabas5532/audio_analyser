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
      child: const _GeneratorPanel(),
    );
  }
}

class _GeneratorPanel extends StatefulWidget {
  const _GeneratorPanel({super.key});

  @override
  State<_GeneratorPanel> createState() => __GeneratorPanelState();
}

class __GeneratorPanelState extends State<_GeneratorPanel> {
  final levelController = TextEditingController();
  final frequencyController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final s = context.read<GeneratorService>();
    print('dependency changed ${s.settings}');
    levelController.text = s.settings?.level.toString() ?? '';
    frequencyController.text = s.settings?.frequency.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<GeneratorService>().settings;

    return Column(
      children: [
        const Text('Generator'),
        SwitchListTile(
          title: const Text('Enable'),
          value: settings?.enabled ?? false,
          onChanged: settings == null
              ? null
              : (v) => context
                  .read<GeneratorService>()
                  .setGeneratorSettings(settings.copyWith(enabled: v)),
        ),
        TextField(
            controller: levelController,
            decoration:
                const InputDecoration(label: Text('Level'), suffix: Text('V'))),
        TextField(
            controller: frequencyController,
            decoration:
                const InputDecoration(label: Text('Frequency'), suffix: Text('Hz'))),
      ],
    );
  }
}
