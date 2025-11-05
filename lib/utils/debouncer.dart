import 'dart:async';
import 'dart:ui';

/// A utility class for debouncing function calls
class Debouncer {
  /// Creates a debouncer with the specified delay in milliseconds
  Debouncer({required this.milliseconds});

  /// The delay in milliseconds before executing the debounced function
  final int milliseconds;
  Timer? _timer;

  /// Executes the action after the debounce delay
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending debounced action
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Immediately executes any pending action and cancels the timer
  void flush() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
  }

  /// Returns true if there's a pending action
  bool get isPending => _timer != null && _timer!.isActive;

  /// Disposes of the debouncer and cancels any pending actions
  void dispose() {
    cancel();
  }
}
