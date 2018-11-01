import 'package:rxdart/rxdart.dart';

/// Notification that indicates which Property changed
class PropertyChangedEvent {
  // Properties
  /// Who send this Event
  final Object sender;

  /// Which property changed.
  final String propertyName;

  // Methods
  const PropertyChangedEvent(this.sender, this.propertyName);
}

/// Notifies clients that a property value has changed and privides some conveniences subsribtion functions.
abstract class INotifyPropertyChanged {
  // Properties
  /// Occurs when a property value changes.
  PublishSubject<PropertyChangedEvent> get propertyChanged;

  /// Stop/resume sending notifications
  bool isPausingSendNotifications;

  // Methods

  /// Returns an Observable of PropertyChangedEvent items that will receive an PropertyChangedEvent whenever the given propertyName indicates a change.
  /// When the propertyName is empty (null or length == 0), than the oberservale gets notified by any changes of the ViewModel
  Observable<PropertyChangedEvent> whenPropertyChanged<TPropertyType>(
      String propertyName);

  /// Returns an Observable of PropertyChangedEvent items that will receive an PropertyChangedEvent whenever one of the given propertyNames indicates a change.
  Observable<PropertyChangedEvent> whenAnyOfPropertiesChanged<TPropertyType>(
      Set<String> propertyNames);

  /// Returns an Observale that will receive an PropertyChangedEvent whenever one of the given propertyNames indicates a change.
  /// When the propertyName is empty (null or length == 0), than the oberservale gets notified by any changes of the ViewModel
  Observable whenPropertyChangedHint<TPropertyType>(String propertyName);

  /// Returns an Observale that will receive an PropertyChangedEvent whenever the given propertyNames indicates a change.
  Observable<void> whenAnyOfPropertiesChangedHint(Set<String> propertyNames);
}
