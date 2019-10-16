import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_view_model/services/busy_indicator.dart';

import 'utils/asyncFunc.dart';

void main() {
  test('Calling startAction should indicate a busy state, dispose of BusyAction should indicate not busy state', () async {
    Completer isBusyTrueCompleter = Completer();
    Completer isBusyFalseCompleter = Completer();
    int countIsBusyTrueEvents = 0;
    int countIsBusyFalseEvents = 0;

    final indicator = BusyIndicator();
    indicator.isBusyStream.listen((isBusy) {
      if (isBusy) {
        countIsBusyTrueEvents++;
        isBusyTrueCompleter.complete();
      } else {
        countIsBusyFalseEvents++;
        isBusyFalseCompleter.complete();
      }
    });
    final action = indicator.startAction();
    expect(indicator.isBusy, true);
    action.dispose();
    expect(indicator.isBusy, false);

    await waitForAll(<Future>[isBusyTrueCompleter.future, isBusyFalseCompleter.future]);
    expect(countIsBusyTrueEvents, 1);
    expect(countIsBusyFalseEvents, 1);
  });
}
