import 'dart:convert';
import 'dart:async';
import 'package:matrixdisplaypainter/services/ble_bluetooth_service.dart';

import 'package:matrixdisplaypainter/services/service_locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

class EspService {
  BluetoothDevice _device;

  var _bluetoothService = locator<BleBluetoothService>();

  EspService() {
    _device = _bluetoothService.device;
  }

  void sendData(BluetoothDevice device, bool val) {
//    var value = val ? localStorage.switchOnCode : localStorage.switchOffCode;
    var value = val ? 0 : 1;
    print('Sending $value to ${device.name}');

    _bluetoothService.services.forEach((char) {
      char.characteristics.forEach((v) {
        print('V: $v');
        v.write(utf8.encode(value.toString()));
      });
    });
  }

  void sendText(BluetoothDevice device, String value) {
    _bluetoothService.services.forEach((char) {
      char.characteristics.forEach((v) async {
        print('V: $v');

        try {
          await v.write(utf8.encode(value.toString()), withoutResponse: true);
        } on PlatformException {
          await Future.delayed(Duration(milliseconds: 100));
        }
      });
    });
  }
}
