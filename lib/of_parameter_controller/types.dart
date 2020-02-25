import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'of_parameter_controller.dart';

class OFBaseParameter {
  final String name;
  final String path;
  final OFParameterType type;

  OFBaseParameter(
    {@required this.name, @required this.path, @required this.type});
}

class OFParameter<T> extends OFBaseParameter {
  T _value;
  T _min;
  T _max;

  final String name;
  final String path;

  OFParameter(
    this._value,
    {
      @required this.name,
      @required this.path,
      @required OFParameterType type,
      T min,
      T max,
    }) : super(
    name: name,
    path: path,
    type: type,
    ) {
    _min ??= min;
    _max ??= max;
  }


  T get value => _value;

  set value(
    T value) {
    _value = value;
    //NOTIFY?
  }

  T get max => _max;

  T get min => _min;
}

class OFParameterGroup extends OFBaseParameter {
  List<OFBaseParameter> children = [];

  OFParameterGroup(
    {
      String name,
      String path,
    }) : super(
    name: name,
    path: path,
    type: OFParameterType.group,
    );

  void addChild(OFBaseParameter param) {
    children.add(param);
  }
}

class OFBaseParameterWidget extends StatefulWidget {
  final OFBaseParameter param;

  const OFBaseParameterWidget({Key key, this.param}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

}