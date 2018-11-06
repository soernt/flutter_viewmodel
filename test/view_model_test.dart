import 'dart:async';

import 'package:flutter_view_model/flutter_view_model.dart';
import 'package:test/test.dart';

import 'utils/asyncFunc.dart';

class TestViewModel extends ViewModel {
  // Properties

  String _firstName;
  static const String firstNamePropName = "firstName";
  String get firstName => _firstName;
  set firstName(String value) {
    updateValue(firstNamePropName, _firstName, value, (v) => _firstName = v);
  }

  // Methods

  TestViewModel() : super();
}

void main() {
  test('After changing the firstName property, a PropertyChangedEvent for the firstName should be streamed', () async {
    Completer completer = Completer();
    PropertyChangedEvent firstNameEvent;

    TestViewModel vm = TestViewModel();
    vm.whenPropertyChanged(TestViewModel.firstNamePropName).listen((PropertyChangedEvent event) {
      firstNameEvent = event;
      completer.complete();
    });

    vm.firstName = "Fred";

    await waitFor(completer.future);
    expect(firstNameEvent.propertyName, TestViewModel.firstNamePropName);
  });
}
