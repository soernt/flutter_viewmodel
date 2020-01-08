import 'dart:core';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'package:flutter_view_model/idisposable.dart';
import 'package:flutter_view_model/viewmodel/inotify_property_changed.dart';
import 'package:flutter_view_model/viewmodel/notify_property_changed_mixin.dart';

typedef Transformer<TItem, TTransformedItem> = TTransformedItem Function(
    TItem item);

abstract class ItemAddedOrRemovedEvent extends PropertyChangedEvent {
  // Properties

  /// The item that has been added or removed
  final Object item;

  // The index of the item property;
  final int index;

  // Methods
  ItemAddedOrRemovedEvent(
      Object sender, String propertyName, this.item, this.index)
      : assert(item != null),
        assert(index != null && index >= 0),
        super(sender, propertyName);
}

class ItemAddedEvent extends ItemAddedOrRemovedEvent {
  // Properties
  static const String operationName = "add";

  // Methods
  ItemAddedEvent(Object sender, Object item, int index)
      : super(sender, operationName, item, index);
}

class ItemRemovedEvent extends ItemAddedOrRemovedEvent {
  // Properties
  static const String operationName = "remove";

  // Methods
  ItemRemovedEvent(Object sender, Object item, int index)
      : super(sender, operationName, item, index);
}

/// When ever the list changes a notification is send.
class ObservableList<E> extends DelegatingList<E>
    with NotifyPropertyChangedMixin {
  // Properties
  /// Property name to indicate that something has been changed;
  static const String itemsChangedPropertyName = "items";

  final List<E> _internal;
  final bool _disposeItems;

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
    return updateValue(
        itemsChangedPropertyName, currentValue, newValue, setNewValue);
  }

  void notifyItemsChanged() {
    notifyPropertyChanged(itemsChangedPropertyName);
  }

  @protected
  void _notifyItemAdded(E item) {
    sendNotification(ItemAddedEvent(this, item, indexOf(item)));
  }

  @protected
  void _notifyItemRemoved(E item, int index) {
    sendNotification(ItemRemovedEvent(this, item, index));
  }

  @override
  void add(E value) {
    _internal.add(value);
    notifyItemsChanged();
    _notifyItemAdded(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _internal.addAll(iterable);
    notifyItemsChanged();
  }

  void addTransformed<TItem>(
      Iterable<TItem> iterable, Transformer<TItem, E> transformer) {
    iterable.forEach((item) => add(transformer(item)));
  }

  @override
  void clear() {
    if (_disposeItems) {
      _internal.forEach((item) => disposeItem(item));
    }
    _internal.clear();
    notifyItemsChanged();
  }

  @override
  void fillRange(int start, int end, [E fillValue]) {
    _internal.fillRange(start, end, fillValue);
    notifyItemsChanged();
  }

  @override
  void insert(int index, E element) {
    _internal.insert(index, element);
    notifyItemsChanged();
    _notifyItemAdded(element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _internal.insertAll(index, iterable);
    notifyItemsChanged();
  }

  @override
  bool remove(Object value) {
    final idx = _internal.indexOf(value);
    final result = _internal.remove(value);
    notifyItemsChanged();
    _notifyItemRemoved(value, idx);
    return result;
  }

  @override
  E removeAt(int index) {
    var result = _internal.removeAt(index);
    notifyItemsChanged();
    _notifyItemRemoved(result, index);
    return result;
  }

  @override
  E removeLast() {
    final lastIdx = length - 1;
    final result = _internal.removeLast();
    notifyItemsChanged();
    _notifyItemRemoved(result, lastIdx);
    return result;
  }

  @override
  void removeRange(int start, int end) {
    _internal.removeRange(start, end);
    notifyItemsChanged();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    for (int i = length - 1; 0 <= i; i--) {
      final item = this[i];
      if (test(item)) {
        _internal.removeAt(i);
        _notifyItemRemoved(item, i);
      }
    }
    notifyItemsChanged();
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _internal.replaceRange(start, end, replacement);
    notifyItemsChanged();
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _internal.retainWhere(test);
    notifyItemsChanged();
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _internal.setAll(index, iterable);
    notifyItemsChanged();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _internal.setRange(start, end, iterable);
    notifyItemsChanged();
  }

  @override
  void shuffle([Random random]) {
    _internal.shuffle(random);
    notifyItemsChanged();
  }

  @override
  void sort([int Function(E a, E b) compare]) {
    _internal.sort(compare);
    notifyItemsChanged();
  }
}
