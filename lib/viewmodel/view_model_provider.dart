import 'package:flutter/widgets.dart';
import 'package:flutter_view_model/viewmodel/view_model.dart';

/// Provides access to a ViewModel.
abstract class ViewModelProvider<TViewModel extends ViewModel>
    extends InheritedWidget {
  // Properties

  final TViewModel viewModel;

  // Methods

  /// ViewModel is the instance that this Provider should provide.
  /// The childBuilder is used to create the UI for the given viewModel
  ViewModelProvider(
      {Key key,
      @required TViewModel viewModel,
      @required WidgetBuilder childBuilder})
      : this._default(
            key: key, viewModel: viewModel, childBuilder: childBuilder);

  ViewModelProvider._default(
      {Key key,
      @required TViewModel viewModel,
      @required WidgetBuilder childBuilder})
      : assert(viewModel != null),
        assert(childBuilder != null),
        viewModel = viewModel,
        super(
            key: key,
            child: _ViewModelViewStateManager(
              viewModel: viewModel,
              childBuilder: childBuilder,
            ));

  @override
  bool updateShouldNotify(ViewModelProvider<TViewModel> oldWidget) {
    return viewModel != oldWidget.viewModel;
  }
}

/// Maintain the lifecycle of a ViewModel
class _ViewModelViewStateManager extends StatefulWidget {
  // Properties
  final ViewModel _viewModel;
  final WidgetBuilder _childBuilder;

  // Methods

  _ViewModelViewStateManager(
      {@required ViewModel viewModel, @required WidgetBuilder childBuilder})
      : assert(viewModel != null),
        assert(childBuilder != null),
        _childBuilder = childBuilder,
        _viewModel = viewModel;

  @override
  State<StatefulWidget> createState() => _ViewModelViewStateManagerState();
}

class _ViewModelViewStateManagerState
    extends State<_ViewModelViewStateManager> {
  // Properties

  // Methods

  @override
  void initState() {
    super.initState();
    widget._viewModel.viewInitState();
  }

  @override
  Widget build(BuildContext context) {
    return widget._childBuilder(context);
  }

  @override
  void dispose() {
    widget._viewModel.viewDispose();
    super.dispose();
  }
}
