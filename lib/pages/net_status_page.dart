import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remote_remote/app_model.dart';
import 'package:remote_remote/of_parameter_controller/networking_controller.dart';
import 'package:remote_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:remote_remote/widgets/styled_button.dart';
import 'package:provider/provider.dart';
import 'package:remote_remote/of_parameter_controller/types.dart';
import 'package:remote_remote/of_parameter_controller/widgets/of_group_view.dart';
import 'package:remote_remote/constants.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/foundation.dart' as Foundation;

class NetStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StartScreen();
  }
}

class StartScreen extends StatefulWidget {
  StartScreen();

  @override
  State<StatefulWidget> createState() {
    return StartScreenState();
  }
}

class StartScreenState extends State<StartScreen> {
  TextEditingController controller;
  Function onData;

  StartScreenState() {
    controller = TextEditingController(text: '0.0.0.0');
    Wakelock.enable();

//    widget.parameterController.parse(kXmlTestString2);
  }

  @override
  void reassemble() {
    super.reassemble();
//    widget.parameterController.parse(kXmlTestString2);
  }

  @override
  Widget build(BuildContext context) {
    final paramController =
    Provider.of<OFParameterController>(context, listen: false);
    final netController =
    Provider.of<NetworkingController>(context, listen: false);
    controller.text = netController.hostAddress;
    final appModel = Provider.of<AppModel>(context, listen: false);
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Remote Host",
                      textAlign: TextAlign.center,
                      style: kSubTitleTextStyle,
                    ),
                    TextField(
                      onEditingComplete: () {
                        netController.hostAddress = controller.text;
                      },
                      controller: controller,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                StyledButton(
                  text: "Connect",
                  onPressed: () {
                    // Connect to OSC
                    netController.connect(controller.text, paramController,
                      onSuccess: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => Launcher(rootGroup: paramController.group)));
//                      });
                        appModel.connectPressed = true;
                        appModel.parametersReady = true;
                      });
                  }),
                StyledButton(
                  text: "Debug Connect",
                  onPressed: () {
                    paramController.parse(kXmlTestString2);
                    appModel.connectPressed = true;
                    appModel.parametersReady = true;
                  }),
                Consumer<NetworkingController>(
                  builder: (context, nc, _) {
                    return StatusDisplay(
                      status: nc.status,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Launcher extends StatelessWidget {
  final OFParameterGroup rootGroup;

  const Launcher({Key key, this.rootGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    return Consumer<OFParameterController>(builder: (context, paramController, __) {
    return OFParameterGroupView('/');
//    });
  }
}

class StatusDisplay extends StatelessWidget {
  final NetStatus status;

  const StatusDisplay({Key key, @required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case NetStatus.Connected:
        final paramController =
        Provider.of<OFParameterController>(context, listen: false);
//        Future.microtask(() => Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => OFParameterGroupView(paramController.group))));
        return FlatButton(
          child: Text('Do it'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  Launcher(rootGroup: paramController.group)));
          },
        );

      case NetStatus.Disconnected:
        return Text('Disconnected');
        break;
      case NetStatus.ConnectionError:
        return Text('Connection Error');
        break;
      case NetStatus.Waiting:
        return SpinKitDualRing(
          color: Theme.of(context).primaryColor,
          size: 28,
        );
        break;
      case NetStatus.ParserError:
        return Text('Parser Error');
        break;
    }
    return Container();
  }
}

class BottomButton extends StatelessWidget {
  final String label;
  final Function onTap;

  const BottomButton({
    Key key,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(bottom: 20.0),
        color: Colors.blueGrey,
        width: double.infinity,
        height: 30,
        child: Center(
          child: Text(
            label,
            style: kLargeButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
