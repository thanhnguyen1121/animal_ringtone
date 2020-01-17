import 'package:mvp_flutter_tutorial/constance/Constances.dart';
import 'package:mvp_flutter_tutorial/utils/AdsUtils.dart';
import 'package:mvp_flutter_tutorial/utils/CallNative.dart';
import 'package:mvp_flutter_tutorial/utils/intent.dart';

import '../../base/BasePresenter.dart';
import '../../base/BaseView.dart';
import 'Viewmodel.dart';

class Presenter implements BasePresenter {
  ViewModel _viewModel;
  BaseView _view;
  var data;
  var index;

  var key, dataAction;

  Presenter(this.data, this.index) {}

  @override
  action(key, data) {
    this.key = key;
    this.dataAction = data;
    switch (key) {
      case Constances.GOBACK:
        IntentUtils.goBack(dataAction);
        break;
      case Constances.PREVIOUS:
        print("show ads");
        AdsUtils.showInter();
        break;
      case Constances.NEXT:
        print("show ads");
        AdsUtils.showInter();
        break;
      case Constances.PLAY_RINGTONE:
        AdsUtils.showInter();
        break;
      case Constances.PAUSE_RINGTONE:
        print("pause");
        _viewModel.isPlaying = false;
        _view.uiUpdate(_viewModel);
        CallNative.callFluterToNative(Constances.PAUSE_RINGTONE, {
          "data": "pause",
          "index": dataAction["index"],
          "resourceID": dataAction["resourceID"]
        }, (callBack) {
          print("datasakdsjaskldj:" + callBack.toString());
        });
        break;

      case Constances.SET_ALARM_RINGTONE:
        AdsUtils.showInter();
        break;
      case Constances.SET_CONTACT_RINGTONE:
        AdsUtils.showInter();
        break;
      case Constances.SET_NOTIFI_RINGTONE:
        AdsUtils.showInter();
        break;
      case Constances.UPDATE_STATUS:
        _viewModel.isShowDialog = false;
        _view.uiUpdate(_viewModel);
        break;
    }
  }

  click() {
    switch (key) {
      case Constances.ON_PAGE_CHANGE:
        _viewModel.currentIndex = dataAction["index"];
        _view.uiUpdate(_viewModel);
        break;
      case Constances.PREVIOUS:
        _viewModel.currentIndex--;
        print("truocw" + _viewModel.currentIndex.toString());
        _view.uiUpdate(_viewModel);
        break;
      case Constances.NEXT:
        _viewModel.currentIndex++;
        print("sau" + _viewModel.currentIndex.toString());
        _view.uiUpdate(_viewModel);
        break;
      case Constances.PLAY_RINGTONE:
        print("play!");
        _viewModel.isPlaying = true;
        _view.uiUpdate(_viewModel);
        print("datasent:" + dataAction.toString());
        CallNative.callFluterToNative(Constances.PLAY_RINGTONE, {
          "data": "play",
          "index": dataAction["index"],
          "resourceID": dataAction["resourceID"]
        }, (callback) {
          print("callback:" + callback.toString());
        });
        break;

      case Constances.SET_ALARM_RINGTONE:
        print("alarm:" + dataAction.toString());
        CallNative.callFluterToNative(Constances.SET_ALARM_RINGTONE, {
          "fileName": dataAction["fileName"],
          "resourceID": dataAction["resourceID"]
        }, (callBack) {
          _viewModel.data[dataAction["index"]]["isShowOption"] =
              !_viewModel.data[dataAction["index"]]["isShowOption"];
          _viewModel.isShowDialog = true;
          _viewModel.contentDialog = "Set Alarm Success!";
          _view.uiUpdate(_viewModel);
        });
        break;
      case Constances.SET_CONTACT_RINGTONE:
        print("call native set ringtone!");
        CallNative.callFluterToNative(Constances.SET_CONTACT_RINGTONE, {
          "fileName": dataAction["fileName"],
          "resourceID": dataAction["resourceID"]
        }, (callBack) {
          _viewModel.data[dataAction["index"]]["isShowOption"] =
              !_viewModel.data[dataAction["index"]]["isShowOption"];
          _viewModel.isShowDialog = true;
          _viewModel.contentDialog = "Set Contact Ringtone Success!";
          _view.uiUpdate(_viewModel);
        });
        break;

      case Constances.SET_NOTIFI_RINGTONE:
        CallNative.callFluterToNative(Constances.SET_NOTIFI_RINGTONE, {
          "fileName": dataAction["fileName"],
          "resourceID": dataAction["resourceID"]
        }, (callBack) {
          _viewModel.data[dataAction["index"]]["isShowOption"] =
              !_viewModel.data[dataAction["index"]]["isShowOption"];
          _viewModel.isShowDialog = true;
          _viewModel.contentDialog = "Set Notification Success!";
          _view.uiUpdate(_viewModel);
        });
        break;

    }
  }

  @override
  init(view) {
    print("data:" + this.data.toString());
    print("index:" + this.index.toString());
    _viewModel = new ViewModel(data, this.index);
    _viewModel.currentIndex = this.index;
    this._view = view;
    this._view.uiUpdate(this._viewModel);

    AdsUtils.addEventInterADS(() {
      print("DONE ADS");
      this.click();
    });
  }
}
