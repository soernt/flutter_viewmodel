import 'package:flutter/material.dart';
import 'inavigator_provider.dart';

import '../translations/itext_provider.dart';
import 'ibuild_context_provider.dart';
import 'iapp_navigator.dart';

/// AppNavigator provides navigation capabilities for a view model
/// This class should be extendend of app specific pages navigation functions.
class AppNavigator implements IAppNavigator {
  // Properties
  final ITextProvider _textProvider;
  final IBuildContextProvider _buildContextProvider;
  final INavigatorProvider _navigatorProvider;

  NavigatorState get _navigator => _navigatorProvider.navigator;

  AppNavigator(
      ITextProvider textProvider,
      IBuildContextProvider buildContextProvider,
      INavigatorProvider navigatorProvider)
      : assert(textProvider != null),
        assert(buildContextProvider != null),
        assert(navigatorProvider != null),
        _textProvider = textProvider,
        _buildContextProvider = buildContextProvider,
        _navigatorProvider = navigatorProvider;

  Future<void> showInfoDialog(String title, String message) {
    return showDialog(
        context: _buildContextProvider.buildContext,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: _buildDialogButtons([ButtonTypes.ok]),
            ));
  }

  List<FlatButton> _buildDialogButtons(List<ButtonTypes> buttonTypes) {
    List<FlatButton> buttons = List<FlatButton>();
    for (var i = 0; i < buttonTypes.length; i++) {
      Widget btn;
      switch (buttonTypes[i]) {
        case ButtonTypes.ok:
          btn = FlatButton(
              child: Text(_textProvider.buttonTypeTextProvider
                  .getButtonText(ButtonTypes.ok)),
              onPressed: () => _navigator.pop(ButtonTypes.ok));
          break;
        default:
          throw ArgumentError("${buttonTypes[i].toString()} is not handled.");
      }
      buttons.add(btn);
    }
    return buttons;
  }

  bool pop<T extends Object>([T result]) {
    return _navigator.pop();
  }
}
