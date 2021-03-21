import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remote_remote/app_model.dart';
import 'package:remote_remote/of_parameter_controller/networking_controller.dart';
import 'package:remote_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:remote_remote/widgets/styled_button.dart';
import 'package:provider/provider.dart';
import 'package:remote_remote/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/foundation.dart' as Foundation;

import '../debug_constants.dart';

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
  Future netInterfaceFuture;
  NetworkInterface _selectedInterface;

  StartScreenState() {
    controller = TextEditingController(text: '0.0.0.0');
    Wakelock.enable();
//    widget.parameterController.parse(kXmlTestString2);
  }

  @override
  void initState() {
    super.initState();
    Future.value()
    netInterfaceFuture = NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
        includeLinkLocal: true);
  }

  @override
  void reassemble() {
    super.reassemble();
//    widget.parameterController.parse(kXmlTestString2);
  }

  @override
  Widget build(BuildContext context) {
    // String dropdownValue = 'One';

    final paramController =
        Provider.of<OFParameterController>(context, listen: false);
    final netController =
        Provider.of<NetworkingController>(context, listen: false);
    controller.text = netController.serverAddress;
    _selectedInterface = netController.networkInterface;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Server Address",
                        textAlign: TextAlign.center,
                        style: kSubTitle2TextStyle,
                      ),
                      AutoSizeTextField(
                        maxLines: 1,
                        minFontSize: 8,
                        onEditingComplete: () {
                          netController.serverAddress = controller.text;
                        },
                        controller: controller,
                        textAlign: TextAlign.center,
                        style: kLabelStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Network Interface",
                          textAlign: TextAlign.center,
                          style: kSubTitle2TextStyle,
                        ),
                      ),
                      FutureBuilder(
                          future: netInterfaceFuture,
                          builder: (BuildContext context, AsyncSnapshot snap) {
                            if (snap.data == null) return Container();
                            List<NetworkInterface> interfaces = snap.data;
                            // if (netController.networkInterface == null &&
                            //     interfaces.isNotEmpty) {
                            //   netController.networkInterface = interfaces[0];
                            // }
                            return DropdownButton<NetworkInterface>(
                              value: _selectedInterface,
                              // icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              // underline: null,
                              // isDense: ,
                              isExpanded: true,
                              // style: const TextStyle(color: Colors.deepPurple),
                              // underline: Padding(
                              //   padding: const EdgeInsets.only(top: 18),
                              //   child: Container(
                              //     height: 10,
                              //     color: Theme.of(context).accentColor,
                              //   ),
                              // ),
                              onChanged: (NetworkInterface newValue) {
                                setState(() {
                                  _selectedInterface = newValue;
                                  netController.networkInterface = newValue;
                                });
                              },
                              items: interfaces
                                  .map<DropdownMenuItem<NetworkInterface>>(
                                      (NetworkInterface value) {
                                return DropdownMenuItem<NetworkInterface>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Center(
                                        child: AutoSizeText(
                                      '${value.name} – ${value.addresses[0].address}',
                                      maxLines: 1,
                                      maxFontSize: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .fontSize,
                                      minFontSize: 8,
                                      style: kLabelStyle,
                                    )),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                    ],
                  ),
                ),
                SizedBox(width: double.infinity, height: 12),
                StyledButton(
                    text: "Connect",
                    onPressed: () {
                      appModel.parametersReady = false;
                      appModel.connectPressed = false;
                      // Connect to OSC
                      netController.connect(controller.text, paramController,
                          onSuccess: () {
                        appModel.connectPressed = true;
                        appModel.parametersReady = true;
                      });
                    }),
                if (Foundation.kDebugMode)
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

class StatusDisplay extends StatelessWidget {
  final NetStatus status;

  const StatusDisplay({Key key, @required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: statusBuilder(context),
      ),
    );
  }

  Widget statusBuilder(BuildContext context) {
    switch (status) {
      case NetStatus.Connected:
        return Text('Connected');
        break;
      case NetStatus.Disconnected:
        return Text('Disconnected');
        break;
      case NetStatus.ConnectionError:
        return Text('Connection Error');
        break;
      case NetStatus.Waiting:
        return SpinKitDualRing(
          color: Theme.of(context).accentColor,
          size: 28,
        );
        break;
      case NetStatus.ParserError:
        return Text('Parser Error');
        break;
      default:
        return Text('Disconnected');
        break;
    }
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
