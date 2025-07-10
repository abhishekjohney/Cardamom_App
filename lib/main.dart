import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async'; // Add for error handling
import 'package:shopapp/controllers/logincontroller.dart';
import 'package:shopapp/views/dashboard.dart';
import 'package:shopapp/views/auth/login.dart';
import 'package:shopapp/config/app_config.dart';

import 'package:shopapp/utils/error_handler.dart';

void main() async {
  // Wrap everything in a try-catch block to prevent app shutdown
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize error handling early
    AppErrorHandler().initialize();
    
    // Print app configuration for debugging
    AppConfig.printConfig();
    
    // Web platform specific initialization and error handling
    if (kIsWeb) {
      print("🌐 WEB: Initializing web platform");
      
      // Add special web initialization here if needed
      AppErrorHandler.runWithErrorHandling(
        ErrorBoundary(child: MyApp())
      );
      
      print("✅ WEB: App started successfully");
    } else {
      print("📱 MOBILE: Starting app normally");
      
      // Run with error boundary and error handling
      runApp(ErrorBoundary(child: MyApp()));
    }
  } catch (e, stackTrace) {
    // Last resort error handler to prevent app shutdown
    print("🚨 CRITICAL ERROR IN APP STARTUP: $e");
    print("📋 STACK TRACE: $stackTrace");
    
    // Still try to show the app even after an error
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 60),
              SizedBox(height: 16),
              Text(
                'App initialization error',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  e.toString(),
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
class MyApp extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      navigatorObservers: [
        // Add observer to track navigation issues
        if (kIsWeb) _WebNavigatorObserver(),
      ],
      defaultTransition: kIsWeb ? Transition.noTransition : Transition.rightToLeft,
      opaqueRoute: kIsWeb ? true : false, // For web, ensure routes are opaque for stability
      popGesture: !kIsWeb, // Disable pop gesture on web
      home: SplashScreen(),
      onInit: () {
        // Additional initialization when GetMaterialApp starts
        if (kIsWeb) {
          print("🌐 WEB: GetMaterialApp initialized");
        }
      },
    );
  }
}

// Custom navigator observer for web debugging
class _WebNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print("🌐 WEB NAVIGATION: Pushed ${route.settings.name ?? 'unnamed route'}");
    super.didPush(route, previousRoute);
  }
  
  @override
  void didPop(Route route, Route? previousRoute) {
    print("🌐 WEB NAVIGATION: Popped ${route.settings.name ?? 'unnamed route'}");
    super.didPop(route, previousRoute);
  }
  
  @override
  void didRemove(Route route, Route? previousRoute) {
    print("🌐 WEB NAVIGATION: Removed ${route.settings.name ?? 'unnamed route'}");
    super.didRemove(route, previousRoute);
  }
  
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print("🌐 WEB NAVIGATION: Replaced ${oldRoute?.settings.name ?? 'unnamed route'} with ${newRoute?.settings.name ?? 'unnamed route'}");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    
    _animationController.forward();
    
    // Check authentication status after animation
    _checkAuthStatus();
  }
  
  void _checkAuthStatus() async {
    await Future.delayed(Duration(seconds: 2));
    final loginController = Get.find<LoginController>();
    try {
      print("🔍 Checking authentication status...");
      final isLoggedIn = await loginController.checkAutoLogin();
      print("🔑 Authentication status: "+(isLoggedIn ? 'Logged In' : 'Not Logged In'));
      if (kIsWeb) {
        print("🌐 WEB: Using web-safe navigation from splash");
        // Handle web navigation carefully
        if (isLoggedIn) {
          print("🌐 WEB: Navigating to Dashboard");
          await Future.delayed(Duration(milliseconds: 300));
          if (Get.context != null) {
            Navigator.of(Get.context!).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (context) => Dashboard()),
              (route) => false
            );
          } else {
            Get.offAll(() => Dashboard());
          }
        } else {
          print("🌐 WEB: Navigating to Login");
          await Future.delayed(Duration(milliseconds: 300));
          Get.offAll(() => FuturisticLoginPage());
        }
      } else {
        // Mobile navigation
        print("📱 MOBILE: Standard navigation from splash");
        if (isLoggedIn) {
          Get.offAll(() => Dashboard());
        } else {
          Get.offAll(() => FuturisticLoginPage());
        }
      }
    } catch (e) {
      print("❌ Error checking auth status: $e");
      // Default to login page on error
      Get.offAll(() => FuturisticLoginPage());
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade900, Colors.teal.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.store,
                    size: 60,
                    color: Colors.teal.shade700,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  AppConfig.appName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Version ${AppConfig.appVersion}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'by ${AppConfig.companyName}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
                SizedBox(height: 40),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
