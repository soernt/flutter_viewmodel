/// Handles somehow an exception.
abstract class IExceptionHandler {
  Future<void> addException(Object exceptionOrError);
}
