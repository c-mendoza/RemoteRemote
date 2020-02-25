library of_parameter_controller;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:logging/logging.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_boolean_parameter.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_group_stub.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_number_parameter.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_string_parameter.dart';
import 'package:xml/xml.dart' as xml;

const String kGroupTypename = 'group';
const String kIntTypename = 'int';
const String kFloatTypename = 'float';
const String kBoolTypename = 'boolean';
const String kColorTypename = 'floatColor';
const String kStringTypename = 'string';
const String kUnknownTypename = 'unknown';

typedef DeserializerFunction = OFBaseParameter Function(
    {@required String value,
    @required String type,
    @required String name,
    @required String path,
    String min,
    String max});

typedef ParameterBuilderFunction = Widget Function(OFParameter param);

class OFParameterController {
  OFParameterGroup _root;

  Logger log = Logger('OFParameterController');

  Map<String, ParameterBuilderFunction> _typeBuilders = {};
  Map<String, DeserializerFunction> _typeDeserializers = {};

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

    addType(kBoolTypename, ({value, type, name, path, min, max}) {
      return OFParameter<bool>(value == '1',
          name: name, type: type, path: path);
    }, (param) => OFBooleanParameterWidget(param));

    addType(kColorTypename, ({value, type, name, path, min, max}) {
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
    }, (param) => OFStringParameter(param));
  }

  void addType(String name, DeserializerFunction deserializer,
      ParameterBuilderFunction builder) {
    _typeBuilders.putIfAbsent(name, () => builder);
    _typeDeserializers.putIfAbsent(name, () => deserializer);
  }

  void parse(String xmlString) {
    var document = xml.parse(xmlString);

//    print(document.rootElement.findElements('children').first.root);
    _root = deserializeGroup(document.rootElement);
  }

  /// Deserializes an ofParamterGroup
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

    if (_typeDeserializers.containsKey(typeString)) {
      return _typeDeserializers[typeString](
          value: value,
          name: name,
          type: typeString,
          path: pathForElement(element),
          min: min,
          max: max);
    } else {
      return _typeDeserializers[kUnknownTypename](
          value: value,
          name: name,
          path: pathForElement(element),
          type: kUnknownTypename);
    }
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

  OFParameterGroup getParameterGroup() => _root;

  Widget getBuilder(OFBaseParameter param) {
    if (_typeBuilders.containsKey(param.type)) {
      return _typeBuilders[param.type](param);
    } else {
      return _typeBuilders[kUnknownTypename](param);
    }
  }
}

class ParamContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
