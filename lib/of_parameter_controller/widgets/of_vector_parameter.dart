import 'package:flutter/material.dart';
import 'package:remote_remote/constants.dart';
import 'package:remote_remote/of_parameter_controller/types.dart';
import 'package:vector_math/vector_math.dart';

import 'number_editor.dart';

const labels = ['x', 'y', 'z', 'w'];

class OFVectorParameterWidget extends StatelessWidget {
  final OFParameter param;
  final int dims;

  const OFVectorParameterWidget({Key key, this.param, this.dims})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var v;
    switch (dims) {
      case 2:
        v = param.value as Vector2;
        break;
      case 3:
        v = param.value as Vector3;
        break;
      case 4:
        v = param.value as Vector4;
        break;
    }

    List<Widget> editors = [];
    for (int i = 0; i < dims; i++) {
      editors.add(NumberEditor(
          label: labels[i],
          value: v[i],
          min: param.min[i],
          max: param.max[i],
          decimals: kMaxDecimals,
          onChanged: (val) {
            v[i] = val;
            param.value = v;
          }));
    }
    return Column(
      children: [
        Text(
          param.name,
          textAlign: TextAlign.left,
          style: kLabelStyle,
        ),
        ...editors
      ],
    );
  }
}
