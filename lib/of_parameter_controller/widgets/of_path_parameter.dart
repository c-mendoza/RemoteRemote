import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:osc_remote/of_parameter_controller/widgets/point_editor.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:xml/xml.dart' as xml;

import '../../constants.dart';
import '../of_parameter_controller.dart';
import '../types.dart';

Logger pathLogger = Logger('PathParameter');

class OFPathParameter extends StatelessWidget {
  final OFParameter<String> param;

  const OFPathParameter(this.param, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: PathEditor(param),
            ),
            appBar: AppBar(title: Text(param.name)),
          );
        }));
      },
      child: Container(
        padding: kListItemPadding,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Text(
                  param.name,
                  style: kLabelStyle,
                )),
            Expanded(
                flex: 2,
                child: Text(
                  'Edit path',
                  style: kActionLabelStyle,
                  textAlign: TextAlign.right,
                )),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.navigate_next,
                      size: kLabelStyle.fontSize * 1.5,
                    )))
          ],
        ),
      ),
    );
  }
}

class PathEditor extends StatefulWidget {
  final OFParameter<String> param;

  PathEditor(this.param);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  List<PathPoint> pathPoints = [];
  Color pathFillColor;
  bool pathIsFilled;
  Color pathStrokeColor;
  double pathStrokeWidth;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    deserialize();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: PageView(
              children: buildPointEditors(pathPoints),
              controller: _pageController,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Text('Swipe for additional path points')),
        ],
      ),
    );
//    return ListView(
//      children: buildPoints(points),
//      shrinkWrap: true,
//    );
  }

  List<Widget> buildPointEditors(List<PathPoint> points) {
    var list = <Widget>[];

    for (var i = 0; i < points.length; i++) {
      var point = points[i];
      if (point.type == PathPointType.close) continue;
      list.add(PathPointEditor(
        pathPoint: point,
        onChange: (pathPoint) {
          setState(() {
            points[pathPoint.index] = pathPoint;
            serialize();
          });
        },
      ));
    }

    return list;
  }

  //TODO!!
  void serialize() {
    var doc = xml.XmlDocument();
    var builder = xml.XmlBuilder();
    builder.element('ofPath', nest: () {
      builder.element('points', nest: () {
        for (var p in pathPoints) {
          builder.element('point', nest: () {
            builder.attribute('type', p.type.index);
            builder.attribute('position', offsetToString(p.position));
            builder.attribute('cp1', offsetToString(p.cp1));
            builder.attribute('cp2', offsetToString(p.cp2));
          });
        }
      });
      builder.element('fill', nest: () {
        builder.attribute('color', OFParameterController.serializeColor(pathFillColor));
        builder.attribute('isFilled', pathIsFilled ? '1' : '0');
      });
      builder.element('stroke', nest: () {
        builder.attribute('color', OFParameterController.serializeColor(pathStrokeColor));
        builder.attribute('strokeWidth', pathStrokeWidth.toString());
      });
    });

    widget.param.value = builder.build().toString();
  }

  String offsetToString(Offset o) {
    if (o == null) {
      return '0, 0, 0';
    } else {
      return '${o.dx.toStringAsFixed(2)}, ${o.dy.toStringAsFixed(2)}, 0';
    }
  }

  void deserialize() {
//    var commands = widget.param.value.split('{');
    xml.XmlDocument doc;
    try {
      doc = xml.parse(widget.param.value);

    } catch (e) {
      pathLogger.severe(
          'Error parsing path xml for the following string:\n ${widget.param.value}');
      return;
    }

    var pointsXml = doc.rootElement.findElements('points').first;

    var pointElements = pointsXml.findElements('point').toList();

    int index = 0;
    // TODO: more error checking in path deserialization
    for (var el in pointElements) {

      var commandTypeIndex = int.parse(el.getAttribute('type'));
      var commandType = typeForInt(commandTypeIndex);
      var pathPoint = PathPoint(index++, commandType);
      switch (commandType) {
        case PathPointType.moveTo:
        case PathPointType.lineTo:
        case PathPointType.curveTo:
          pathPoint.position = offsetFromString(el.getAttribute('position'));
          pathPoint.cp1 = Offset(0, 0);
          pathPoint.cp2 = Offset(0, 0);
          break;
        case PathPointType.bezierTo:
        case PathPointType.quadBezierTo:
          pathPoint.position = offsetFromString(el.getAttribute('position'));
          pathPoint.cp1 = offsetFromString(el.getAttribute('cp1'));
          pathPoint.cp2 = offsetFromString(el.getAttribute('cp2'));
          break;
        case PathPointType.close:
          // Nothing to do for close
          break;
        default:
          pathLogger.warning(
              'Trying to deserialize a Point Type not yet implemented');
          break;
      }

      pathPoints.add(pathPoint);
    }

    var strokeXml = doc.rootElement.findElements('stroke').first;
    pathStrokeColor = OFParameterController.deserializeColor(strokeXml.getAttribute('color'));
    pathStrokeWidth = double.parse(strokeXml.getAttribute('strokeWidth'));

    var fillXml = doc.rootElement.findElements('fill').first;
    pathFillColor = OFParameterController.deserializeColor(fillXml.getAttribute('color'));
    pathIsFilled = fillXml.getAttribute('isFilled') == '1';
  }

  PathPointType typeForInt(int type) {
    var types = [
      PathPointType.moveTo,
      PathPointType.lineTo,
      PathPointType.curveTo,
      PathPointType.bezierTo,
      PathPointType.quadBezierTo,
      PathPointType.arc,
      PathPointType.arcNegative,
      PathPointType.close
    ];
    return types[type];
  }

  Offset offsetFromString(String component) {
    var stringCoords = component.split(',');
    bool error = false;
    if (stringCoords.length != 3) {
      pathLogger.severe(
          'Error deserializing point. Did not find three coordinates. Tried to parse the following:\n$component');
      return Offset(0, 0);
    }

    var x = double.tryParse(stringCoords[0]);
    var y = double.tryParse(stringCoords[1]);

    if (x == null || y == null) {
      pathLogger.severe(
          'Error deserializing point coordinates while trying to parse:\n$component');
      return Offset(0, 0);
    }
    // Ignore z

    return Offset(x, y);
  }
}

