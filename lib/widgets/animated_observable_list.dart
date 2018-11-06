import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_view_model/flutter_view_model.dart';

typedef AnimatedListItemBuilderEx<TItem> = Widget Function(BuildContext context,
    TItem item, int index, Animation<double> animation, bool isRemoving);

// The default insert/remove animation duration.
const Duration _kDuration = Duration(milliseconds: 300);

/// AnimatedObservableList encapsulate an AnimatedList widget for an ObservableList property.
/// Example:
///
///     Widget build(BuildContext context) {
///       final HomePageViewModel vm = HomePageViewModelProvider.of(context);
///
///       return ViewModelPropertyWidgetBuilder(
///            viewModel: vm,
///            propertyName: HomePageViewModel.guestsPropName,
///            builder: (context, snapshot) {
///
///              return AnimatedObservableList<GuestViewModel>(
///                  list: vm.guests,
///                  itemBuilder: (BuildContext context, GuestViewModel item, int index, Animation<double> animation, bool isRemoving) {
///                    return _createGuestItemView(context, item, animation);
///                  });
///            })
///     }

class AnimatedObservableList<TItem> extends StatefulWidget {
  // Properties
  final ObservableList<TItem> list;
  final AnimatedListItemBuilderEx<TItem> itemBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final Duration insertItemDuration;
  final Duration removeItemDuration;

  // Methods
  AnimatedObservableList({
    Key key,
    @required this.list,
    @required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.insertItemDuration = _kDuration,
    this.removeItemDuration = _kDuration,
  })  : assert(list != null),
        assert(itemBuilder != null),
        super(key: key);

  @override
  _AnimatedObservableListState<TItem> createState() =>
      _AnimatedObservableListState<TItem>();
}

class _AnimatedObservableListState<TItem>
    extends State<AnimatedObservableList<TItem>> {
  // Properties
  StreamSubscription<PropertyChangedEvent> _subscription;
  GlobalKey<AnimatedListState> _animatedListKey;

  // Methods
  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.list != null) {
      _subscription = widget.list
          .whenAnyOfPropertiesChanged(Set<String>.of(<String>[
        ItemAddedEvent.operationName,
        ItemRemovedEvent.operationName
      ]))
          .listen(
        (PropertyChangedEvent data) {
          final animatedListState = _animatedListKey.currentState;

          if (data is ItemAddedEvent) {
            animatedListState.insertItem(data.index,
                duration: widget.insertItemDuration);
          }

          if (data is ItemRemovedEvent) {
            animatedListState.removeItem(data.index,
                (BuildContext context, Animation<double> animation) {
              return widget.itemBuilder(
                  context, data.item as TItem, data.index, animation, true);
            }, duration: widget.removeItemDuration);
          }
        },
        onError: (Object error) {},
        onDone: () {},
      );
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _animatedListKey = GlobalKey<AnimatedListState>();
    return AnimatedList(
      key: _animatedListKey,
      initialItemCount: widget.list.length,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return widget.itemBuilder(
            context, widget.list[index], index, animation, false);
      },
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
    );
  }
}
