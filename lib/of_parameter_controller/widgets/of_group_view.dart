import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/networking_controller.dart';
import 'package:osc_remote/of_parameter_controller/widgets/EditorAppBar.dart';
import 'package:provider/provider.dart';

import '../of_parameter_controller.dart';
import '../types.dart';
import 'of_group_stub.dart';

//final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class OFParameterGroupView extends StatelessWidget {
  final OFParameterGroup group;

//  final OFParameterController controller;

  const OFParameterGroupView(this.group);

  @override
  Widget build(BuildContext context) {
    var paramController = Provider.of<OFParameterController>(context, listen: false);
    return Scaffold(
      endDrawer: Container(
        width: 200,
        color: Theme.of(context).canvasColor,
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
            FlatButton(
              child: Text(
                'Add Multiline',
                style: kButtonStyle,
              ),
              onPressed: () {},
            ),
            FlatButton(
              child: Text(
                'Add Mask',
                style: kButtonStyle,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: FocusWatcher(
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: buildGroupChildren(context),
          ),
        ),
      ),
      appBar: EditorAppBar.build(context, group.name),
    );
  }

  List<Widget> buildGroupChildren(BuildContext context) {
    var children = <Widget>[];

    for (var child in group.children) {
      children.add(buildParameter(child, context));
    }

    return children;
  }

  Widget buildParameter(OFBaseParameter param, BuildContext context) {
    if (param.type == kGroupTypename) return OFParameterGroupStub(param);

    Widget paramWidget =
        Provider.of<OFParameterController>(context, listen: false).getBuilder(param);

    return Container(
      child: paramWidget,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 0.5),
      )),
    );
  }
}