class PathPointEditor extends StatelessWidget {
  final PathPoint pathPoint;
  final ValueChanged<PathPoint> onChange;

  const PathPointEditor({Key key, this.pathPoint, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//
//    return PointEditor(
//      point: pathPoint.position,
//      label: 'Position',
//      onChange: (offset) {},
//    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
//                      color: Colors.orange,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Point ${pathPoint.index}',
                          style: Theme.of(context).textTheme.headline,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Align(
                          alignment: Alignment.center,
                          child: buildPointEditorOption())),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: PopupMenuButton(
                        offset: Offset(-10, -150),
                        child: Text(
                          'Point Actions',
                          style: kButtonStyle,
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Add Point'),
                            ),
                          ),
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Text('Convert Point'),
                          ),
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Text('Delete Point'),
                          ),
                        ],
                      ),
                    ),
                  ),
//        SizedBox(
//          height: 40,
//          ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPointEditorOption() {
    var positionPointEditor = PointEditor(
      point: pathPoint.position,
      label: 'Position',
      onChange: (offset) {
        pathPoint.position = offset;
        onChange(pathPoint);
      },
    );

    if (pathPoint.type == PathPointType.bezierTo ||
        pathPoint.type == PathPointType.quadBezierTo) {
      var pointEditors = <Widget>[];
      pointEditors.add(positionPointEditor);
      pointEditors.add(PointEditor(
        point: pathPoint.cp1,
        label: 'Control Point 1',
        onChange: (offset) {
          pathPoint.cp1 = offset;
          onChange(pathPoint);
        },
      ));
      pointEditors.add(PointEditor(
        point: pathPoint.cp2,
        label: 'Control Point 2',
        onChange: (offset) {
          pathPoint.cp2 = offset;
          onChange(pathPoint);
        },
      ));
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 300,
            child: PageIndicatorContainer(
              child: PageView(children: pointEditors),
              length: pointEditors.length,
              indicatorColor: Colors.grey[200],
            ),
          ),
          Text('Swipe for control points'),
        ],
      );
    } else {
      return Container(height: 300, child: positionPointEditor);
    }
  }

  Widget buildConvertOption() {
    switch (pathPoint.type) {
      case PathPointType.moveTo:
      case PathPointType.arc:
      case PathPointType.arcNegative:
      case PathPointType.close:
        return Container();
      case PathPointType.lineTo:
        return FlatButton(
          child: Text(
            'Convert to curve point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
        break;
      case PathPointType.curveTo:
        return FlatButton(
          child: Text(
            'Convert to bezier point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
        break;
      case PathPointType.bezierTo:
        return FlatButton(
          child: Text(
            'Convert to quad bezier point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
        break;
      case PathPointType.quadBezierTo:
        return FlatButton(
          child: Text(
            'Convert to line point',
            style: kButtonStyle,
          ),
          onPressed: () {},
        );
    }
    return Container();
  }
}

enum PathPointType {
  moveTo,
  lineTo,
  curveTo,
  bezierTo,
  quadBezierTo, // Not implemented
  arc, // Not implemented
  arcNegative, // Not implemented
  close
}

class PathPoint {
  Offset position;
  Offset cp1;
  Offset cp2;
  final PathPointType type;
  final int index;

  PathPoint(this.index, this.type);
}
