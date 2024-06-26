import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:remote_remote/app_model.dart';
import 'package:remote_remote/of_parameter_controller/networking_controller.dart';
import 'package:remote_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:remote_remote/pages/about_page.dart';
import 'package:remote_remote/pages/net_status_page.dart';
import 'package:remote_remote/pages/parameter_controller_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
//    print('${record.level.name}: ${record.time}: ${record.message}');
    print('${record.loggerName}: ${record.message}');
  });

  // TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  var netInterfaces =
      await NetworkInterface.list(type: InternetAddressType.IPv4);

  // Should we do a check for network interfaces? This will probably
  // crash if there are none
  var netController = NetworkingController(netInterfaces[0]);
  var paramController = OFParameterController(netController);
  var appModel = AppModel();

  netController.serverAddress = kDebugIp;

  return runApp(ParameterEditor(paramController, netController, appModel));
}

class ParameterEditor extends StatelessWidget {
  final OFParameterController parameterController;
  final NetworkingController netController;
  final AppModel appModel;

  ParameterEditor(this.parameterController, this.netController, this.appModel);

  @override
  Widget build(BuildContext context) {
    Color darkOrangeColor = kDarkOrangeColor;
    Color lightOrangeColor = kLightOrangeColor;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => netController),
        ChangeNotifierProvider(create: (_) => parameterController),
        ChangeNotifierProvider(create: (_) => appModel),
      ],
      child: MaterialApp(
        home: HomePage(),
        theme: ThemeData(
          // primaryColor: darkOrangeColor,
          sliderTheme: SliderThemeData(
            activeTrackColor: lightOrangeColor,
            inactiveTrackColor: darkOrangeColor,
            thumbColor: lightOrangeColor,
          ),
          colorScheme: ColorScheme.dark().copyWith(
            primary: darkOrangeColor,
            secondary: lightOrangeColor,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return lightOrangeColor;
              }
              return null;
            }),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return lightOrangeColor;
              }
              return null;
            }),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return lightOrangeColor;
              }
              return null;
            }),
            trackColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return lightOrangeColor;
              }
              return null;
            }),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;
  AppModel? appModel;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    appModel = Provider.of<AppModel>(this.context, listen: false);
    appModel?.addListener(onModelChange);
  }

  @override
  void dispose() {
    super.dispose();
    appModel?.removeListener(onModelChange);
  }

  void onModelChange() {
    if (_selectedIndex == 0) {
      if (appModel!.parametersReady) {
        if (appModel!.connectPressed) {
          setState(() {
            _selectedIndex = 1;
            _pageController.animateToPage(_selectedIndex,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            NetStatusPage(),
            ParameterControllerPage(),
            AboutPage(),
          ],
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Status',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Parameters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onItemTapped(int value) {
    if (value != _selectedIndex) {
      setState(() {
        _selectedIndex = value;
        _pageController.jumpToPage(_selectedIndex);
      });
    }
  }
}
