import 'package:matrixdisplaypainter/screen/setting_screen.dart';
import 'package:matrixdisplaypainter/state/home_screen_state.dart';
import 'package:matrixdisplaypainter/state/setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Color> _colorlist = [];
  List<Color> genrateColorslist() {
    List<Color> _colorslist = [];
    for (int i = 0; i < (32 * 8); i++) {
      _colorslist.add(Colors.grey[800]);
    }
    return _colorslist;
  }

  @override
  void initState() {
    super.initState();
    _colorlist = genrateColorslist();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<HomeState>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton.icon(
                padding: EdgeInsets.all(14),
                onPressed: () {
                  showSettingsPage();
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: Text(
                  state.getConnectedDeviceName(),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 32 / 7,
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 32,
                    ),
                    itemCount: 8 * 32,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (_colorlist[index] == Colors.red) {
                            setState(() {
                              _colorlist[index] = Colors.grey[800];
                            });
                            state.sendTextToESP(index.toString() + "+0");
                          } else {
                            setState(() {
                              _colorlist[index] = Colors.red;
                            });
                            state.sendTextToESP(index.toString() + "+1");
                          }

                          print(index);
                        },
                        child: Container(
                          margin: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: _colorlist[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                state.sendTextToESP("clear");
                setState(() {
                  _colorlist = genrateColorslist();
                });
              },
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
    );
  }

  void sendText(String value, HomeState state) async {
    state.sendTextToESP(value);
    showInSnackBar('Sending $value');
  }

  void showSettingsPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => SettingState(), child: SettingsPage()),
        fullscreenDialog: true));
  }
}
