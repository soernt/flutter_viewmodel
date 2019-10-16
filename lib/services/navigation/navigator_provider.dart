import 'package:flutter/widgets.dart';
import 'package:flutter_view_model/services/navigation/inavigator_provider.dart';

/// Get the current NavigatorState. That state will be used to provide a "view model" based navigation".
class NavigatorProvider implements INavigatorProvider {
  // Properties
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState;

  // Methods

}
