## [0.1.18]
Replaced NavigationService with a much simpler one.

## [0.1.17]
Update dependencies   
Update flutter SDK   
Changed NotifyPropertyChanged from class to Mixin.

## [0.1.15]
ProgressBarrierWidget: Added "initialIsInProgress" to get the initial state of the widget.

## [0.1.15]
BusyIndicator: changed function signature of "doAction" to "Future<void> doAction(AsyncAction action) async"

## [0.1.14]
Fix flutter_view_model.dart to export BusyIndicator and BusyIndicatorBarrierWidget.

## [0.1.13]
Added BusyIndicator: A model to express a busy state.
Added BusyIndicatorBarrierWidget: A widget visualising a BusyIndicator isBusy state.

## [0.1.12]
IExceptionDialogTextProvider: changed translateException(Exception ex) to translateExceptionOrError(Object exceptionOrError);

## [0.1.11]
Added ProgressBarrierWidget: Displays a barrier that contains a the progress content (typically something like CircularProgressIndicator), when the isInProgress stream contains a TRUE value other whise the defaultContent is displayed.
Added CommandProgressBarrierWidget: Child of ProgressBarrierWidget while the isInProgress stream used the commands isExecuting stream.

## [0.1.10]

Added AnimatedObservableList: AnimatedObservableList encapsulate an AnimatedList widget for an ObservableList property.

## [0.1.9]

Fixes: NotifyPropertyChanged isPausingSendNotifications

## [0.1.8]
ObservableList<>: Removed indexOfWhere() because there is indexWhere.

## [0.1.7]

* ObservableList<>: Added indexOfWhere() to find the index of an elemente by using a test function.

## [0.1.6]

* ObservableList<>.removeWhere() is notifing ItemRemovedEvent.
* NotifyPropertyChanged: Add method "doWhileStopNotification", which allows to manipulate the list without sending notifications.

## [0.1.5]

* Added "AnimatedObservableList": Quickly build an AnimatedList widget from an ObservableList<>.


## [0.1.4]

* Added "isPausingSendNotifications" to INotifyPropertyChanged and NotifyPropertyChanged.
* Added "isBlank()" and changed impl. of "isEmpty()" within string_utils.dart

## [0.1.3]

* fixes AppNavigator.

## [0.1.2]

* Readme corrections.

## [0.1.1]

* Readme corrections.

## [0.1.0]

* Initial version.
