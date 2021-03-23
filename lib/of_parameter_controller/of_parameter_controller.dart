library of_parameter_controller;

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:remote_remote/of_parameter_controller/networking_controller.dart';
import 'package:remote_remote/of_parameter_controller/types.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_boolean_parameter.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_color_parameter.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_number_parameter.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_path_parameter.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_rect_parameter.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_string_parameter.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_vector_parameter.dart';
import 'package:xml/xml.dart' as xml;
import 'package:vector_math/vector_math.dart';

const String kGroupTypename = 'group';
const String kIntTypename = 'int';
const String kFloatTypename = 'float';
const String kDoubleTypename = 'double';
const String kBoolTypename = 'boolean';
const String kFloatColorTypename = 'floatColor';
const String kColorTypename = 'color';
const String kStringTypename = 'string';
const String kVec2Typename = 'vec2';
const String kVec3Typename = 'vec3';
const String kVec4Typename = 'vec4';
const String kUnknownTypename = 'unknown';

typedef DeserializingFunction = OFBaseParameter Function(
    {@required String value,
    @required String type,
    @required String name,
    @required String path,
    String min,
    String max});

typedef ParameterBuilderFunction = Widget Function(OFParameter param);
typedef SerializingFunction = String Function(OFParameter param);

final SerializingFunction defaultSerializer = (param) {
  return param.toString();
};

class OFParameterController with ChangeNotifier {
  OFParameterGroup _group;
  final NetworkingController netController;
  Logger log = Logger('OFParameterController');

  Map<String, ParameterBuilderFunction> _typeBuilders = {};
  Map<String, DeserializingFunction> _typeDeserializers = {};
  Map<String, SerializingFunction> _typeSerializers = {};

  Map<String, String> _serverMethods = {};

  UnmodifiableMapView<String, String> getServerMethods() {
    return UnmodifiableMapView(_serverMethods);
  }

  OFParameterGroup get group => _group;

