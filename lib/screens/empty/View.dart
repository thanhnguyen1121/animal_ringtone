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

class _ViewState extends State<View> implements BaseView {
  ViewModel _viewModel;
  BasePresenter _presenter;
  @override
  void initState() {
    super.initState();
    _presenter = new Presenter();
    _presenter.init(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              I18n.of(context).t("title"),
            ),
            GestureDetector(
              onTap: () => {
              _presenter.action(Constances.BACK, {
                  "data": {"name": "Nhozip"},
                  "context": this.context,
                })
              },
              child: Text("BACK DATA"),
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () =>
            _presenter.action(Constances.CLICK_UP, null),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  @override
  uiUpdate(viewModel) {
    setState(() {
      this._viewModel = viewModel;
    });
  }
}
