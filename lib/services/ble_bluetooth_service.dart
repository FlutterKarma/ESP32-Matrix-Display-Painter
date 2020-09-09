import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BleBluetoothService {
  FlutterBlue _bluetooth = FlutterBlue.instance;

  BluetoothDevice device;
  BluetoothState state;
  BluetoothDeviceState deviceState;

  StreamSubscription scanStream;

  List<BluetoothDevice> devices = List();
  List<BluetoothService> services = List();

  BluetoothCharacteristic targetCharacteristic;
  bool _loadingDevices = true;

  StreamController<BluetoothDevice> bleDevices = StreamController.broadcast();

  getStream() => bleDevices.stream;

  BleBluetoothService() {
    checkState();
  }

  void checkState() {
    _bluetooth.state.listen((state) {
      if (state == BluetoothState.off) {
//Alert user to turn on bluetooth.
        print('BlueTooth Off');
      } else if (state == BluetoothState.on) {
//if bluetooth is enabled then go ahead.
//Make sure user's device gps is on.
        print('Bluetooth ON');
//        getConnectedDevices();
        scanForDevices();
      }
    });
  }

  Future<String> getServices(BluetoothDevice device) async {
    device.discoverServices().whenComplete(() {
      print('Services Discoverd');
      device.services.listen((data) {}).onData((data) {
        services = data;
      });
      return "services discovered";
    }).catchError((e) {
      print('error $e');
      return "error";
    });
  }

  void getConnectedDevices() {
    _bluetooth.connectedDevices.then((device) {
      print('Device: $device');
    }).whenComplete(() {
      print('Complete');
    }).catchError((e) {
      print('error $e');
    }).timeout(Duration(minutes: 1));
  }

  void scanForDevices() {
    print('Scanning for devices');

    scanStream = _bluetooth
        .scan(scanMode: ScanMode.balanced, timeout: Duration(minutes: 1))
        .listen((data) {
      print('Data ${data.device.name}');
    });

    scanStream.onDone(() {
      print('Done');
      scanStream.cancel();
    });

    scanStream.onError((error) {
      print('Error $error');
    });
    scanStream.onData((data) {
      print('onData ${data.device.name}');

      if (data.device.name == 'ESP32') {
        devices.add(data.device);

        if (!bleDevices.isClosed) bleDevices.add(data.device);
        _bluetooth.stopScan();
        bleDevices.close();
        _loadingDevices = false;
        print('ESP Device Fonund Stopping Scan');
        return;
      }
      if (data.device.name.length > 0 && !devices.contains(data.device)) {
        devices.add(data.device);
        if (!bleDevices.isClosed) bleDevices.add(data.device);
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) {
    print('Connecting to ${device.name} ${device.id} ${device.type} }');

    this.device = device;

    return device.connect(timeout: Duration(seconds: 50)).catchError((e) {
      print('error $e');
    }).then((value) {
      print('then');
    }).whenComplete(() {
      print('Connected');
      getServices(device);
    });
  }

  bool get loadingDevices => _loadingDevices;
}
