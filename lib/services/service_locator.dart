import 'package:matrixdisplaypainter/services/ble_bluetooth_service.dart';
import 'package:matrixdisplaypainter/services/esp_service.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<BleBluetoothService>(BleBluetoothService());
//  locator.registerSingleton<SerialBlueToothService>(SerialBlueToothService());

  locator.registerSingleton<EspService>(EspService());
}
