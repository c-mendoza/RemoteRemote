import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';

class OFParameterGroupStub extends StatelessWidget {
  final OFParameterGroup group;

  const OFParameterGroupStub(this.group, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Text(group.name),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(flex: 8, child: Text(group.name)),
              Expanded(flex: 1, child: Icon(Icons.navigate_next))
            ],
          ),
        )
      ],
    );
  }
}
