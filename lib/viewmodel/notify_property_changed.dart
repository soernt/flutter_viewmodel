import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../idisposable.dart';
import '../utils/string_utils.dart';
import 'inotify_property_changed.dart';

typedef SetValue<TValue> = void Function(TValue value);

typedef Action = void Function();

/// Implementation of the INotifyPropertyChanged and IDisposable interface.
class NotifyPropertyChanged implements INotifyPropertyChanged, IDisposable {
  // Properites
  @override
  final PublishSubject<PropertyChangedEvent> propertyChanged =
      PublishSubject<PropertyChangedEvent>();

  @override
  bool isPausingSendNotifications = false;

  // Methods

  /// Closes propertyChanged notifications
  @mustCallSuper
  @override
  void dispose() {
    propertyChanged.close();
  }

  /// If the values of currentValue and newValue are not equal, a PropertyChangeEvent will be send.
  /// Returns true when values of currentValue and newValue are not equal, otherwise returns false.
  @protected
  bool updateValue<TPropertyType>(
      String propertyName,
      TPropertyType currentValue,
      TPropertyType newValue,
      SetValue<TPropertyType> setNewValue) {
    assert(setNewValue != null);

    if (currentValue == newValue) {
      return false;
    }
    setNewValue(newValue);
    notifyPropertyChanged(propertyName);
    return true;
  }

  void doWhileStopNotification(Action action) {
    assert(action != null);
    isPausingSendNotifications = true;
    try {
      action();
    } finally {
      isPausingSendNotifications = false;
    }
  }

  @protected
  sendNotification(PropertyChangedEvent event) {
    if (!isPausingSendNotifications) {
      propertyChanged.add(event);
    }
  }

  /// Publishes a PropertyChangedEvent with the given propertyName parameter.
  @protected
  void notifyPropertyChanged(String propertyName) {
    sendNotification(PropertyChangedEvent(this, propertyName));
  }

  /// Publishes a PropertyChangedEvent indicating that all properties have changed.
  @protected
  void notifyAllPropertiesChanged() {
    notifyPropertyChanged("");
  }

  /// Returns an Observable of PropertyChangedEvent items that will receive an PropertyChangedEvent whenever the given propertyName indicates a change.
  Observable<PropertyChangedEvent> whenPropertyChanged<TPropertyType>(
      String propertyName) {
    final propertyNameIsEmpty = isEmpty(propertyName);
    return propertyChanged
        .where((event) =>
            isEmpty(event.propertyName) ||
            propertyNameIsEmpty ||
            event.propertyName == propertyName)
        .transform(StreamTransformer.fromHandlers(handleData:
            (PropertyChangedEvent value, EventSink<PropertyChangedEvent> sink) {
      sink.add(value);
    }));
  }

  /// Returns an Observable of PropertyChangedEvent items that will receive an PropertyChangedEvent whenever one of the given propertyNames indicates a change.
  Observable<PropertyChangedEvent> whenAnyOfPropertiesChanged<TPropertyType>(
      Set<String> propertyNames) {
    assert(propertyNames != null && propertyNames.length != 0);

    return propertyChanged
        .where((event) =>
            isEmpty(event.propertyName) ||
            propertyNames.contains(event.propertyName))
        .transform(StreamTransformer.fromHandlers(handleData:
            (PropertyChangedEvent value, EventSink<PropertyChangedEvent> sink) {
      sink.add(value);
    }));
  }

  /// Returns an Observale that will receive an PropertyChangedEvent whenever one of the given propertyNames indicates a change.
  Observable whenPropertyChangedHint<TPropertyType>(String propertyName) {
    final propertyNameIsEmpty = isEmpty(propertyName);
    return propertyChanged
        .where((event) =>
            isEmpty(event.propertyName) ||
            propertyNameIsEmpty ||
            event.propertyName == propertyName)
        .transform(StreamTransformer.fromHandlers(
            handleData: (PropertyChangedEvent value, EventSink<void> sink) {
      sink.add(null);
    }));
  }

  /// Returns an Observale that will receive an PropertyChangedEvent whenever the given propertyNames indicates a change.
  Observable<void> whenAnyOfPropertiesChangedHint(Set<String> propertyNames) {
    assert(propertyNames != null && propertyNames.length != 0);

    return propertyChanged
        .where((event) =>
            isEmpty(event.propertyName) ||
            propertyNames.contains(event.propertyName))
        .transform(StreamTransformer.fromHandlers(
            handleData: (PropertyChangedEvent value, EventSink<void> sink) {
      sink.add(null);
    }));
  }
}
