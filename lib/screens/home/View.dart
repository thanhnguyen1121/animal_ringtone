import 'package:flutter/material.dart';

import '../../base/BasePresenter.dart';
import '../../base/BaseView.dart';
import '../../constance/Constances.dart';
import '../../locales/i18n.dart';
import 'Viewmodel.dart';
import 'Presenter.dart';

class View extends StatefulWidget {
  String title;

  View(this.title);

  @override
  _ViewState createState() => new _ViewState();
}

class _ViewState extends State<View>
    with SingleTickerProviderStateMixin
    implements BaseView {
  ViewModel _viewModel;
  BasePresenter _presenter;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    _presenter = new Presenter();
    _presenter.init(this);
    tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: _viewModel != null
          ? Container(
              color: Colors.black87,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _buildTabContent(_viewModel.data),
                  )
                ],
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment(0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            ),
    );
  }

  _buildTabContent(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildItem(data[index], index);
        });
  }

  _buildItem(data, index) {
    return GestureDetector(
      onTap: () {
        _presenter
            .action(Constances.CLICK_ITEM, {"context": context, "data": data, "index":index});
      },
      child: Container(
          margin: EdgeInsets.all(8.0),
          width: double.infinity,
          height: 150.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(data["icon"]), fit: BoxFit.cover),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              )),
          child: Column(
            children: <Widget>[
//              Expanded(
//                flex: 1,
//                child: Row(
////                  crossAxisAlignment: CrossAxisAlignment.end,
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//
//                    !data["isShowOption"]
//                        ? IconButton(
//                            icon: Icon(
//                              Icons.notifications_active,
//                              size: 28,
//                              color: Colors.white,
//                            ),
//                            onPressed: () {
//                              _presenter.action(Constances.SHOW_OPTION, {
//                                "index": index,
//                                "context": context,
//                                "resourceID": data["resourceID"],
//                                "fileName": data["fileName"]
//                              });
//                            })
//                        : IconButton(
//                            icon: Icon(
//                              Icons.notifications_active,
//                              size: 28,
//                              color: Colors.white,
//                            ),
//                            onPressed: () {
//                              _presenter.action(Constances.SHOW_OPTION, {
//                                "index": index,
//                                "context": context,
//                                "resourceID": data["resourceID"],
//                                "fileName":data["fileName"]
//                              });
//                            })
//                  ],
//                ),
//              ),
//              Expanded(
//                  flex: 2,
//                  child: !_viewModel.data[index]["isShowOption"]
//                      ? data["isPlaying"]
//                          ? GestureDetector(
//                              onTap: () {
//                                _presenter.action(Constances.PAUSE_RINGTONE, {
//                                  "index": index,
//                                  "context": context,
//                                  "resourceID": data["resourceID"]
//                                });
//                              },
//                              child: Icon(
//                                Icons.pause_circle_outline,
//                                size: 80,
//                                color: Colors.white,
//                              ))
//                          : GestureDetector(
//                              onTap: () {
//                                _presenter.action(
//                                    Constances.PLAY_RINGTONE, {
//                                  "index": index,
//                                  "context": context,
//                                  "resourceID": data["resourceID"]
//                                });
//                              },
//                              child: Icon(
//                                Icons.play_circle_outline,
//                                size: 80,
//                                color: Colors.white,
//                              ))
//                      : Padding(
//                          padding:
//                              const EdgeInsets.only(left: 40.0, right: 40.0),
//                          child: Card(
//                            clipBehavior: Clip.antiAlias,
//                            elevation: 3.0,
//                            child: Container(
//                              color: Colors.black54,
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Padding(
//                                    padding: const EdgeInsets.only(left: 8.0),
//                                    child: IconButton(
//                                      icon: Icon(
//                                        Icons.notifications_active,
//                                        size: 36,
//                                        color: Colors.white,
//                                      ),
//                                      onPressed: () {
//                                        _presenter.action(
//                                            Constances.SET_NOTIFI_RINGTONE, {
//                                          "index": index,
//                                          "context": context,
//                                          "resourceID": data["resourceID"],
//                                          "fileName": data["fileName"],
//                                        });
//                                      },
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.only(
//                                        left: 8.0, right: 8.0),
//                                    child: IconButton(
//                                      icon: Icon(
//                                        Icons.contact_phone,
//                                        size: 36,
//                                        color: Colors.white,
//                                      ),
//                                      onPressed: () {
//                                        print("set ringtone!");
//                                        _presenter.action(
//                                            Constances.SET_CONTACT_RINGTONE, {
//                                          "index": index,
//                                          "context": context,
//                                          "resourceID": data["resourceID"],
//                                          "fileName": data["fileName"],
//                                        });
//                                      },
//                                    ),
//                                  ),
//
//                                  Padding(
//                                    padding: const EdgeInsets.only(right: 8.0),
//                                    child: IconButton(
//                                      icon: Icon(
//                                        Icons.alarm,
//                                        size: 36,
//                                        color: Colors.white,
//                                      ),
//                                      onPressed: () {
//                                        _presenter.action(
//                                            Constances.SET_ALARM_RINGTONE, {
//                                          "index": index,
//                                          "context": context,
//                                          "resourceID": data["resourceID"],
//                                          "fileName": data["fileName"],
//                                        });
//                                      },
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        )),
//              Expanded(
//                flex: 1,
////                child: Row(
////                  mainAxisAlignment: MainAxisAlignment.center,
////                  children: <Widget>[
////                    Text(
////                      "Title",
////                      style: TextStyle(color: Colors.white),
////                    )
////                  ],
////                ),
//                child: Container(
//                  width: double.infinity,
//                  height: double.infinity,
//                  child: Stack(
//                    children: <Widget>[
////                    Image.asset("lib/assets/images/giphy.gif", width:100, height: double.infinity,),
//                      data["isPlaying"]
//                          ? Image.asset(
//                              "lib/assets/images/giphy.gif",
//                              width: double.maxFinite,
//                              height: double.infinity,
//                              fit: BoxFit.fill,
//                            )
//                          : SizedBox.shrink(),
////                      Center(
////                          child: Text(
////                        "title",
////                        style: TextStyle(
////                            color: Colors.white,
////                            fontSize: 20.0,
////                            fontWeight: FontWeight.bold),
////                      )),
//                    ],
//                  ),
//                ),
//              )
            ],
          )),
    );
  }

  @override
  uiUpdate(viewModel) {
    setState(() {
      this._viewModel = viewModel;
      if(_viewModel.isShowDialog){
        _buildDialog(_viewModel.contentDialog);
      }

    });
  }

  _buildDialog(content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              height:150,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                    child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Text(
                              content,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            _presenter.action(Constances.UPDATE_STATUS, {});
                            Navigator.of(context).pop();
                          },
                          child: Text("OK")),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildOptionDialog(content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              height:150,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                    child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Set Alram Ringtones"),
                            Text("Set Notification Ringtone"),
                            Text("Set Notification Ringtone"),
                          ],
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            _presenter.action(Constances.UPDATE_STATUS, {});
                            Navigator.of(context).pop();
                          },
                          child: Text("OK")),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
