import 'package:matrixdisplaypainter/screen/HomeScreen.dart';
import 'package:matrixdisplaypainter/services/service_locator.dart';
import 'package:matrixdisplaypainter/state/home_screen_state.dart';
import 'package:matrixdisplaypainter/state/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Matrix Painter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => HomeState(),
          ),
          ChangeNotifierProvider(
            create: (_) => SettingState(),
          ),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
