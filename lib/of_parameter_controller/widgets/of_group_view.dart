import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';

import '../of_parameter_controller.dart';
import '../types.dart';
import 'of_group_stub.dart';

class OFParameterGroupView extends StatelessWidget {
  final OFParameterGroup group;

//  final OFParameterController controller;

  const OFParameterGroupView(this.group);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusWatcher(
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: buildGroupChildren(context),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(group.name),
      ),
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
        Provider.of<OFParameterController>(context).getBuilder(param);

    return Container(
      child: paramWidget,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 0.5),
      )),
    );
  }
}
