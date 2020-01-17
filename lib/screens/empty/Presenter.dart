import '../../base/BasePresenter.dart';
import '../../base/BaseView.dart';
import '../../constance/Constances.dart';
import '../../utils/intent.dart';
import 'Viewmodel.dart';

class Presenter implements BasePresenter {
  ViewModel _viewModel;
  BaseView _view;

  Presenter() {

  }

  @override
  action(key, data) {}

  @override
  init(view) {
    this._view = view;
    this._view.uiUpdate(this._viewModel);
  }
}
