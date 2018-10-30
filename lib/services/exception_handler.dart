import 'dart:async';
import 'dart:collection';

import 'iexception_handler.dart';
import 'navigation/iapp_navigator.dart';
import 'translations/itext_provider.dart';

/// Displays an exception dialog.
class ExceptionHandler implements IExceptionHandler {
  // Properties
  final Queue<Object> _exceptions;
  final IAppNavigator _navigator;
  final IExceptionDialogTextProvider _textProvider;
  // Methods

  ExceptionHandler(
      IAppNavigator appNavigator, IExceptionDialogTextProvider textProvider)
      : assert(appNavigator != null),
        assert(textProvider != null),
        _navigator = appNavigator,
        _textProvider = textProvider,
        _exceptions = Queue<Object>();

  Future<void> addException(Object exceptionOrError) async {
    _exceptions.add(exceptionOrError);
    await _displayExceptions();
  }

  Future<void> _displayExceptions() async {
    while (_exceptions.isNotEmpty) {
      final ex = _exceptions.removeFirst();
      final message = _textProvider.translateException(ex);
      await _navigator.showInfoDialog(
          _textProvider.exceptionDialogTitle, message);
    }
  }
}
