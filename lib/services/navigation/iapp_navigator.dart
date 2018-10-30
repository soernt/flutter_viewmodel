/// IAppNavigator provides navigation capabilities for a view model
/// This Interface should be extendend of app specific pages navigation functions.
abstract class IAppNavigator {
  // Properties

  // Methods

  Future<void> showInfoDialog(String title, String message);

  bool pop<T extends Object>([T result]);
}
