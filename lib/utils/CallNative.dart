import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mvp_flutter_tutorial/constance/Constances.dart';

class CallNative {
  static const platform = const MethodChannel(Constances.CALL_FLUTTER_NATIVE);
  static const stream = const EventChannel(Constances.CALL_NATIVE_FLUTTER);
  static StreamSubscription _streamSubscription;

  static callFluterToNative(method, data, callBack) async {
    final String result = await platform.invokeMethod(method, data);
    callBack(result);
  }

  static receiveBroadcastStream(callBack) {
    if (_streamSubscription == null) {
      _streamSubscription = stream.receiveBroadcastStream().listen((data) {
        callBack(data);
      });
    }
  }

  static removeBroadcastStream() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
  }
}
