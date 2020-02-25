library of_parameter_controller;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_boolean_parameter.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_group_stub.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_number_parameter.dart';
import 'package:osc_remote/of_parameter_controller/widgets/of_string_parameter.dart';
import 'package:xml/xml.dart' as xml;

import '../constants.dart';

enum OFParameterType {
  unknown,
  integer,
  floating,
  boolean,
  color,
  string,
  group,
  vec2
}

const Map<String, OFParameterType> TypeStrings = {
  'unknown': OFParameterType.unknown,
  'int': OFParameterType.integer,
  'float': OFParameterType.floating,
  'boolean': OFParameterType.boolean,
  'floatColor': OFParameterType.color,
  'string': OFParameterType.string,
  'group': OFParameterType.group,
  'vec2': OFParameterType.vec2,
};

typedef OFBaseParameter DeserializerFunction(xml.XmlElement element);

typedef OFBaseParameterWidget ParameterBuilderFunction(OFParameter param);

class OFParameterController {
  OFParameterGroup _root;

  var _typeInitializers = Map<String, Function(dynamic)>();
  var _typeDeserializers = Map<String, DeserializerFunction>();

  addType(String name, DeserializerFunction deserializer, Function(dynamic) initializer) {
    _typeInitializers.putIfAbsent(name, () => initializer);
    _typeDeserializers.putIfAbsent(name, () => deserializer);
  }

  OFParameterController();

  OFParameterGroup parse(String xmlString) {
    var document = xml.parse(xmlString);

//    print(document.rootElement.findElements('children').first.root);
    _root = deserializeGroup(document.rootElement);
  }

  OFParameterGroup deserializeGroup(xml.XmlElement element) {
    //Basic check, the root element should be type group
    var res = element.attributes
        .firstWhere((element) => element.name.toString() == 'type');
    print(res.text);
    if (res.value != getStringForType(OFParameterType.group)) {
      print("Error: Not a Group");
      return null;
    }

    var group = OFParameterGroup(
        name: element.getAttribute('name'), path: pathForElement(element));

    element.children.forEach((xml.XmlNode element) {
//      print('----------------------');
//      print(element.nodeType);
      if (element.nodeType != xml.XmlNodeType.ELEMENT) return;
      group.addChild(deserializeParameter(element));
    });

    return group;
  }

  OFBaseParameter deserializeParameter(xml.XmlElement element) {
    var typeString;
    try {
      typeString = element.getAttribute('type');
    } catch (e) {
      return null;
    }

    var type = getTypeForString(typeString);

    if (type == OFParameterType.group) return deserializeGroup(element);

    var value = element.findElements('value').first.text;
    var name = element.getAttribute('name');
    switch (type) {
      case OFParameterType.unknown:
        return OFParameter<String>(value.toString(),
            name: name, type: type, path: pathForElement(element));
        break;
      case OFParameterType.integer:
        var min = element.findElements('min').first.text;
        var max = element.findElements('max').first.text;
        return OFParameter<int>(int.parse(value),
            name: name,
            type: type,
            min: int.parse(min),
            max: int.parse(max),
            path: pathForElement(element));
        break;
      case OFParameterType.floating:
        var min = element.findElements('min').first.text;
        var max = element.findElements('max').first.text;
        return OFParameter<double>(double.parse(value),
            name: name,
            type: type,
            min: double.parse(min),
            max: double.parse(max),
            path: pathForElement(element));
        break;
      case OFParameterType.boolean:
        return OFParameter<bool>(value == '1',
            name: name, type: type, path: pathForElement(element));
        break;
      case OFParameterType.color:
        var values = value.split(',');
        values.forEach((e) {
          e.trim();
        });

        break;
      case OFParameterType.string:
        return OFParameter<String>(value.toString(),
            name: name, type: type, path: pathForElement(element));
        break;
      case OFParameterType.group:
        print('WR SHOULD NOT BE HERE');
        break;
      case OFParameterType.vec2:
        // TODO: Handle this case.
        break;
    }

    return OFParameter<String>(value.toString(),
        name: name, type: type, path: pathForElement(element));
  }

  String pathForElement(xml.XmlElement el) {
    if (!el.hasParent) return '/${el.name}';

//    el.parent.root
  }

  String getStringForType(OFParameterType type) {
    String result = 'unknown';

    TypeStrings.forEach((String k, v) {
      if (v == type) result = k;
    });

    return result;
  }

  OFParameterType getTypeForString(String typeString) {
    if (TypeStrings.containsKey(typeString)) {
      return TypeStrings[typeString];
    } else {
      return OFParameterType.unknown;
    }
  }

  void _parseGroup() {}

  OFParameterGroup getParameterGroup() => _root;
}

class OFParameterGroupView extends StatelessWidget {
  final OFParameterGroup group;

  const OFParameterGroupView({this.group});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FocusWatcher(
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: buildGroupChildren(),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(group.name),
      ),
    );
  }

  List<Widget> buildGroupChildren() {
    var children = <Widget>[];

    for (var child in group.children) {
      children.add(buildParameter(child));
    }

    return children;
  }

  Widget buildParameter(OFBaseParameter param) {
    Widget paramWidget;

    switch (param.type) {
      case OFParameterType.unknown:
        paramWidget = OFStringParameter(param);
        break;
      case OFParameterType.integer:
        paramWidget = OFNumberParameterWidget(param);
        break;
      case OFParameterType.floating:
        paramWidget = OFNumberParameterWidget(param);
        break;
      case OFParameterType.boolean:
        paramWidget = OFBooleanParameterWidget(param);
        break;
      case OFParameterType.color:
        paramWidget = OFStringParameter(param);
        break;
      case OFParameterType.string:
        paramWidget = OFStringParameter(param);
        break;
      case OFParameterType.group:
        paramWidget = OFParameterGroupStub(param);
        break;
      case OFParameterType.vec2:
        paramWidget = OFStringParameter(param);
        break;
    }

    return Container(
      child: paramWidget,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 0.5),
      )),
    );
  }
}

class ParamContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
