import 'package:flutter/material.dart';

class GeneratorPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Generator'),
        SwitchListTile(title: Text('Enable'), value: false, onChanged: (v) {},),
        TextField(decoration: InputDecoration(label: Text('Level'), suffix: Text('V'))),
        TextField(decoration: InputDecoration(label: Text('Frequency'), suffix: Text('Hz'))),
      ],
    );
  }
}
