import 'package:flutter_view_model/idisposable.dart';
import 'package:rxdart/rxdart.dart';

typedef AsyncAction = Future<void> Function();

/// View model for a busy state.
class BusyIndicator {
  // Properties
  final PublishSubject<bool> isBusyStream = PublishSubject<bool>();
  int _bussyCounter = 0;

  bool get isBusy => 0 < _bussyCounter;

  // Methods
  BusyIndicator() {
    // Initial state is "not busy".
    isBusyStream.add(false);
  }

  void _setIsBusy(bool isBusy) {
    if (isBusy) {
      _bussyCounter++;
      if (_bussyCounter == 1) {
        isBusyStream.add(true);
      }
    } else {
      if (_bussyCounter != 0) {
        _bussyCounter--;
        if (_bussyCounter == 0) {
          isBusyStream.add(false);
        }
      }
    }
  }

  void reset() {
    if (_bussyCounter != 0) {
      _bussyCounter = 0;
      isBusyStream.add(false);
    }
  }

  BusyAction startAction() {
    _setIsBusy(true);
    return BusyAction(this);
  }

  void _actionEnded() {
    _setIsBusy(false);
  }

  Future<void> doAction(AsyncAction action) async {
    final busyAction = startAction();
    try {
      await action();
    } finally {
      busyAction.dispose();
    }
  }
}

class BusyAction implements IDisposable {
  // Properties
  final BusyIndicator _owner;

  BusyAction(this._owner);

  @override
  void dispose() {
    _owner._actionEnded();
  }
}
