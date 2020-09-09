import 'package:matrixdisplaypainter/services/ble_bluetooth_service.dart';

import 'package:matrixdisplaypainter/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluetoothDeviceList extends StatefulWidget {
  final title;

  @override
  _BluetoothDeviceListState createState() => _BluetoothDeviceListState(title);

  BluetoothDeviceList(this.title);
}

class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
  final title;

  _BluetoothDeviceListState(this.title);

  @override
  Widget build(BuildContext context) {
    var state = locator<BleBluetoothService>();
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              title,

//              StreamBuilder(
//                  stream: FlutterBlue.instance.isScanning,
//                  builder: (context, snapshot) {
//                    if (snapshot.hasData)
//                      return Visibility(
//                        visible: snapshot.data,
//                        child: SizedBox(
//                            height: 20,
//                            width: 20,
//                            child: Center(
//                                child: Padding(
//                                    padding: EdgeInsets.all(4),
//                                    child: CircularProgressIndicator()))),
//                      );
//                    return Container();
//                  })
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: state.devices.length,
            itemBuilder: (_, pos) {
              return ListTile(
                title: Text(state.devices[pos].name),
                subtitle: Text(state.devices[pos].id.toString()),
                onTap: () {
                  state.connectToDevice(state.devices[pos]).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
              );
            },
          )
//          StreamBuilder(
//            stream: state.getStream(),
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//                print(snapshot.data);
//                return ListView.builder(
//                    shrinkWrap: true,
//                    itemCount: snapshot.data.length,
//                    itemBuilder: (context, pos) => ListTile(
//                          contentPadding: EdgeInsets.all(18),
//                          title: Text(snapshot.data[pos].name),
//                          subtitle: Text(snapshot.data[pos].id.toString()),
//                          dense: true,
//                          trailing: Icon(Icons.arrow_right),
//                          leading: Icon(Icons.bluetooth),
//                          onTap: () {
//                            state.connectToDevice(snapshot.data[pos]);
//                          },
//                        ));
//              } else if (snapshot.connectionState == ConnectionState.waiting) {
//                return Column(
//                  children: <Widget>[
//                    Text(
//                      'Waiting For ESP if does not show up restart the app with bluetooth and location turned on !!',
//                      style: TextStyle(
//                        fontSize: 30.0,
//                      ),
//                    ),
//                    CircularProgressIndicator()
//                  ],
//                );
//              }
//              return Text(
//                '00:${snapshot.data.toString().padLeft(2, '0')}',
//                style: TextStyle(
//                  fontSize: 30.0,
//                ),
//              );
//            },
//          )
        ],
      ),
    );
  }
}
