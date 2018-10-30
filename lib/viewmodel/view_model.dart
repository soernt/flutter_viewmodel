import 'inotify_property_changed.dart';
import 'notify_property_changed.dart';

/// A ViewModel
abstract class ViewModel extends NotifyPropertyChanged
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
