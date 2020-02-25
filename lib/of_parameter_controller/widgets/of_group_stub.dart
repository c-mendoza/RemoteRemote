import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

import 'of_group_view.dart';

class OFParameterGroupStub extends StatelessWidget {
  final OFParameterGroup group;
  final OFParameterController controller;

  const OFParameterGroupStub(this.group, this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                  context) =>
                  OFParameterGroupView(group: group, controller: controller,)
                )
              );
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(22, 10, 10, 20),
            child: Row(
              children: <Widget>[
                Expanded(flex: 8, child: Text(group.name, style: kLabelStyle,)),
                Expanded(flex: 1, child: Icon(Icons.navigate_next, size: kLabelStyle.fontSize * 1.5,))
              ],
            ),
    ),
        );
  }
}
