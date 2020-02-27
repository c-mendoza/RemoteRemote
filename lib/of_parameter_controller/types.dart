import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import 'of_parameter_controller.dart';

class OFBaseParameter {
  final String name;
  final String path;
  final String type;

  OFBaseParameter(
      {@required this.name, @required this.path, @required this.type});
}

// ignore: mixin_inherits_from_not_object
class OFParameter<T> extends OFBaseParameter with PropertyChangeNotifier {
  T _value;
  T _min;
  T _max;

  OFParameter(
    this._value, {
    @required String name,
    @required String path,
    @required String type,
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

  set value(T value) {
    _value = value;
    notifyListeners(this);
    //NOTIFY?
  }

  T get max => _max;

  T get min => _min;

  String toString() {
    return _value.toString();
  }
}

class OFParameterGroup extends OFBaseParameter {
  List<OFBaseParameter> children = [];

  OFParameterGroup({
    String name,
    String path,
  }) : super(
          name: name,
          path: path,
          type: kGroupTypename,
        );

  void addChild(OFBaseParameter param) {
    children.add(param);
  }
}

abstract class OFBaseParameterWidget extends StatefulWidget {
  final OFBaseParameter param;

  const OFBaseParameterWidget(this.param, {Key key}) : super(key: key);
}
