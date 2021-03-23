import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:osc/osc.dart';
import 'package:remote_remote/of_parameter_controller/of_parameter_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

const String kApiRootString = '/ofxrpMethod';
const String kApiResponseString = '/ofxrpResponse';

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
  NoNetworkInterface,
  ServerNotFound,
}

class NetworkingController with ChangeNotifier {
  // Networking

  String _serverAddress = '192.168.0.1';
  NetworkInterface _networkInterface;
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

  List<String> _netIntNames = [];
  List<NetworkInterface> _netInterfaces = [];
  Future<List<NetworkInterface>> _interfacesFuture;

  NetworkingController(NetworkInterface interface, {int inputPort = 12001, int outputPort = 12000}) {
    _inPort = inputPort;
    _outPort = outputPort;
    _networkInterface = interface;
    SharedPreferences.getInstance().then((prefs) {
      var lastAddress = prefs.getString(kPrefLastServerAddressKey);
      if (lastAddress != null) {
        serverAddress = lastAddress;
      }

      var netInterfaceName = prefs.getString(kPrefNetInterfaceKey);
      if (netInterfaceName != null) {
        NetworkInterface.list(
                type: InternetAddressType.IPv4,
                includeLoopback: false,
                includeLinkLocal: true)
            .then((interfaces) {
          if (interfaces.isEmpty) {
            status = NetStatus.NoNetworkInterface;
            return;
          }
          try {
            var interface = interfaces
                .firstWhere((element) => element.name == netInterfaceName);
            networkInterface = interface;
          } catch (e) {
            log.warning('Did not find network interface: $netInterfaceName');
          }
        });
      }
    });

    _interfacesFuture = NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
        includeLinkLocal: true);
  }

  Future<List<String>> listNetworkInterfaces() {
    var completer = Completer<List<String>>();
    _interfacesFuture.then((value) {
      _netInterfaces = value;
      _netIntNames = [];
      for (var i in _netInterfaces) {
        _netIntNames.add(i.name);
      }
      completer.complete(_netIntNames);
    });

    return completer.future;
  }

  NetworkInterface getNetworkInterface({String name}) {
    return _netInterfaces.firstWhere((element) => element.name == name);
  }

  Future<bool> _setupOsc() async {
    _osc?.close();
    var hostIa;
    var localIa;
    try {
      var results = await InternetAddress.lookup(_serverAddress,
          type: InternetAddressType.IPv4);
      for (var r in results) {
        if (r.type == InternetAddressType.IPv4) {
          log.fine('Resolved address to: ${r.address}');
          hostIa = InternetAddress(r.address);
        }
      }

      _osc = OSCSocket(
          destination: hostIa,
          destinationPort: _outPort,
          serverPort: _inPort,
          serverAddress: localIa);

      await _osc.listen(this.oscListener);

      return true;
    } catch (error) {
      log.warning(error);
      status = NetStatus.ServerNotFound;
      return false;
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  /// Handle responses from the server
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
        callMethod('getModel', [_networkInterface.addresses[0].address]);
        break;
      case 'getModel':
        var res = _parameterController.parse(m.arguments[0]);
        if (res) {
          status = NetStatus.Connected;
          _onConnectionSuccess?.call();
          _onConnectionSuccess = null;
        } else {
          status = NetStatus.ParserError;
        }
        break;
      case 'revert':
        if (m.arguments[0] == 'OK') {
          callMethod('getModel', [_networkInterface.addresses[0].address]);
        }
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  Future<void> connect(String host, OFParameterController controller,
      {Function onSuccess}) async {
    _serverAddress = host;
    _parameterController = controller;
    _onConnectionSuccess = onSuccess;
//    _parameterController.netController = this;
    status = NetStatus.Waiting;
    if (await _setupOsc()) {
      callMethod('connect', [_networkInterface.addresses[0].address]);
    } else {
      log.severe('Error setting up OSC');
    }
  }

  Future<void> callMethod(String methodName, [List arguments]) async {
    if (arguments == null) arguments = [0];
    var m = OSCMessage('$kApiRootString/$methodName', arguments: arguments);
    try {
      var code = await _osc.send(m);
      if (code == 0) {
        log.warning('Sent 0 bytes for message: ${m.address}');
      }
    } catch (e) {
      status = NetStatus.ConnectionError;
    }
  }

//
//  Future<void> sendParameter(OFParameter param) {
//    return _callMethod('set', [param.path, param.toString()]);
//  }

  Future<void> sendParameter(String path, String value) {
    return callMethod('set', [path, value]);
  }

  Future<void> callSave() {
    return callMethod('save', ['']);
  }

  Future<void> callRevert() {
    return callMethod('revert', ['']);
  }

  String get serverAddress => _serverAddress;

  set serverAddress(String value) {
    _serverAddress = value;
    status = NetStatus.Disconnected;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString(kPrefLastServerAddressKey, value));
    // _setupOsc();
  }

  set networkInterface(NetworkInterface ni) {
    _networkInterface = ni;
    status = NetStatus.Disconnected;
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setString(kPrefNetInterfaceKey, _networkInterface.name));
    // _setupOsc();
  }

  get networkInterface => _networkInterface;

  int get outPort => _outPort;

  set outPort(int value) {
    _outPort = value;
    status = NetStatus.Disconnected;
  }

  int get inPort => _inPort;

  set inPort(int value) {
    _inPort = value;
    status = NetStatus.Disconnected;
  }

  NetStatus get status => _status;

  set status(NetStatus value) {
    _lastStatus = _status;
    _status = value;
    notifyListeners();
  }
}
