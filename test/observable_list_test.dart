import 'dart:async';

import 'package:flutter_view_model/flutter_view_model.dart';
import 'package:test/test.dart';

import 'utils/asyncFunc.dart';

void main() {
  test('ItemAddedEvent should be notified when the \"add\" function is callled', () async {
    Completer completer = Completer();
    int itemAddedEventCalled = 0;

    ObservableList<String> list = ObservableList<String>();
    list.whenPropertyChanged(ItemAddedEvent.operationName).listen((PropertyChangedEvent event) {
      itemAddedEventCalled++;
      completer.complete();
    });

    list.add("1");

    await waitFor(completer.future);
    expect(itemAddedEventCalled, 1);
  });

  test('ItemRemovedEvent should be notified when the \"remove\" function is callled', () async {
    Completer completer = Completer();
    int itemRemovedEventCalled = 0;

    ObservableList<String> list = ObservableList<String>();
    list.add("1");
    list.whenPropertyChanged(ItemRemovedEvent.operationName).listen((PropertyChangedEvent event) {
      itemRemovedEventCalled++;
      completer.complete();
    });
    
    list.remove("1");

    await waitFor(completer.future);
    expect(itemRemovedEventCalled, 1);
  });

  test('RemoveWhere should be notified ItemRemovedEvent', () async {
    Completer completer = Completer();
    int itemRemovedEventCalled = 0;

    ObservableList<String> list = ObservableList<String>();
    list.add("1");
    list.add("2");
    list.add("3");
    list.whenPropertyChanged(ItemRemovedEvent.operationName).listen((PropertyChangedEvent event) {
      itemRemovedEventCalled++;
      completer.complete();
    });
    
    list.removeWhere( (item) => item == "2");

    await waitFor(completer.future);
    expect(list.length, 2);
    expect(itemRemovedEventCalled, 1);
  });

}
