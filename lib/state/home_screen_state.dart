import 'package:matrixdisplaypainter/services/ble_bluetooth_service.dart';
import 'package:matrixdisplaypainter/services/esp_service.dart';
import 'package:matrixdisplaypainter/services/service_locator.dart';
import 'package:flutter/foundation.dart';

class HomeState extends ChangeNotifier {
  var _espService = locator<EspService>();
  var _bluetoothService = locator<BleBluetoothService>();

  void sentDataToESP(bool val) {
    _espService.sendData(_bluetoothService.device, val);
  }

  void sendTextToESP(String value) {
    _espService.sendText(_bluetoothService.device, value);
  }

  getConnectedDeviceName() {
    return _bluetoothService.device == null
        ? "Connect to device "
        : _bluetoothService.device.name;
  }
}
