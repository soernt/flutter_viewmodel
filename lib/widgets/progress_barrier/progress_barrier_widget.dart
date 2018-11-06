import 'package:flutter/material.dart';

/// Displays a barrier that contains a the progress content (typically something like CircularProgressIndicator), when the isInProgress stream contains a
/// TRUE value other whise the defaultContent is displayed.
class ProgressBarrierWidget extends StatelessWidget {
  // Properties
  @protected
  bool initialIsInProgress;
  final Stream<bool> isInProgress;

  final Widget defaultContent;
  final Widget progressContent;

  final double opacity;
  final Color color;
  final Offset offset;
  final bool dismissible;

  // Methods
  ProgressBarrierWidget({
    Key key,
    this.initialIsInProgress = false,
    @required this.isInProgress,
    @required this.defaultContent,
    @required this.progressContent,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.offset,
    this.dismissible = false,
  })  : assert(isInProgress != null),
        assert(defaultContent != null),
        assert(progressContent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    StreamBuilder sb = new StreamBuilder<bool>(
        initialData: this.initialIsInProgress,
        stream: this.isInProgress,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool isInProgress = (snapshot?.data ?? false);
          List<Widget> widgets = [];
          widgets.add(defaultContent);

          if (isInProgress) {
            Widget layOutProgressIndicator;
            if (offset == null)
              layOutProgressIndicator = Center(child: progressContent);
            else {
              layOutProgressIndicator = Positioned(
                child: progressContent,
                left: offset.dx,
                top: offset.dy,
              );
            }
            MediaQueryData media = MediaQuery.of(context);
            final barrier = [
              ConstrainedBox(
                constraints: BoxConstraints.loose(media.size),
                child: new Opacity(
                  child: new ModalBarrier(
                    dismissible: dismissible,
                    color: color,
                  ),
                  opacity: opacity,
                ),
              ),
              layOutProgressIndicator
            ];
            widgets += barrier;
          }

          return Stack(children: widgets);
        });

    return sb;
  }
}
