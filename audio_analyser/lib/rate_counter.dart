import 'dart:async';

class RateCounter {
  RateCounter() {
    timer = Timer.periodic(const Duration(seconds: 1), _timeout);
  }

  int count = 0;
  late final Timer timer;

  void tick() {
    count++;
  }

  void _timeout(Timer _) {
    _rateController.add(count.toDouble());
    count = 0;
  }

  final _rateController = StreamController<double>();

  Stream<double> get rateStream => _rateController.stream;
}
