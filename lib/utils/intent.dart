import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntentUtils {
  static startActivity(context, compoment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => compoment,
      ),
    );
  }

  static startActivityForResult(context, compoment, callBack) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => compoment));

    if (results != null) {
      callBack(results);
    }
  }

  static goBack(data) {
    Navigator.of(data['context']).pop(data['data']);
  }
}
