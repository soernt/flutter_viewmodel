enum ButtonTypes { ok }

/// Implementation provides translations for the various methods.
abstract class ITextProvider {
  // Properties

  IExceptionDialogTextProvider get exceptionDialogTextProvider;

  IButtonTypeTextProvider get buttonTypeTextProvider;

  // Methods
}

abstract class IExceptionDialogTextProvider {
  String get exceptionDialogTitle;

  String translateExceptionOrError(Object exceptionOrError);
}

abstract class IButtonTypeTextProvider {
  String getButtonText(ButtonTypes buttonType);
}
