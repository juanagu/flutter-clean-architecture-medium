abstract class Logger {
  Future<void> info(String message);
  Future<void> error(String message);
  Future<void> recordError(dynamic error, StackTrace stackTrace);
}
