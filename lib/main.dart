import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async'; // Add for error handling
import 'package:shopapp/controllers/logincontroller.dart';
import 'package:shopapp/views/dashboard.dart';
import 'package:shopapp/views/auth/login.dart';
import 'package:shopapp/views/cardamom/cardamomdashboard.dart';
import 'package:shopapp/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Print app configuration for debugging
  AppConfig.printConfig();
  
  // Web platform specific initialization and error handling
  if (kIsWeb) {
    print("🌐 WEB: Initializing web platform");
    
    // Add Flutter web error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      print("🚨 CRITICAL ERROR: ${details.exception}");
      print("📋 STACK TRACE: ${details.stack}");
    };
    
    // Add zone-level error handling with retry capability
    runZonedGuarded(() {
      print("🌐 WEB: Starting web app with enhanced error handling");
      
      // Add special web initialization here if needed
      runApp(MyApp());
      
      print("✅ WEB: App started successfully");
    }, (error, stackTrace) {
      print("❌ UNCAUGHT ERROR: $error");
      print("📋 STACK TRACE: $stackTrace");
      
      // Attempt recovery by resetting state and restarting
      try {
        print("🔄 WEB: Attempting recovery...");
        Get.reset();
        runApp(MyApp());
      } catch (e) {
        print("💥 WEB: Recovery failed: $e");
      }
    });
  } else {
    print("📱 MOBILE: Starting app normally");
    runApp(MyApp());
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
