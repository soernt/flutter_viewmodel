import 'package:flutter/material.dart' show AlertDialog, FlatButton, NavigatorState, Text, Widget, protected, showDialog;

import 'package:flutter_view_model/services/translations/itext_provider.dart';
import 'package:flutter_view_model/services/navigation/iapp_navigator.dart';
import 'package:flutter_view_model/services/navigation/ibuild_context_provider.dart';
import 'package:flutter_view_model/services/navigation/inavigator_provider.dart';

/// AppNavigator provides navigation capabilities for a view model
/// This class should be extendend of app specific pages navigation functions.
class AppNavigator implements IAppNavigator {
  // Properties

  /// Provider of the Navigator
  final INavigatorProvider _navigatorProvider;
  @protected
  NavigatorState get navigator => _navigatorProvider.navigator;

  /// Provides text translations
  @protected
  final ITextProvider textProvider;

  /// Provides a buildContext that is within the current Page
  @protected
  final IBuildContextProvider buildContextProvider;

  AppNavigator(
      ITextProvider textProvider,
      IBuildContextProvider buildContextProvider,
      INavigatorProvider navigatorProvider)
      : assert(textProvider != null),
        assert(buildContextProvider != null),
        assert(navigatorProvider != null),
        textProvider = textProvider,
        buildContextProvider = buildContextProvider,
        _navigatorProvider = navigatorProvider;

  Future<void> showInfoDialog(String title, String message) {
    return showDialog(
        context: buildContextProvider.buildContext,
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
              child: Text(textProvider.buttonTypeTextProvider
                  .getButtonText(ButtonTypes.ok)),
              onPressed: () => navigator.pop(ButtonTypes.ok));
          break;
        default:
          throw ArgumentError("${buttonTypes[i].toString()} is not handled.");
      }
      buttons.add(btn);
    }
    return buttons;
  }

  bool pop<T extends Object>([T result]) {
    return navigator.pop();
  }
}
