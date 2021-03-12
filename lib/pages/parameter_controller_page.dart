import 'package:flutter/material.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_group_view.dart';

class ParameterControllerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: kParamNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (context) => OFParameterGroupView(settings.name));
      },
    );
  }
}

Widget bla;


//class _