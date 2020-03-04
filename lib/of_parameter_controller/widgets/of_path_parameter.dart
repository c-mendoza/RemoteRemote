import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:osc_remote/of_parameter_controller/widgets/point_editor.dart';
import 'package:page_indicator/page_indicator.dart';

import '../../constants.dart';
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
  List<PathPoint> points = [];
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    deserialize();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: PageView(
            children: buildPoints(points),
            controller: _pageController,
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Text('Swipe for additional path points')),
      ],
    );
//    return ListView(
//      children: buildPoints(points),
//      shrinkWrap: true,
//    );
  }

  List<Widget> buildPoints(List<PathPoint> points) {
    var list = <Widget>[];

    for (var i = 0; i < points.length; i++) {
      var point = points[i];
      if (point.type == PathPointType.close) continue;
      list.add(PathPointEditor(
        pathPoint: point,
        pointIndex: i,
      ));
    }

    return list;
  }

  void deserialize() {
    var commands = widget.param.value.split('{');

    // TODO: more error checking in path deserialization
    for (var command in commands) {
      if (command.length < 1) continue;
      var pathPoint = PathPoint();
      var pathComponents = command.split(';');

      var commandTypeIndex = int.parse(pathComponents[0]);
      var commandType = typeForInt(commandTypeIndex);

      pathPoint.type = commandType;
      switch (commandType) {
        case PathPointType.moveTo:
        case PathPointType.lineTo:
        case PathPointType.curveTo:
          pathPoint.position = offsetFromString(pathComponents[1]);
          pathPoint.cp1 = Offset(0, 0);
          pathPoint.cp2 = Offset(0, 0);
          break;
        case PathPointType.bezierTo:
        case PathPointType.quadBezierTo:
          pathPoint.position = offsetFromString(pathComponents[1]);
          pathPoint.cp1 = offsetFromString(pathComponents[2]);
          pathPoint.cp2 = offsetFromString(pathComponents[3]);
          break;
        case PathPointType.close:
          // Nothing to do for close
          break;
        default:
          pathLogger.warning(
              'Trying to deserialize a Point Type not yet implemented');
          break;
      }

      points.add(pathPoint);
    }
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
  final int pointIndex;

  const PathPointEditor({Key key, this.pathPoint, this.pointIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//
//    return PointEditor(
//      point: pathPoint.position,
//      label: 'Position',
//      onChange: (offset) {},
//    );
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'Point $pointIndex',
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            buildPointEditorOption(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: PopupMenuButton(
                  child: Text('Point Actions', style: kButtonStyle,),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
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
    );
  }

  Widget buildPointEditorOption() {
    var positionPointEditor = PointEditor(
      point: pathPoint.position,
      label: 'Position',
      onChange: (offset) {},
    );

    if (pathPoint.type == PathPointType.bezierTo ||
        pathPoint.type == PathPointType.quadBezierTo) {
      var pointEditors = <Widget>[];
      pointEditors.add(positionPointEditor);
      pointEditors.add(PointEditor(
        point: pathPoint.cp1,
        label: 'Control Point 1',
        onChange: (offset) {},
      ));
      pointEditors.add(PointEditor(
        point: pathPoint.cp2,
        label: 'Control Point 2',
        onChange: (offset) {},
      ));
      return Column(
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
      return positionPointEditor;
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
  PathPointType type;
}
