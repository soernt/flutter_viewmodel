import 'package:flutter/widgets.dart';

/// This Widget is used to get a BuildContext for the currently displayed page.
/// It should be the very first Widget within a page.
class PageRootWidget extends StatefulWidget {
  // Properties
  final WidgetBuilder _childBuilder;

  BuildContext buildContext;

  PageRootWidget({@required WidgetBuilder childBuilder})
      : assert(childBuilder != null),
        _childBuilder = childBuilder;

  // Methods
  @override
  State<StatefulWidget> createState() => _PageRootWidgetState();
}

class _PageRootWidgetState extends State<PageRootWidget> {
  // Properties

  // Methods
  @override
  void initState() {
    super.initState();
    widget.buildContext = context;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.buildContext = context;
  }

  @override
  Widget build(BuildContext context) {
    widget.buildContext = context;
    return widget._childBuilder(context);
  }

  @override
  void deactivate() {
    widget.buildContext = context;
    super.deactivate();
  }

  @override
  void dispose() {
    widget.buildContext = null;
    super.dispose();
  }
}
