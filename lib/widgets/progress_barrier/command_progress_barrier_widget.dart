import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_command/rx_command.dart';
import 'progress_barrier_widget.dart';

/// Displays a progressContent while the associated command is executing.
class CommandProgressBarrierWidget extends ProgressBarrierWidget {
  CommandProgressBarrierWidget({
    Key key,
    @required RxCommand command,
    @required defaultContent,
    progressContent = const CircularProgressIndicator(),
    opacity = 0.3,
    color = Colors.grey,
    offset,
    dismissible = false,
  })  : assert(command != null),
        assert(progressContent != null),
        super(
            key: key,
            isInProgress: command.isExecuting,
            defaultContent: defaultContent,
            progressContent: progressContent,
            opacity: opacity,
            color: color,
            offset: offset,
            dismissible: dismissible) {
    _getLastIsExecutingState(command);
  }

  Future<void> _getLastIsExecutingState(RxCommand command) async {
    if (!await command.isExecuting.isEmpty) {
      initialIsInProgress = await command.isExecuting.last;
    }
  }
}
