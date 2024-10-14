import 'package:flutter/services.dart';
import 'native_platform_interface.dart';

class NativePlatformMethodChannel implements NativePlatformInterface {
  final channel = const MethodChannel("native");

  @override
  Future<int> getWindowId() async {
    final result = await channel.invokeMethod<int>("getWindowId");
    return result!;
  }
}
