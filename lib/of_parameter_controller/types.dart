import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import 'of_parameter_controller.dart';

class OFBaseParameter extends PropertyChangeNotifier {
  final String name;
  final String path;
  final String type;

  OFBaseParameter(
      {@required this.name, @required this.path, @required this.type});
}

//typedef String SerializingFunction<T>(T value);

// ignore: mixin_inherits_from_not_object
class OFParameter<T> extends OFBaseParameter  {
  T _value;
  T _min;
  T _max;
//  SerializingFunction<T> _serializer;

  OFParameter(
    this._value, {
    @required String name,
    @required String path,
    @required String type,
    T min,
    T max,
//    SerializingFunction serialize,
  }) : super(
          name: name,
          path: path,
          type: type,
        ) {
    _min ??= min;
    _max ??= max;
//    serialize ??= (theValue) {
//      return _value.toString();
//    };

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

class ServerMethod {
  final String identifier;
  final String uiName;

  ServerMethod({@required this.identifier, @required this.uiName});
}