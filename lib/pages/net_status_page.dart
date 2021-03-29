import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
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
  TextEditingController addressController;
  TextEditingController inPortController;
  TextEditingController outPortController;

  Function onData;
  String _selectedInterfaceName;
  List<String> _netIntNames;
  List<NetworkInterface> _netInterfaces;
  Future listFuture;

  StartScreenState() {
    addressController = TextEditingController(text: '0.0.0.0');
    inPortController = TextEditingController();
    outPortController = TextEditingController();
    Wakelock.enable();
  }

  @override
  void initState() {
    super.initState();
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
    addressController.text = netController.serverAddress;
    _selectedInterfaceName = netController.networkInterface.toString();
    inPortController.text = netController.inPort.toString();
    outPortController.text = netController.outPort.toString();
    listFuture = netController.listNetworkInterfaces();

    final appModel = Provider.of<AppModel>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, viewportConstraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
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
                              netController.serverAddress =
                                  addressController.text;
                              appModel.parametersReady = false;
                              FocusScope.of(context).unfocus();
                            },
                            controller: addressController,
                            textAlign: TextAlign.center,
                            style: kLabelStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  AutoSizeText(
                                    "Server Output Port",
                                    textAlign: TextAlign.center,
                                    style: kSubTitle2TextStyle,
                                    maxLines: 1,
                                  ),
                                  AutoSizeTextField(
                                    maxLines: 1,
                                    minFontSize: 8,
                                    onEditingComplete: () {
                                      netController.inPort =
                                          int.parse(inPortController.text);
                                      appModel.parametersReady = false;
                                      FocusScope.of(context).unfocus();
                                    },
                                    controller: inPortController,
                                    textAlign: TextAlign.center,
                                    style: kLabelStyle,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false, signed: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  AutoSizeText(
                                    "Server Input Port",
                                    textAlign: TextAlign.center,
                                    style: kSubTitle2TextStyle,
                                    maxLines: 1,
                                  ),
                                  AutoSizeTextField(
                                    maxLines: 1,
                                    minFontSize: 8,
                                    onEditingComplete: () {
                                      netController.outPort =
                                          int.parse(outPortController.text);
                                      appModel.parametersReady = false;
                                      FocusScope.of(context).unfocus();
                                    },
                                    controller: outPortController,
                                    textAlign: TextAlign.center,
                                    style: kLabelStyle,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false, signed: false),
                                  ),
                                ],
                              ),
                            ),
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
                              future: listFuture,
                              builder:
                                  (BuildContext context, AsyncSnapshot snap) {
                                if (snap.data == null) return Container();
                                List<String> interfaces = snap.data;
                                return DropdownButton<String>(
                                  value: netController.networkInterface.name,
                                  // icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  isExpanded: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _selectedInterfaceName = newValue;
                                      netController.networkInterface =
                                          netController.getNetworkInterface(
                                              name: newValue);
                                      appModel.parametersReady = false;
                                    });
                                  },
                                  items: interfaces
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Center(
                                            child: AutoSizeText(
                                          '$value – ${netController.getNetworkInterface(name: value).addresses[0].address}',
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
                          netController
                              .connect(addressController.text, paramController,
                                  onSuccess: () {
                            appModel.connectPressed = true;
                            appModel.parametersReady = true;
                          });
                        }),
                    // if (Foundation.kDebugMode)
                    //   StyledButton(
                    //       text: "Debug Connect",
                    //       onPressed: () {
                    //         paramController.parse(kXmlTestString2);
                    //         appModel.connectPressed = true;
                    //         appModel.parametersReady = true;
                    //       }),
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
          );
        }),
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
      case NetStatus.ServerNotFound:
      default:
        return Text('Server Not Found');
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
