import 'dart:convert';
import 'dart:math';

import 'package:mvp_flutter_tutorial/utils/AdsUtils.dart';
import 'package:mvp_flutter_tutorial/utils/CallNative.dart';
import 'package:mvp_flutter_tutorial/utils/PermistionModule.dart';

import '../../base/BasePresenter.dart';
import '../../base/BaseView.dart';
import '../../constance/Constances.dart';
import '../../utils/intent.dart';
import 'Viewmodel.dart';
import '../detail/View.dart';

class Presenter implements BasePresenter {
  ViewModel _viewModel;
  BaseView _view;
  var key, data;
  var showAds = 0;

  Presenter() {
    this.checkPermistion();
  }

  checkPermistion() async {
    bool permistionStorage = await PermistionModule.checkPermistionStogare();
    print("FFSFSF" + permistionStorage.toString());
    if (permistionStorage) {
      CallNative.callFluterToNative(
          Constances.REQUEST_PERMISTION, {"data": "aaaa"}, (callBack) {});
      CallNative.callFluterToNative(Constances.RATE, {"": ""}, (callBack) {});
    }
  }

  click() {
    switch (key) {
      case Constances.CLICK_ITEM:
        print("click item!");
        var fileName = this.data["data"]["fileName"].toString().split("_");
        var name = fileName[fileName.length-1];
        IntentUtils.startActivity(data["context"], View(_viewModel.data, data["index"],name));
        break;
      case Constances.PLAY_RINGTONE:
        print("play!");
        showAds = 1;
        _viewModel.data = _viewModel.data.map((element) {
          return {...element, "isPlaying": false};
        }).toList();

        _viewModel.data[data["index"]]["isPlaying"] = true;
        _view.uiUpdate(_viewModel);
        print("datasent:" + data.toString());
        CallNative.callFluterToNative(Constances.PLAY_RINGTONE, {
          "data": "play",
          "index": data["index"],
          "resourceID": data["resourceID"]
        }, (callback) {
          print("callback:" + callback.toString());
        });

        break;
      case Constances.PAUSE_RINGTONE:
        print("pause");
        showAds = 1;
        CallNative.callFluterToNative(Constances.PAUSE_RINGTONE, {
          "data": "pause",
          "index": data["index"],
          "resourceID": data["resourceID"]
        }, (callBack) {
          print("datasakdsjaskldj:" + callBack.toString());
        });
        _viewModel.data[data["index"]]["isPlaying"] = false;
        _view.uiUpdate(_viewModel);

        break;

      case Constances.SHOW_OPTION:
        _viewModel.data[data["index"]]["isShowOption"] =
            !_viewModel.data[data["index"]]["isShowOption"];
        _view.uiUpdate(_viewModel);
        break;

      case Constances.SET_ALARM_RINGTONE:
        CallNative.callFluterToNative(Constances.SET_ALARM_RINGTONE, {
          "fileName": data["fileName"],
          "resourceID": data["resourceID"]
        }, (callBack) {
          _viewModel.data[data["index"]]["isShowOption"] =
              !_viewModel.data[data["index"]]["isShowOption"];
          _viewModel.isShowDialog = true;
          _viewModel.contentDialog = "Set Alarm Success!";
          _view.uiUpdate(_viewModel);
        });
        break;
      case Constances.SET_CONTACT_RINGTONE:
        print("call native set ringtone!");
        CallNative.callFluterToNative(Constances.SET_CONTACT_RINGTONE, {
          "fileName": data["fileName"],
          "resourceID": data["resourceID"]
        }, (callBack) {
          _viewModel.data[data["index"]]["isShowOption"] =
              !_viewModel.data[data["index"]]["isShowOption"];
          _viewModel.isShowDialog = true;
          _viewModel.contentDialog = "Set Contact Ringtone Success!";
          _view.uiUpdate(_viewModel);
        });   
        break;

      case Constances.SET_NOTIFI_RINGTONE:
        CallNative.callFluterToNative(Constances.SET_NOTIFI_RINGTONE, {
          "fileName": data["fileName"],
          "resourceID": data["resourceID"]
        }, (callBack) {
          _viewModel.data[data["index"]]["isShowOption"] =
              !_viewModel.data[data["index"]]["isShowOption"];
          _viewModel.isShowDialog = true;
          _viewModel.contentDialog = "Set Notification Success!";
          _view.uiUpdate(_viewModel);
        });
        break;
      case Constances.UPDATE_STATUS:
        _viewModel.isShowDialog = false;
        break;
    }
  }

  @override
  action(key, data) {
    this.data = data;
    this.key = key;
    AdsUtils.showInter();
  }

  @override
  init(view) {
    CallNative.callFluterToNative(
        Constances.GET_ALL_FILE_NAME_IN_RAW, {"data": "hihi"}, (callBack) {
      print("dataaaaa:" + callBack.toString());
      var data = jsonDecode(callBack.toString());
      _viewModel = new ViewModel(data);
      this._view = view;
      this._view.uiUpdate(this._viewModel);
    });
    AdsUtils.addEventInterADS(() {
      print("DONE ADS");
      this.click();
    });
  }
}