  OFParameterController(this.netController) {
    addType(kStringTypename, ({value, type, name, path, min, max}) {
      return OFParameter<String>(value, name: name, path: path, type: type);
    }, (param) => OFStringParameter(param));

    addType(kUnknownTypename, ({value, type, name, path, min, max}) {
      return OFParameter<String>(value, name: name, path: path, type: type);
    }, (param) => OFStringParameter(param));

    addType(kIntTypename, ({value, type, name, path, min, max}) {
      return OFParameter<int>(int.parse(value),
          name: name,
          type: type,
          path: path,
          min: int.parse(min),
          max: int.parse(max));
    }, (param) => OFNumberParameterWidget(param));

    addType(kFloatTypename, ({value, type, name, path, min, max}) {
      return OFParameter<double>(double.parse(value),
          name: name,
          type: type,
          path: path,
          min: double.parse(min),
          max: double.parse(max));
    }, (param) => OFNumberParameterWidget(param));

    addType(kDoubleTypename, ({value, type, name, path, min, max}) {
      return OFParameter<double>(double.parse(value),
          name: name,
          type: type,
          path: path,
          min: double.parse(min),
          max: double.parse(max));
    }, (param) => OFNumberParameterWidget(param));

    addType(
        kBoolTypename,
        ({value, type, name, path, min, max}) {
          return OFParameter<bool>(value == '1',
              name: name, type: type, path: path);
        },
        (param) => OFBooleanParameterWidget(param),
        (param) {
          bool val = param.value as bool;
          if (val) {
            return '1';
          } else {
            return '0';
          }
        });

    addType(
        kFloatColorTypename,
        ({value, type, name, path, min, max}) {
          var colorChannels = [];
          value.split(',').forEach((String s) {
            var v = double.tryParse(s.trim());
            if (v == null) {
              v = 0;
              log.severe('Error parsing color channel');
            }
            var ch = v * 255;
            colorChannels.add(ch.toInt());
          });

          if (colorChannels.length != 4) {
            log.severe(
                'In parsing ofFloatColor: Incorrect number of color channels');
            return _typeDeserializers[kStringTypename](
                value: value, type: kUnknownTypename, name: name, path: path);
          }

          var color = Color.fromARGB(colorChannels[3], colorChannels[0],
              colorChannels[1], colorChannels[2]);
          return OFParameter<Color>(color, name: name, type: type, path: path);
        },
        (param) => OFColorParameterWidget(param),
        (param) {
          Color c = param.value as Color;
          var red = c.red.toDouble() / 255.0;
          var green = c.green.toDouble() / 255.0;
          var blue = c.blue.toDouble() / 255.0;
          var alpha = c.alpha.toDouble() / 255.0;
          return '$red, $green, $blue, $alpha';
        });

    addType(
        kColorTypename,
        ({value, type, name, path, min, max}) {
          var colorChannels = [];
          value.split(',').forEach((String s) {
            var v = int.tryParse(s.trim());
            if (v == null) {
              v = 0;
              log.severe('Error parsing color channel');
            }
            colorChannels.add(v);
          });

          if (colorChannels.length == 3) {
            colorChannels.add(255); // Add alpha
          }

          if (colorChannels.length != 4) {
            log.severe(
                'In parsing ofColor: Incorrect number of color channels');
            return _typeDeserializers[kStringTypename](
                value: value, type: kUnknownTypename, name: name, path: path);
          }

          var color = Color.fromARGB(colorChannels[3], colorChannels[0],
              colorChannels[1], colorChannels[2]);
          return OFParameter<Color>(color, name: name, type: type, path: path);
        },
        (param) => OFColorParameterWidget(param),
        (param) {
          Color c = param.value as Color;
          return '${c.red}, ${c.green}, ${c.blue}, ${c.alpha}';
        });

    addType('ofRectangle', ({value, type, name, path, min, max}) {
      return OFParameter<String>(
        value,
        name: name,
        type: type,
        path: path,
      );
    }, (param) {
      return OFRectParameterWidget(param);
    });

    addType('ofPath', ({value, type, name, path, min, max}) {
      return OFParameter<String>(
        value,
        name: name,
        type: type,
        path: path,
      );
    }, (param) {
      return OFPathParameter(param);
    });

    addType(kVec2Typename, ({value, type, name, path, min, max}) {
      return OFParameter<Vector2>(_parseVector(value, 2),
          name: name,
          type: type,
          path: path,
          min: _parseVector(min, 2),
          max: _parseVector(max, 2));
    },
        (param) => OFVectorParameterWidget(
              param: param,
              dims: 2,
            ),
        _serializeVector);

    addType(kVec3Typename, ({value, type, name, path, min, max}) {
      return OFParameter<Vector3>(_parseVector(value, 3),
          name: name,
          type: type,
          path: path,
          min: _parseVector(min, 3),
          max: _parseVector(max, 3));
    }, (param) => OFVectorParameterWidget(param: param, dims: 3),
        _serializeVector);

    addType(kVec4Typename, ({value, type, name, path, min, max}) {
      return OFParameter<Vector4>(_parseVector(value, 4),
          name: name,
          type: type,
          path: path,
          min: _parseVector(min, 4),
          max: _parseVector(max, 4));
    }, (param) => OFVectorParameterWidget(param: param, dims: 4),
        _serializeVector);

    //TODO Serialize Vector

//    addType('ofPolyline', ({value, type, name, path, min, max}) {
//      return OFParameter<String>(
//        value,
//        name: name,
//        type: type,
//        path: path,
//      );
//    }, (param) {
//      return OFPolylineParameter(param);
//    });
  }

  dynamic _parseVector(String stringValue, int dims) {
    if (dims < 2 || dims > 4) {
      log.severe(
          'Error parsing Vector: Dimensions out of bounds. dims = $dims');
      dims = 2;
    }

    List<double> values = [];

    var components = stringValue.split(',');
    if (components.length != dims) {
      log.severe('Error parsing Vector: Dimensions do not match. dims = $dims '
          'components = ${components.length}');
      values.fillRange(0, values.length, 0);
    } else {
      for (var c in components) {
        values.add(double.parse(c));
      }
    }

    switch (dims) {
      case 2:
        var ret = Vector2.array(values);
        return ret;
      case 3:
        var ret = Vector3.array(values);
        return ret;
      case 4:
        var ret = Vector4.array(values);
        return ret;
    }
  }

