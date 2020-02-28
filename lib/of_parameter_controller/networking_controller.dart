import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:osc/osc.dart';
import 'package:osc_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:osc_remote/of_parameter_controller/types.dart';
import 'package:wifi/wifi.dart';

const String kApiRootString = '/mtafMethod';
const String kApiResponseString = '/mtafResponse';

class NetReply {
  final String methodName;
  final Future<String> reply;

  NetReply(this.methodName, this.reply);
}

enum NetStatus {
  Connected,
  Disconnected,
  ConnectionError,
  Waiting,
  ParserError,
}

class NetworkingController with ChangeNotifier {
  // Networking

  String _hostAddress = "192.168.1.8";
  String _localIpAddress;
  OSCSocket _osc;
  int _outPort = 12000;
  int _inPort = 12001;

  bool _isConnected = false;

  Function _onConnectionSuccess;

  bool get isConnected => _isConnected;

  OFParameterController _parameterController;

  set isConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  NetStatus _status = NetStatus.Disconnected;
  NetStatus _lastStatus = NetStatus.Disconnected;

  Logger log = Logger('NetCont');

  List<NetReply> replyRequests = [];

  NetworkingController({int inputPort = 12001, int outputPort = 12000}) {
    _inPort = inputPort;
    _outPort = outputPort;
  }

//  void setup(
//      {@required String hostAddress,
//      int inputPort = 12001,
//      int outputPort = 12000}) {
//    _setupOsc();
//  }

  Future<bool> _setupOsc() async {
    _localIpAddress = await Wifi.ip;
    _osc?.close();
    var hostIa;
    var localIa;

    try {
      hostIa = InternetAddress(_hostAddress);
      localIa = InternetAddress(_localIpAddress);
    } catch (e) {
      var ae = e as ArgumentError;
      log.severe('${ae.message}. While trying to parse: ${ae.invalidValue}');
      return false;
    }

    _osc = OSCSocket(
        destination: hostIa,
        destinationPort: _outPort,
        serverPort: _inPort,
        serverAddress: localIa);

    await _osc.listen(this.oscListener);
    return true;
  }

  void oscListener(OSCMessage m) {
    String response = m.address;

    if (!response.startsWith(kApiResponseString)) {
      log.info('Received non-api response');
      return;
    }

    log.fine('Response: ${m.toString()}');
    var pathComponents = response.split('/');

    switch (pathComponents[2]) {
      case 'connect':
        _callMethod('getModel', [localIpAddress]);
        break;
      case 'getModel':
        var res = _parameterController.parse(m.arguments[0]);
        if(res) {
          status = NetStatus.Connected;
          _onConnectionSuccess();
        } else {
          status = NetStatus.ParserError;
        }
    }
  }

  Future<void> connect(String host, OFParameterController controller, {Function onSuccess}) async {
    _hostAddress = host;
    _parameterController = controller;
    _onConnectionSuccess = onSuccess;
    _parameterController.netController = this;

    await _setupOsc();
    _callMethod('connect', [localIpAddress]);
  }

  Future<void> _callMethod(String methodName, [List arguments]) async {
    if (arguments == null) arguments = [0];
    var m = OSCMessage('$kApiRootString/$methodName', arguments: arguments);
    status = NetStatus.Waiting;
    try {
      var code = await _osc.send(m);
      if (code == 0) {
        log.warning('Sent 0 bytes for message: ${m.address}');
      }
    } catch(e) {
      status = NetStatus.ConnectionError;
    }
  }
//
//  Future<void> sendParameter(OFParameter param) {
//    return _callMethod('set', [param.path, param.toString()]);
//  }

  Future<void> sendParameter(String path, String value) {
    return _callMethod('set', [path, value]);
  }

  String get hostAddress => _hostAddress;

  set hostAddress(String value) {
    _hostAddress = value;
    _setupOsc();
  }

  String get localIpAddress => _localIpAddress;

  set localIpAddress(String value) {
    _localIpAddress = value;
    _setupOsc();
  }

  int get outPort => _outPort;

  set outPort(int value) {
    _outPort = value;
    _setupOsc();
  }

  int get inPort => _inPort;

  set inPort(int value) {
    _inPort = value;
    _setupOsc();
  }

  NetStatus get status => _status;

  set status(NetStatus value) {
    _lastStatus = _status;
    _status = value;
    notifyListeners();
  }
}
