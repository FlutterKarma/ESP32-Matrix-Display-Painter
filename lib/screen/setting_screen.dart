import 'package:matrixdisplaypainter/BluetoothDeviceList.dart';
import 'package:matrixdisplaypainter/utility/constants.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController switchOnTextController = TextEditingController();

  TextEditingController switchOffTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
//        backgroundColor: Constants.dayColor,
        appBar: AppBar(
          backgroundColor: Constants.nightColor,
        ),
        body: SafeArea(
          child: CustomScrollView(
//            shrinkWrap: true,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  BluetoothDeviceList(
                    Padding(
                      child: Text(
                        "Paired Devices",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }
}
