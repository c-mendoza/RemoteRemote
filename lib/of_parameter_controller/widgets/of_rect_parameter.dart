import 'package:flutter/material.dart';

import '../types.dart';

class OFRectParameterWidget extends StatefulWidget {
  final OFParameter<String> param;

  OFRectParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFRectParameterWidgetState();
}

class OFRectParameterWidgetState extends State<OFRectParameterWidget> {
//  double x;
//  double y;
//  double width;
//  double height;
  OFParameter<double> x;
  OFParameter<double> y;
  OFParameter<double> width;
  OFParameter<double> height;

  OFRectParameterWidgetState() {
    var vals = widget.param.value.split(',');
    x.value = double.parse(vals[0]);
    y.value = double.parse(vals[1]);
    width.value = double.parse(vals[3]);
    height.value = double.parse(vals[4]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
