import 'package:flutter_view_model/viewmodel/inotify_property_changed.dart';
import 'package:flutter_view_model/viewmodel/notify_property_changed_mixin.dart';

/// A ViewModel
abstract class ViewModel
    with NotifyPropertyChangedMixin
    implements INotifyPropertyChanged {
  // Properties

  // Methods

  /// Is called by a ViewModelViewStateManager  within the initState() method.
  /// That gives the ViewModel the possiblity to initialize itself e.g. fetch some data
  Future<void> viewInitState() {
    return Future<void>.value();
  }

  /// Is called by a ViewModelViewStateManager within the dispose method.
  /// That gives the ViewModel the possiblity to free up allocated resources when the ViewModelProvidere widget is getting dispose.
  Future<void> viewDispose() {
    return Future<void>.value();
  }
}
