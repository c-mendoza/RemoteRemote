import 'package:flutter/material.dart';
import 'package:remote_remote/constants.dart';
import 'package:remote_remote/of_parameter_controller/types.dart';

import '../of_parameter_controller.dart';
import 'number_editor.dart';

class OFNumberParameterWidget extends StatelessWidget {
  final OFParameter param;

  const OFNumberParameterWidget(this.param, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberEditor(
      label: param.name,
      value: param.value,
      min: param.min,
      max: param.max,
      decimals: param.type == kIntTypename ? 0 : kMaxDecimals,
      onChanged: (val) {
        param.value = val;
      },
    );
  }
}