  ////////////////// DATA AND SERIALIZATION
  /////////////////////////////////////////
  /////////////////////////////////////////
  /////////////////////////////////////////

  void addType(String name, DeserializingFunction deserializer,
      ParameterBuilderFunction builder,
      [SerializingFunction serializer]) {
    _typeBuilders.putIfAbsent(name, () => builder);
    _typeDeserializers.putIfAbsent(name, () => deserializer);
    serializer ??= defaultSerializer;
    _typeSerializers.putIfAbsent(name, () => serializer);
  }

  /// Parses the XML string and starts the deserialization. Returns false if either
  /// the parsing or the deserialization fails.
  bool parse(String xmlString) {
    xml.XmlDocument document;
    try {
      document = xml.parse(xmlString);
    } catch (e) {
      log.severe('Error parsing group xml.\n XML String:\n{$xmlString');
      return false;
    }

    // If there is a previous group, dispose of all of the params
    if (group != null) {
//     print(group.children.first)
      forEachParam(group, (OFParameter param) {
        try {
          param.dispose; // <---- Whaaaaaaa??? Why doesn't dispose() work?
        } catch (e) {
          log.warning(e.toString());
        }
      });
    }

    xml.XmlElement paramRoot;
    xml.XmlElement methodsRoot;

    for (var el in document.firstChild.children) {
      if (el.nodeType == xml.XmlNodeType.ELEMENT) {
        if ((el as xml.XmlElement).name.toString() == "Parameters") {
          paramRoot = el;
        } else if ((el as xml.XmlElement).name.toString() == "Methods") {
          methodsRoot = el;
        }
      }
    }
//    print(document.rootElement.findElements('children').first.root);
    var bla = paramRoot.firstChild;
    var groupRoot = paramRoot.descendants.firstWhere(
        (xml.XmlNode element) => element.nodeType == xml.XmlNodeType.ELEMENT);
    _group = _deserializeGroup(groupRoot);
    if (_group == null) {
      log.severe('Error parsing parameterGroup');
      netController.status = NetStatus.ParserError;
      return false;
    }

    for (var el in methodsRoot.children) {
      if (el.nodeType == xml.XmlNodeType.ELEMENT) {
        var methodName = (el as xml.XmlElement).name.toString();
        var uiName = (el as xml.XmlElement).getAttribute('uiName');
        // ignore 'default' methods, those are handled separately
        if (methodName.contains('revert') ||
            methodName.contains('save') ||
            methodName.contains('set') ||
            methodName.contains('connect') ||
            methodName.contains('getModel')) {
          // ignore
        } else {
          _serverMethods[methodName] = uiName;
        }
      }
    }

    netController.status = NetStatus.Connected;
    notifyListeners();
    return true;
  }

  /// Deserializes an ofParameterGroup
  OFParameterGroup _deserializeGroup(xml.XmlElement element) {
    //Basic check, the root element should be type group
    var res = element.attributes
        .firstWhere((element) => element.name.toString() == 'type');
    if (res.value != 'group') {
      log.severe("Error: Not a Group");
      return null;
    }

    var group = OFParameterGroup(
        name: element.getAttribute('name'), path: _pathForElement(element));

    element.children.forEach((xml.XmlNode element) {
      if (element.nodeType != xml.XmlNodeType.ELEMENT) return;
      group.addChild(_deserializeParameter(element));
    });

    return group;
  }

  void forEachParam(OFParameterGroup group, Function f) {
    for (var param in group.children) {
      if (param.runtimeType != OFParameterGroup) {
        f(param as OFParameter);
      } else {
        forEachParam(param, f);
      }
    }
  }

  void forEachGroup(OFParameterGroup group, Function f) {
    for (var param in group.children) {
      if (param.runtimeType == OFParameterGroup) {
        f(param as OFParameterGroup);
        forEachGroup(param, f);
      }
    }
  }

  OFBaseParameter parameterForPath(String path) {
    log.severe('parameterForPath is not implemented');
  }

