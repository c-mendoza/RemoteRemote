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

  String _name;
  String _path;

  OFParameter(
    this._value,
    {
      String name,
      String path,
      OFParameterType type,
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

  String get name => _name;

  String get path => _path;

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
}