import 'package:flutter/widgets.dart';

abstract class INavigationService {
  GlobalKey<NavigatorState> get navigatorKey;

  Future<dynamic> navigateTo(
    String routeName, {
    Object arguments,
  });
}

/// Usage: https://medium.com/flutter-community/navigate-without-context-in-flutter-with-a-navigation-service-e6d76e880c1c
///
///  INavigationService navigationService = ...
/// return MaterialApp(
///    title: 'Flutter Demo',
///    ....
///    navigatorKey: navigationService.navigatorKey,
///    ....
///    home: HomeView()
///    );
///
///    Register the implementation as a singleton.
///
class NavigationService implements INavigationService {
  final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<dynamic> navigateTo(
    String routeName, {
    Object arguments,
  }) {
    return _navigatorKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }
}
