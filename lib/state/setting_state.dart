import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SettingState extends ChangeNotifier {
  List<BluetoothDevice> _devices = List();

  connectToDevice(BluetoothDevice device) {
//     bluetoothSerial.connectToDevice(device);
  }

  List<BluetoothDevice> get devices => _devices;
}
