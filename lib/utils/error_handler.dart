import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppErrorHandler {
  // Singleton pattern
  static final AppErrorHandler _instance = AppErrorHandler._internal();
  factory AppErrorHandler() => _instance;
  AppErrorHandler._internal();

  // Initialize error handling
  void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _reportError(details.exception, details.stack);
      // Still show the error in dev mode
      FlutterError.dumpErrorToConsole(details);
    };

    // Catch all other errors that aren't caught by the Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      _reportError(error, stack);
      return true;
    };
  }

  // Log error to console and potentially to a file or remote service
  void _reportError(dynamic error, StackTrace? stack) {
    print('🔴 FATAL ERROR: $error');
    if (stack != null) {
      print('📋 STACK TRACE: $stack');
    }
    
    // Here you could send the error to a service like Firebase Crashlytics, Sentry, etc.
  }

  // Wrap the main app in a zone that catches all errors
  static Future<void> runWithErrorHandling(Widget app) async {
    runZonedGuarded(() {
      runApp(app);
    }, (error, stack) {
      print('❌ UNCAUGHT ZONE ERROR: $error');
      print('📋 STACK TRACE: $stack');
    });
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _ErrorBoundaryState createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  dynamic _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This helps catch initialization errors
    PlatformDispatcher.instance.onError = (error, stack) {
      setState(() {
        _hasError = true;
        _error = error;
      });
      print('🔴 ERROR BOUNDARY CAUGHT: $error');
      print('📋 STACK TRACE: $stack');
      return true;
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 60),
                SizedBox(height: 16),
                Text('Something went wrong',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('$_error', style: TextStyle(color: Colors.red)),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                    });
                  },
                  child: Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widget.child;
  }
}
