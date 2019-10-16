import 'dart:async';

Future<TResult> waitFor<TResult>(Future<TResult> waitFor, {Duration timeout = const Duration(microseconds: 100)}) async {
  final timeoutFuture = Future.delayed(timeout, () => throw TimeoutException("Timeout while waiting for a future to completed.", timeout));
  final completedFuture = Future.any(<Future>[waitFor, timeoutFuture]);
  return completedFuture;
}

Future waitForAll(List<Future> waitForEach, {Duration timeout = const Duration(microseconds: 100)}) async {
  for (var future in waitForEach) {
    await waitFor(future);
  }
}
