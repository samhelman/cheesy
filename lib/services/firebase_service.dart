import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'log_service.dart';

class FirebaseService implements LogService {
  static FirebaseService? _instance;

  static FirebaseService get instance => _instance ??= FirebaseService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalytics get analytics => _analytics;

  FirebaseService._();

  Future<void> init() async {
    await Firebase.initializeApp();
    await initCrashlytics();
  }

  Future<void> initCrashlytics() async {
    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      // Pass all uncaught flutter errors from the framework to Crashlytics.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // Record errors outside flutter's scope
      Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort);
    }
  }

  static Future<void> reportNonFatalCrash(dynamic error, StackTrace stackTrace,
      {String reason = 'a non-fatal error'}) async {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason);
  }

  @override
  void logFlutterError(FlutterErrorDetails details) =>
      FirebaseCrashlytics.instance.recordFlutterError(details);

  @override
  void logError(Object error, StackTrace stackTrace) =>
      FirebaseCrashlytics.instance.recordError(error, stackTrace);

  @override
  void logEvent(String name, {Map<String, dynamic> parameters = const {}}) {
    _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  void logInfo(String info) {
    _analytics.logEvent(name: 'info', parameters: {'value': info});
  }
}
