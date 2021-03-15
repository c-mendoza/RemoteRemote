import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:remote_remote/constants.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_group_view.dart';

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