import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../base/BasePresenter.dart';
import '../../base/BaseView.dart';
import '../../constance/Constances.dart';
import '../../locales/i18n.dart';
import 'Viewmodel.dart';
import 'Presenter.dart';

class View extends StatefulWidget {
  var data;
  var index;
  var title;

  View(this.data, this.index, this.title);

  @override
  _ViewState createState() => new _ViewState();
}

class _ViewState extends State<View> implements BaseView {
  ViewModel _viewModel;
  BasePresenter _presenter;
  var titlezzz;
  @override
  void initState() {
    super.initState();
    titlezzz = this.widget.title;
    _presenter = new Presenter(this.widget.data, this.widget.index);
    _presenter.init(this);
  }

  @override
  Widget build(BuildContext context) {

    final slider = CarouselSlider(
      height: 400,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: this._viewModel.currentIndex,
      enableInfiniteScroll: true,
      reverse: false,
      enlargeCenterPage: true,
      onPageChanged: (index) {
//        _presenter.action(Constances.ON_PAGE_CHANGE, {"context":context, "index":index});
        _viewModel.currentIndex = index;
        var fileName =
            _viewModel.data[_viewModel.currentIndex]["icon"].split("/");
        var fileName1 = fileName[fileName.length - 1].toString().split(".");
        var fileNameAnimal = fileName1[0].toString().split("_");
        var finalFileName = fileNameAnimal[fileNameAnimal.length - 1];
        print("currentindex:" + finalFileName.toString());
        setState(() {
          titlezzz = finalFileName;
          print("thay title");
        });
      },
      scrollDirection: Axis.horizontal,
      items: _viewModel.data.map<Widget>((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    i["icon"],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ));
          },
        );
      }).toList(),
    );
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _presenter.action(Constances.GOBACK, {
                  "context": context,
                  "data": {"aaa:": "bbb"}
                });
              }),
          title: new Text(titlezzz),
        ),
        body: _viewModel != null
            ? Container(
                color: Colors.black54,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 2, child: slider),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 80.0, right: 80.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () {
//                                _presenter.action(Constances.PREVIOUS, {"context":context, "index":_viewModel.currentIndex});
                                        slider.previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                      child: Icon(
                                        Icons.skip_previous,
                                        size: 40,
                                        color: Colors.white,
                                      )),
                                  _viewModel.isPlaying
                                      ? GestureDetector(
                                          onTap: () {
                                            _presenter.action(
                                                Constances.PAUSE_RINGTONE, {
                                              "index": _viewModel.currentIndex,
                                              "context": context,
                                              "resourceID": _viewModel.data[
                                                      _viewModel.currentIndex]
                                                  ["resourceID"]
                                            });
                                          },
                                          child: Icon(
                                            Icons.pause_circle_outline,
                                            size: 80.0,
                                            color: Colors.white,
                                          ))
                                      : GestureDetector(
                                          onTap: () {
                                            _presenter.action(
                                                Constances.PLAY_RINGTONE, {
                                              "index": _viewModel.currentIndex,
                                              "context": context,
                                              "resourceID": _viewModel.data[
                                                      _viewModel.currentIndex]
                                                  ["resourceID"]
                                            });
                                          },
                                          child: Icon(
                                            Icons.play_circle_outline,
                                            size: 80.0,
                                            color: Colors.white,
                                          )),
                                  GestureDetector(
                                      onTap: () {
//                                _presenter.action(Constances.NEXT, {"context":context, "index":_viewModel.currentIndex});
                                        slider.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                      child: Icon(
                                        Icons.skip_next,
                                        size: 40,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.notifications_active,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _presenter.action(
                                            Constances.SET_NOTIFI_RINGTONE, {
                                          "index": _viewModel.currentIndex,
                                          "context": context,
                                          "resourceID": this
                                                  ._viewModel
                                                  .data[_viewModel.currentIndex]
                                              ["resourceID"],
                                          "fileName": this
                                                  .widget
                                                  .data[_viewModel.currentIndex]
                                              ["fileName"]
                                        });
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.call,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _presenter.action(
                                            Constances.SET_CONTACT_RINGTONE, {
                                          "index": _viewModel.currentIndex,
                                          "context": context,
                                          "resourceID": this
                                                  ._viewModel
                                                  .data[_viewModel.currentIndex]
                                              ["resourceID"],
                                          "fileName": this
                                                  .widget
                                                  .data[_viewModel.currentIndex]
                                              ["fileName"]
                                        });
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.alarm,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _presenter.action(
                                            Constances.SET_ALARM_RINGTONE, {
                                          "index": _viewModel.currentIndex,
                                          "context": context,
                                          "resourceID": this
                                                  ._viewModel
                                                  .data[_viewModel.currentIndex]
                                              ["resourceID"],
                                          "fileName": this
                                                  .widget
                                                  .data[_viewModel.currentIndex]
                                              ["fileName"]
                                        });
                                      }),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
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
                    Text("Downloading....")
                  ],
                )));
  }

  @override
  uiUpdate(viewModel) {
    setState(() {
      this._viewModel = viewModel;
      if (_viewModel.isShowDialog) {
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
              height: 150,
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
}
