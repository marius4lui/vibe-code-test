import 'dart:developer' as developer;

abstract final class Crash {
  static Future<void> init() {
    developer.log('Local diagnostics initialized', name: 'momentum.startup');
    return Future<void>.value();
  }

  static void log(String message, {Map<String, Object?> extras = const {}}) {
    developer.log(extras.isEmpty ? message : '$message $extras', name: 'momentum');
  }

  static void error(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?> extras = const {},
  }) {
    developer.log(
      extras.isEmpty ? reason ?? 'Unexpected error' : '${reason ?? 'Unexpected error'} $extras',
      name: 'momentum.error',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
