import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/widgets/number_editor.dart';
import 'package:osc_remote/of_parameter_controller/widgets/point_editor.dart';

import '../types.dart';

class OFRectParameterWidget extends StatefulWidget {
  final OFParameter<String> param;

  OFRectParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFRectParameterWidgetState();
}

class OFRectParameterWidgetState extends State<OFRectParameterWidget> {
  double x;
  double y;
  double width;
  double height;

  @override
  void initState() {
    var vals = widget.param.value.split(',');
    x = double.parse(vals[0]);
    y = double.parse(vals[1]);
    width = double.parse(vals[3]);
    height = double.parse(vals[4]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          PointEditor(
            point: Offset(x, y),
            onChange: (offset) {},
          )
        ]);
  }
}
