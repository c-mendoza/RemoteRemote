import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../of_parameter_controller.dart';

class ServerMethodsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var paramController = Provider.of<OFParameterController>(
      context, listen: false);
    var serverMethods = paramController.getServerMethods();
    return Container(
      width: 200,
      color: Theme
        .of(context)
        .canvasColor,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 200,
          ),
          FlatButton(
            child: Text(
              'Save',
              style: kButtonStyle,
            ),
            onPressed: () {
              paramController.save();
            },
          ),
          FlatButton(
            child: Text(
              'Revert',
              style: kButtonStyle,
            ),
            onPressed: () {
              paramController.revert();
              Navigator.pop(context);
//                    Navigator.popUntil(context, (route) {
//                      if(route.isFirst) return true;
//                      return false;
//                    });
              // pop all of the navigators? The widgets are not
              // reflecting the new values because their states are out
              // of sync with the values
            },
          ),
          for (var k in serverMethods.keys) ServerMethodButton(k, serverMethods[k]),
        ],
      ),
    );
  }

}

class ServerMethodButton extends StatelessWidget {
  final String name;
  final String uiName;

  ServerMethodButton(this.name, this.uiName);

  @override
  Widget build(BuildContext context) {
    var paramController = Provider.of<OFParameterController>(
      context, listen: false);
    return FlatButton(
      child: Text(
        uiName,
        style: kButtonStyle,
      ),
      onPressed: () {
        paramController.netController.callMethod(name);
        Navigator.pop(context);
      },
    );
  }

}