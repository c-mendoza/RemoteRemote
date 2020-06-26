import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:osc_remote/app_model.dart';
import 'package:osc_remote/of_parameter_controller/networking_controller.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_group_view.dart';
import 'package:osc_remote/pages/net_status_page.dart';
import 'package:osc_remote/pages/parameter_controller_page.dart';
import 'package:provider/provider.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
//    print('${record.level.name}: ${record.time}: ${record.message}');
    print('${record.level.name}: ${record.message}');
  });

  var netController = NetworkingController();
  var paramController = OFParameterController(netController);
  var appModel = AppModel();

  return runApp(ParameterEditor(paramController, netController, appModel));
}

class ParameterEditor extends StatelessWidget {
  final OFParameterController parameterController;
  final NetworkingController netController;
  final AppModel appModel;

  ParameterEditor(this.parameterController, this.netController, this.appModel);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => netController),
        ChangeNotifierProvider(create: (_) => parameterController),
        ChangeNotifierProvider(create: (_) => appModel),
      ],
      child: MaterialApp(
        home: HomePage(),
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
  AppModel appModel;
  var _pageController;

  @override
  void initState() {
    super.initState();
    appModel = Provider.of<AppModel>(this.context, listen: false);
    appModel.addListener(onModelChange);
    _pageController = PageController();
  }


  @override
  void dispose() {
    super.dispose();
    appModel.removeListener(onModelChange);
  }

  void onModelChange() {
    if (_selectedIndex == 0) {
      if (appModel.parametersReady) {
        setState(() {
          _selectedIndex = 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Status'),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('Parameters'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('About'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return NetStatusPage();
      case 1:
        return OFParameterGroupView('/');
      case 2:
        return Container();
    }

    return Container();
  }

  void _onItemTapped(int value) {
    if (value != _selectedIndex) {
      setState(() {
        _selectedIndex = value;
      });
    }
  }
}
