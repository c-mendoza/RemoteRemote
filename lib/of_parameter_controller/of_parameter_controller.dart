library of_parameter_controller;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
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

class OFParameterParser {
  OFParameterGroup _root;

  OFParameterParser();

  OFParameterGroup parse(String xmlString) {
    var document = xml.parse(xmlString);

    //Basic check, the root element should be type group
    var res = document.rootElement.findElements('type');
    if (res.first.text != getStringForType(OFParameterType.group)) {
      print("Error 1");
      return null;
    }

    _root = OFParameterGroup(
        name: document.rootElement.name.toString(),
        path: '/${document.rootElement.name.toString()}');

    addParameters(_root, document.rootElement);

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

  static Widget BuildParameter(OFBaseParameter param) {
    switch (param.type) {
      case OFParameterType.unknown:
        return OFStringParameter(param);
        break;
      case OFParameterType.integer:
        return OFNumberParameter(param);
        break;
      case OFParameterType.floating:
        return OFNumberParameter(param);
        break;
      case OFParameterType.boolean:
        // TODO: Handle this case.
        break;
      case OFParameterType.color:
        // TODO: Handle this case.
        break;
      case OFParameterType.string:
        // TODO: Handle this case.
        break;
      case OFParameterType.group:
        return OFParameterGroupStub(param);
        break;
      case OFParameterType.vec2:
        // TODO: Handle this case.
        break;
    }
  }

  void addParameters(OFParameterGroup group, xml.XmlElement element) {

    var children = element.findElements('children').first;
    if (children == null) {
      print('Error looking for children in ${group.path}');
      return;
    }

  }
}

class OFParameterGroupView extends StatelessWidget {
  final OFParameterGroup group;

  const OFParameterGroupView({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: ListView(
      children: buildGroupChildren(),
    ));
  }

  List<Widget> buildGroupChildren() {
    var children = <Widget>[];

    for (var child in group.children) {
      children.add(OFParameterParser.BuildParameter(child));
    }

    return children;
  }
}
