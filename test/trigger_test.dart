import 'package:audio_plot/trigger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('basic trigger', () async {
    final trigger = Trigger();

    trigger.setPostTriggerBufferSize(4);
    trigger.setScreenBufferSize(8);
    // TODO threashold is always implicit 0 for now
    // trigger.setThreshold(0);

    trigger.process([-4.0, -3.0]);
    trigger.process([-2.0, -1.0]);
    trigger.process([0.0, 1.0]);
    trigger.process([2.0, 3.0]);
    trigger.process([4.0, 5.0]);

    final expectFuture = expectLater(
        trigger.triggered,
        emitsInOrder([
          [-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0],
          emitsDone,
        ]));

    trigger.dispose();

    await expectFuture;
  });

  test('trigger twice in a row', () async {
    final trigger = Trigger();

    trigger.setPostTriggerBufferSize(4);
    trigger.setScreenBufferSize(8);
    // TODO threashold is always implicit 0 for now
    // trigger.setThreshold(0);

    trigger.process([-4.0, -3.0]);
    trigger.process([-2.0, -1.0]);
    trigger.process([0.0, 1.0]);
    trigger.process([2.0, 3.0]);
    trigger.process([4.0, 5.0]);
    trigger.process([-4.0, -3.0]);
    trigger.process([-2.0, -1.0]);
    trigger.process([0.0, 1.0]);
    trigger.process([2.0, 3.0]);
    trigger.process([4.0, 5.0]);

    final expectFuture = expectLater(
        trigger.triggered,
        emitsInOrder([
          [-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0],
          [-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0],
          emitsDone,
        ]));

    trigger.dispose();

    await expectFuture;
  });
}
