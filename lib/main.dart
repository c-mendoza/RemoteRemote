import 'dart:io';

import 'package:flutter/material.dart';
import 'package:osc/osc.dart';
import 'package:get_ip/get_ip.dart';
import 'package:osc_remote/constants.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wifi/wifi.dart';



void main() => runApp(ParameterEditor());

class ParameterEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StartScreenState();
  }
}

class StartScreenState extends State<StartScreen> {
  String hostAddress = "192.168.1.8";
  String localIpAddress;
  OSCSocket osc;
  int outPort = 12000;
  int inPort = 12001;

  TextEditingController controller;
  Function onData;
  OFParameterController _parameterController;

  StartScreenState() {
    controller = TextEditingController(text: hostAddress);
    Wakelock.enable();
//    OFParameterParser()
    _parameterController = OFParameterController();
    _parameterController.parse(kXmlTestString2);


  }

  @override
  void reassemble() {
    super.reassemble();
    _parameterController.parse(kXmlTestString2);
  }

  void setupOsc() async {
    localIpAddress = await Wifi.ip;
    var ia = InternetAddress(localIpAddress);
    var res = await InternetAddress.lookup("localhost", type: InternetAddressType.IPv4);

    osc?.close();

    osc = OSCSocket(
        destination: InternetAddress(hostAddress),
        destinationPort: outPort,
        serverPort: inPort,
        serverAddress: InternetAddress(localIpAddress));

    onData = (OSCMessage m) {
      print(m);
    };

    var m = OSCMessage("/bla", arguments: [0]);
    onData(m);
    await osc.listen(onData);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Remote Host", textAlign: TextAlign.left,),
                    TextField(
                      onChanged: (String s) {
                        hostAddress = s;
                      },
                      controller: controller,
                    ),
                  ],
                ),
                FlatButton(
                  child: Text("Connect"),
                  onPressed: () async {
                    // Connect to OSC
                    await setupOsc();

                    var m = OSCMessage("/mtafMethod/connect",
                        arguments: [localIpAddress]);
                    osc.send(m);
                  },
                ),
                FlatButton(
                  child: Text("Get Model"),
                  onPressed: () {
                    if (osc == null) return;
                    var m = OSCMessage("/mtafMethod/getModel", arguments: [DateTime.now().toIso8601String()]);
                    osc.send(m);
                  },
                ),
                BottomButton(label: 'Done', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (
                        context) =>
                        OFParameterGroupView(group: _parameterController.getParameterGroup(),)
                      )
                    );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final String label;
  final Function onTap;
  const BottomButton({
                       Key key, @required this.label, @required this.onTap,
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
