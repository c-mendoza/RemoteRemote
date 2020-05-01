import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/networking_controller.dart';
import 'package:osc_remote/of_parameter_controller/widgets/EditorAppBar.dart';
import 'package:osc_remote/of_parameter_controller/widgets/server_methods_view.dart';
import 'package:provider/provider.dart';

import '../of_parameter_controller.dart';
import '../types.dart';
import 'of_group_stub.dart';

//final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class OFParameterGroupView extends StatelessWidget {
  final String groupPath;

//  final OFParameterController controller;

  const OFParameterGroupView(this.groupPath);

  @override
  Widget build(BuildContext context) {
    return Consumer<OFParameterController>(
        builder: (context, paramController, __) {
      var group = paramController.getGroupForPath(groupPath);
      return Scaffold(
        endDrawer: ServerMethodsView(),
        body: FocusWatcher(
          child: Container(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: buildGroupChildren(context, group),
            ),
          ),
        ),
        appBar: EditorAppBar.build(context, group.name),
      );
    });
  }

  List<Widget> buildGroupChildren(
      BuildContext context, OFParameterGroup group) {
    var children = <Widget>[];

    bool isFirst = true;
    for (var child in group.children) {
      children.add(buildParameter(child, context, isFirst));
      isFirst = false;
    }

    return children;
  }

  Widget buildParameter(OFBaseParameter param, BuildContext context,
      [bool isFirst]) {
    // TODO The container I have here should serve both the GroupStub and the paramWidget
    Widget paramWidget;

    if (param.type == kGroupTypename) {
      paramWidget = OFParameterGroupStub(param.path);
    } else {
      paramWidget = Provider.of<OFParameterController>(context, listen: false)
          .getBuilder(param);
    }

    var border = Border(
      top: BorderSide(width: 0.5),
    );

    return Container(
        child: paramWidget,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        decoration: BoxDecoration(
          border: isFirst ? null : border,
        ));
  }
}
