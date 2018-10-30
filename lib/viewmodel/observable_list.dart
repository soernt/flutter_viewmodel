import 'dart:core';
import 'dart:math';

import 'package:collection/collection.dart';

import '../idisposable.dart';
import 'inotify_property_changed.dart';
import 'notify_property_changed.dart';

typedef Transformer<TItem, TTransformedItem> = TTransformedItem Function(
    TItem item);

/// When ever the list changes a notification is send.
class ObservableList<E> extends DelegatingList<E> with NotifyPropertyChanged {
  // Properties
  final List<E> _internal;
  final bool _disposeItems;
  bool _suppressChangeNotification = false;

  @override
  set first(E value) =>
      _updateValue(_internal.first, value, (v) => _internal.first = v);

  @override
  E get last => _internal.last;

  @override
  set last(E value) =>
      _updateValue(_internal.last, value, (v) => _internal.last = v);

  @override
  int get length => _internal.length;
  @override
  set length(int value) =>
      _updateValue(_internal.length, value, (v) => _internal.length = v);

  @override
  E operator [](int index) => _internal[index];

  @override
  void operator []=(int index, E value) =>
      _updateValue(_internal[index], value, (v) => _internal[index] = v);

  // Methods

  ObservableList([bool disposeItems = true]) : this._(<E>[], disposeItems);

  ObservableList._(internal, bool disposeItems)
      : _internal = internal,
        _disposeItems = disposeItems,
        super(internal);

  @override
  void dispose() {
    _internal.forEach((item) => disposeItem(item));
    _internal.clear();
    super.dispose();
  }

  void disposeItem(E item) {
    (item as IDisposable)?.dispose();
  }

  bool _updateValue<TPropertyType>(TPropertyType currentValue,
      TPropertyType newValue, SetValue<TPropertyType> setNewValue) {
    return updateValue("", currentValue, newValue, setNewValue);
  }

  void _notifyPropertyChanged() {
    notifyPropertyChanged("");
  }

  @override
  void notifyPropertyChanged(String propertyName) {
    if (_suppressChangeNotification) {
      return;
    }
    propertyChanged.add(PropertyChangedEvent(this, propertyName));
  }

  @override
  void add(E value) {
    _internal.add(value);
    _notifyPropertyChanged();
  }

  @override
  void addAll(Iterable<E> iterable) {
    _internal.addAll(iterable);
    _notifyPropertyChanged();
  }

  void addTransformed<TItem>(
      Iterable<TItem> iterable, Transformer<TItem, E> transformer) {
    _suppressChangeNotification = true;
    try {
      iterable.forEach((item) => add(transformer(item)));
    } finally {
      _suppressChangeNotification = false;
    }
  }

  @override
  void clear() {
    if (_disposeItems) {
      _internal.forEach((item) => disposeItem(item));
    }
    _internal.clear();
    _notifyPropertyChanged();
  }

  @override
  void fillRange(int start, int end, [E fillValue]) {
    _internal.fillRange(start, end, fillValue);
    _notifyPropertyChanged();
  }

  @override
  void insert(int index, E element) {
    _internal.insert(index, element);
    _notifyPropertyChanged();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _internal.insertAll(index, iterable);
    _notifyPropertyChanged();
  }

  @override
  bool remove(Object value) {
    var result = _internal.remove(value);
    _notifyPropertyChanged();
    return result;
  }

  @override
  E removeAt(int index) {
    var result = _internal.removeAt(index);
    _notifyPropertyChanged();
    return result;
  }

  @override
  E removeLast() {
    var result = _internal.removeLast();
    _notifyPropertyChanged();
    return result;
  }

  @override
  void removeRange(int start, int end) {
    _internal.removeRange(start, end);
    _notifyPropertyChanged();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _internal.removeWhere(test);
    _notifyPropertyChanged();
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _internal.replaceRange(start, end, replacement);
    _notifyPropertyChanged();
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _internal.retainWhere(test);
    _notifyPropertyChanged();
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _internal.setAll(index, iterable);
    _notifyPropertyChanged();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _internal.setRange(start, end, iterable);
    _notifyPropertyChanged();
  }

  @override
  void shuffle([Random random]) {
    _internal.shuffle(random);
    _notifyPropertyChanged();
  }

  @override
  void sort([int Function(E a, E b) compare]) {
    _internal.sort(compare);
    _notifyPropertyChanged();
  }
}
