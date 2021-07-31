import 'package:flutter/material.dart';

abstract class LogService {
  void logInfo(String info);
  void logEvent(String name, {Map<String, dynamic> parameters = const {}});
  void logFlutterError(FlutterErrorDetails details);
  void logError(Object error, StackTrace stackTrace);
}