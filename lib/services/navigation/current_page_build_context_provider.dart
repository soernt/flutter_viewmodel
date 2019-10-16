import 'package:flutter/widgets.dart';

import 'package:flutter_view_model/services/navigation/ibuild_context_provider.dart';
import 'package:flutter_view_model/services/navigation/page_root_widget.dart';

/// Provides a BuildContext for the currently displayed page.
/// Usage:
/// new MaterialApp( ...
///   navigatorObservers: <NavigatorObserver>[CurrentPageBuildContextProvider()],
/// );
class CurrentPageBuildContextProvider extends NavigatorObserver
    implements IBuildContextProvider {
  // Properties
  Route _route;

  BuildContext get buildContext => _getBuildContextForCurrentRoute();

  // Methods
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    _updateRoute(route);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if (_route == oldRoute) {
      _updateRoute(newRoute);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    _updateRoute(previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    if (route == _route) {
      _updateRoute(previousRoute);
    }
  }

  void _updateRoute(Route route) {
    _route = route;
  }

  BuildContext _getBuildContextForCurrentRoute() {
    assert(_route != null);
    assert(_route.navigator != null);
    assert(_route.navigator.context != null);

    BuildContext ctx;
    ElementVisitor findBuildContextWithinChildenFunc;

    findBuildContextWithinChildenFunc = (Element child) {
      if (ctx != null) {
        return;
      }

      if (child.widget is PageRootWidget) {
        ctx = (child.widget as PageRootWidget).buildContext;
        return;
      }

      child.visitChildElements(findBuildContextWithinChildenFunc);
    };

    _route.navigator.context
        .visitChildElements(findBuildContextWithinChildenFunc);
    assert(ctx != null);
    return ctx;
  }
}
