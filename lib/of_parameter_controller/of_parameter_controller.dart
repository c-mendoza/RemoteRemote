library of_parameter_controller;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:logging/logging.dart';
import 'package:osc/osc.dart';
import 'package:osc_remote/of_parameter_controller/networking_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_boolean_parameter.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_color_parameter.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_group_stub.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_number_parameter.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_string_parameter.dart';
import 'package:wifi/wifi.dart';
import 'package:xml/xml.dart' as xml;

const String kGroupTypename = 'group';
const String kIntTypename = 'int';
const String kFloatTypename = 'float';
const String kDoubleTypename = 'double';
const String kBoolTypename = 'boolean';
const String kColorTypename = 'floatColor';
const String kStringTypename = 'string';
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
  NetworkingController netController;
  Logger log = Logger('OFParameterController');

  Map<String, ParameterBuilderFunction> _typeBuilders = {};
  Map<String, DeserializingFunction> _typeDeserializers = {};
  Map<String, SerializingFunction> _typeSerializers = {};

  OFParameterGroup get group => _group;

  OFParameterController() {
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
        kColorTypename,
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
    try {
      var document = xml.parse(xmlString);

//    print(document.rootElement.findElements('children').first.root);
      _group = deserializeGroup(document.rootElement);
      if (_group == null) {
        log.severe('Error parsing parameterGroup');
        return false;
      }
      return true;
    } catch (e) {
      log.severe('Error parsing group xml.\n XML String:\n{$xmlString');
      return false;
    }
  }

  /// Deserializes an ofParameterGroup
  OFParameterGroup deserializeGroup(xml.XmlElement element) {
    //Basic check, the root element should be type group
    var res = element.attributes
        .firstWhere((element) => element.name.toString() == 'type');
    if (res.value != 'group') {
      log.severe("Error: Not a Group");
      return null;
    }

    var group = OFParameterGroup(
        name: element.getAttribute('name'), path: pathForElement(element));

    element.children.forEach((xml.XmlNode element) {
      if (element.nodeType != xml.XmlNodeType.ELEMENT) return;
      group.addChild(deserializeParameter(element));
    });

    return group;
  }

  /// Deserializes a single parameter. Makes an exception for groups.
  OFBaseParameter deserializeParameter(xml.XmlElement element) {
    var typeString;
    try {
      typeString = element.getAttribute('type');
    } catch (e) {
      return null;
    }

    if (typeString == kGroupTypename) return deserializeGroup(element);

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

    var param;
    if (_typeDeserializers.containsKey(typeString)) {
      param = _typeDeserializers[typeString](
          value: value,
          name: name,
          type: typeString,
          path: pathForElement(element),
          min: min,
          max: max);
    } else {
      param = _typeDeserializers[kUnknownTypename](
          value: value,
          name: name,
          path: pathForElement(element),
          type: kUnknownTypename);
    }

    param.addListener((changedParam) {
      String valueString = serializeParameter(changedParam);
      print(valueString);
      netController.sendParameter(changedParam.path, valueString);
    });

    return param;
  }

  String serializeParameter(OFParameter param) {
    return _typeSerializers[param.type](param);
  }

  /// Creates a calling path for a given element
  String pathForElement(xml.XmlElement el) {
    var pathComponents = [];
    // Group hierarchy is in escaped mode in OF:
    pathComponents.add(el.name);

    for (var node in el.ancestors) {
      if (node.nodeType == xml.XmlNodeType.ELEMENT) {
        var element = node as xml.XmlElement;
        pathComponents.add(element.name);
      }
    }

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

  // GETTERS AND SETTERS
  /////////////////////////////////////////
  /////////////////////////////////////////
  /////////////////////////////////////////

  OFParameterGroup getParameterGroup() => _group;
}

class ParamContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