  /// Deserializes a single parameter. If a parameter is a group it calls [_deserializeGroup].
  OFBaseParameter _deserializeParameter(xml.XmlElement element) {
    var typeString;
    try {
      typeString = element.getAttribute('type');
    } catch (e) {
      return null;
    }

    if (typeString == kGroupTypename) return _deserializeGroup(element);

    var value = element.findElements('value').first.text;
    var name = element.getAttribute('name');

    var min = '';
    var max = '';
    try {
      var el = element.findElements('min');
      if (el.isNotEmpty) min = el.first.text;
      el = element.findElements('max');
      if (el.isNotEmpty) max = el.first.text;
    } catch (e) {}

    if (min == '') min = '0';
    if (max == '') max = '0';

    var param;
    if (_typeDeserializers.containsKey(typeString)) {
      param = _typeDeserializers[typeString](
          value: value,
          name: name,
          type: typeString,
          path: _pathForElement(element),
          min: min,
          max: max);
    } else {
      param = _typeDeserializers[kUnknownTypename](
          value: value,
          name: name,
          path: _pathForElement(element),
          type: kUnknownTypename);
    }

    param.addListener((changedParam) {
      String valueString = _serializeParameter(changedParam);
//      print(valueString);
      netController?.sendParameter(changedParam.path, valueString);
    });

    return param;
  }

  String _serializeParameter(OFParameter param) {
    return _typeSerializers[param.type](param);
  }

  /// Creates a calling path for a given element
  String _pathForElement(xml.XmlElement el) {
    var pathComponents = [];
    // Group hierarchy is in escaped mode in OF:
    pathComponents.add(el.name);

    for (var node in el.ancestors) {
      if (node.nodeType == xml.XmlNodeType.ELEMENT) {
        var element = node as xml.XmlElement;
        pathComponents.add(element.name);
      }
    }

    // The first two nodes of the xml tree don't have anything to do with OFParameters,
    // so we remove them:
    pathComponents.removeLast();
    pathComponents.removeLast();
    String path = '';
    for (var component in pathComponents.reversed) {
      path = '$path/$component';
    }

    return path;
  }

  Widget getBuilder(OFBaseParameter param) {
    if (_typeBuilders.containsKey(param.type)) {
      return _typeBuilders[param.type](param);
    } else {
      return _typeBuilders[kUnknownTypename](param);
    }
  }

  void save() {
    netController.callSave();
  }

  void revert() async {
    netController.callRevert();
  }

  static String serializeColor(Color c) {
    var red = c.red;
    var green = c.green;
    var blue = c.blue;
    var alpha = c.alpha;
    return '$red, $green, $blue, $alpha';
  }

  static Color deserializeColor(String value) {
    var colorChannels = [];
    value.split(',').forEach((String s) {
      var v = double.tryParse(s.trim());
      if (v == null) {
        v = 0;
//        log.severe('Error parsing color channel');
      }
      var ch = v;
      colorChannels.add(ch.toInt());
    });

    if (colorChannels.length != 4) {
//      log.severe(
//        'In parsing ofFloatColor: Incorrect number of color channels');
//      return _typeDeserializers[kStringTypename](
//        value: value, type: kUnknownTypename, name: name, path: path);
      return Color.fromARGB(255, 255, 255, 255);
    }

    return Color.fromARGB(
        colorChannels[3], colorChannels[0], colorChannels[1], colorChannels[2]);
  }

  // GETTERS AND SETTERS
  /////////////////////////////////////////
  /////////////////////////////////////////
  /////////////////////////////////////////

  OFParameterGroup getParameterGroup() => _group;

  OFParameterGroup getGroupForPath(String groupPath) {
    if (groupPath == '/') return _group;
    var foundGroup;

    forEachGroup(_group, (OFParameterGroup pg) {
      if (pg.path == groupPath) foundGroup = pg;
    });

    return foundGroup;
  }

  String _serializeVector(OFParameter<dynamic> param) {
    var values = (param.value as Vector).storage;
    String output = '';
    for (int i = 0; i < values.length; i++) {
      output += values[i].toString();
      if (i < values.length - 1) {
        output += ', ';
      }
    }
    return output;
  }
}

class ParamContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
