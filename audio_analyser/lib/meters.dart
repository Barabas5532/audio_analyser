import 'package:flutter/material.dart';

class Meters extends StatelessWidget {
  const Meters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Meter'),
              onPressed: null,
            ),
          ],
        ),
        Wrap(
          children: [
            _Meter(
              label: Text('Meter 1'),
              value: 1,
            ),
            _Meter(
              label: Text('Meter 2'),
              value: 2,
            ),
            _Meter(
              label: Text('Meter 3'),
              value: 3,
            )
          ],
        ),
      ],
    );
  }
}

class _Meter extends StatelessWidget {
  const _Meter({super.key, required this.label, required this.value});

  final Widget label;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pinkAccent,
      width: 500,
      height: 200,
      child: Column(
        children: [
          DefaultTextStyle(
              style: Theme.of(context).textTheme.headlineSmall!, child: label),
          if(value != null)
          DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!, child: Text(value!.toString())),
        ],
      ),
    );
  }
}
