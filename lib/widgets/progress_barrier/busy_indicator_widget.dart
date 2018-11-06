import 'package:flutter/material.dart';
import 'package:flutter_view_model/flutter_view_model.dart';
import 'package:flutter_view_model/services/busy_indicator.dart';

class BusyIndicatorBarrierWidget extends ProgressBarrierWidget {
  // Methods

  BusyIndicatorBarrierWidget({
    Key key,
    @required BusyIndicator busyIndicator,
    @required defaultContent,
    progressContent = const CircularProgressIndicator(),
    opacity = 0.3,
    color = Colors.grey,
    offset,
    dismissible = false,
  }) : super(
            key: key,
            initialIsInProgress: busyIndicator.isBusy,
            isInProgress: busyIndicator.isBusyStream,
            defaultContent: defaultContent,
            progressContent: progressContent,
            opacity: opacity,
            color: color,
            offset: offset,
            dismissible: dismissible);
}
