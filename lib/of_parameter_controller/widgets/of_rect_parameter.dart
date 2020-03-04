import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/widgets/number_editor.dart';
import 'package:osc_remote/of_parameter_controller/widgets/point_editor.dart';

import '../../constants.dart';
import '../types.dart';

class OFRectParameterWidget extends StatefulWidget {
  final OFParameter<String> param;

  OFRectParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OFRectParameterWidgetState();
}

class OFRectParameterWidgetState extends State<OFRectParameterWidget> {
  double width;
  double height;
  Offset _anchorPoint;

  @override
  void initState() {
    super.initState();
    var vals = widget.param.value.split(',');
    _anchorPoint = Offset(double.parse(vals[0]), double.parse(vals[1]));
    width = double.parse(vals[3]);
    height = double.parse(vals[4]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(widget.param.name,
               style: kLabelStyle,
               textAlign: TextAlign.left,),
          PointEditor(
            point: _anchorPoint,
            onChange: (offset) {
              _anchorPoint = offset;
              serialize();
            },
          ),
          NumberEditor(
            label: 'Width',
            initialValue: width,
            decimals: 0,
            showSlider: true,
            onChanged: (val) {
              width = val.toDouble();
              serialize();
            },
          ),
          NumberEditor(
            label: 'Height',
            initialValue: height,
            decimals: 0,
            showSlider: true,
            onChanged: (val) {
              height = val.toDouble();
              serialize();
            },
          )
        ]);
  }

  void serialize() {
    widget.param.value =
        '${_anchorPoint.dx}, ${_anchorPoint.dy}, 0, $width, $height';
  }
}
