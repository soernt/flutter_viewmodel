import 'package:flutter/widgets.dart';
import 'package:flutter_view_model/viewmodel/inotify_property_changed.dart';

/// Rebuilds a widget (via the given builder function) whenever the given property (propertyName) changes.
/// Example:
///
///  Widget build(BuildContext context) {
///    final vm = SplashPageViewModelProvider.of(context); // Get the ViewModel from the Provider.
///    ...
///    return PropertyChangedWidgetBuilder(
///              notificationSource: vm,
///              propertyName: "statusText", // A PropertyName
///              builder: (context, snapshot) { // the snapshot parameter is ignored, since it don't carry around the actual data.
///                return Text(vm.statusText);  // Instead, get the data from the ViewModel.
///              }),
///  }
class PropertyChangedWidgetBuilder extends StreamBuilder<PropertyChangedEvent> {
  // Properties

  // Methods
  PropertyChangedWidgetBuilder(
      {Key key,
      @required INotifyPropertyChanged notificationSource,
      String propertyName = "",
      @required AsyncWidgetBuilder<PropertyChangedEvent> builder})
      : super(
            key: key,
            builder: builder,
            stream: notificationSource
                .whenPropertyChanged<PropertyChangedEvent>(propertyName));
}
