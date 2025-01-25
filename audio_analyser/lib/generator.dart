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
  const _GeneratorPanel();

  @override
  State<_GeneratorPanel> createState() => __GeneratorPanelState();
}

class __GeneratorPanelState extends State<_GeneratorPanel> {
  final levelController = TextEditingController();
  final frequencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final s = context.read<GeneratorService>();
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
        ParameterTextField(
          controller: levelController,
          decoration:
              const InputDecoration(label: Text('Level'), suffix: Text('V')),
          onSaved: settings == null
              ? null
              : (v) => context
                  .read<GeneratorService>()
                  .setGeneratorSettings(settings.copyWith(level: v)),
        ),
        ParameterTextField(
          controller: frequencyController,
          decoration: const InputDecoration(
              label: Text('Frequency'), suffix: Text('Hz')),
          onSaved: settings == null
              ? null
              : (v) => context
                  .read<GeneratorService>()
                  .setGeneratorSettings(settings.copyWith(frequency: v)),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    levelController.dispose();
    frequencyController.dispose();
  }
}

class ParameterTextField extends StatefulWidget {
  const ParameterTextField({
    super.key,
    required this.controller,
    required this.onSaved,
    this.decoration,
  });

  final TextEditingController controller;
  final void Function(double)? onSaved;
  final InputDecoration? decoration;

  @override
  State<ParameterTextField> createState() => _ParameterTextFieldState();
}

class _ParameterTextFieldState extends State<ParameterTextField> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: widget.controller,
        decoration: widget.decoration,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (v) {
          if (v == null || v.isEmpty) return "Must not be empty";

          if (double.tryParse(v) case final _?) return null;

          return "Must be a number";
        },
        onFieldSubmitted: (_) => _formKey.currentState!.save(),
        onSaved: (v) => widget.onSaved?.call(double.parse(v!)),
        enabled: widget.onSaved != null,
      ),
    );
  }
}
