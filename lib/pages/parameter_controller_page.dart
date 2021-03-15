import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:remote_remote/constants.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_group_view.dart';

import '../app_model.dart';

class ParameterControllerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context, listen: false);

    if (appModel.parametersReady) {
      return Navigator(
        key: kParamNavigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (context) => OFParameterGroupView(settings.name));
        },
      );
    } else {
      return SizedBox.expand(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
          'No parameters available.\n\nPlease go to the Status page and press Connect',
          style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,
        ),
            )),
      );
    }
  }
}

Widget bla;

//class _
