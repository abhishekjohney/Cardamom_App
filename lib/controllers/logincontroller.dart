import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shopapp/utils/api_endpoints.dart';
import 'package:shopapp/views/auth/login.dart';
import 'package:shopapp/views/cardamom/cardamomdashboard.dart'; // Import CardamomDashboard
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var selectedRole = 'Employee'.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> loadUserData() async {
    // Load remember me preference and username if remembered
    rememberMe.value = await SessionManager.getRememberMe();
    if (rememberMe.value) {
      username.value = await SessionManager.getUsername();
    }
    selectedRole.value = await SessionManager.getRole();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Auto-login check
  Future<bool> checkAutoLogin() async {
    return await SessionManager.isSessionValid();
  }

  // Login function
  Future<void> login() async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Employee code and password cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      print("DEBUG Starting login process for: ${username.value}");
      
      // Use API authentication with ERP parameters
      final authResult = await AuthenticationService.authenticateUser(
        username.value, 
        password.value
      );
      
      print("DEBUG Authentication result: $authResult");
      
      if (authResult['success'] == true) {
        print("SUCCESS Authentication successful, saving session...");
        
        // Save session with user data
        await SessionManager.saveSession(authResult['user'], rememberMe: rememberMe.value);
        
        print("SUCCESS Session saved successfully");
        print("SUCCESS Session data: ${authResult['user']}");
        
        print("DEBUG Starting party list fetch...");
        
        // Fetch and cache party list in background
        _fetchPartyListAsync();

        print("SUCCESS Party list fetch initiated");
        
        print("DEBUG Showing success message...");
        
        Get.snackbar("Success", "Welcome ${authResult['user']['name'] ?? username.value}",
            snackPosition: SnackPosition.BOTTOM);
            
        print("SUCCESS Success message displayed");
        
        print("DEBUG About to navigate to Dashboard...");
        
        // Instead, always navigate to CardamomDashboard
        Get.offAll(() => CardamomDashboard());
        
        print("SUCCESS Navigation completed successfully!");
        
        print("SUCCESS User data: ${authResult['user']}");
        
      } else {
        print("ERROR Authentication failed: ${authResult['message']}");
        Get.snackbar("Error", authResult['message'] ?? "Authentication failed",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e, stackTrace) {
      print("ERROR Login error: $e");
      print("ERROR Stack trace: $stackTrace");
      Get.snackbar("Error", "Network error: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      print("COMPLETE Login process completed");
    }
  }

  // Fetch party list in background after login
  void _fetchPartyListAsync() async {
    try {
      final partyResult = await PartyService.fetchPartyList();
      if (partyResult['success'] == true && partyResult['data'] != null) {
        await PartyService.cachePartyList(partyResult['data']);
        print("Party list cached successfully: ${partyResult['count']} parties");
      }
    } catch (e) {
      print("Error fetching party list: $e");
    }
  }

  // Login function with parameters (for programmatic login)
  Future<void> loginWithCredentials(String usernameInput, String passwordInput, String roleInput) async {
    if (usernameInput.isEmpty || passwordInput.isEmpty) {
      Get.snackbar("Error", "Employee code and password cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      // Use API authentication with ERP parameters
      final authResult = await AuthenticationService.authenticateUser(
        usernameInput, 
        passwordInput
      );
      
      if (authResult['success'] == true) {
        // Save session with user data
        await SessionManager.saveSession(authResult['user'], rememberMe: rememberMe.value);
        // Fetch and cache party list in background
        _fetchPartyListAsync();
        Get.snackbar("Success", "Welcome "+(authResult['user']['name'] ?? username.value),
            snackPosition: SnackPosition.BOTTOM);
        // Navigate directly to CardamomDashboard after login
        Get.offAll(() => CardamomDashboard());
      } else {
        Get.snackbar("Error", authResult['message'] ?? "Authentication failed",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Network error: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Check login state for auto-login
  Future<void> checkLoginState() async {
    bool isLoggedIn = await SessionManager.isSessionValid();

    if (isLoggedIn) {
      // Navigate to CardamomDashboard only
      Get.offAll(() => CardamomDashboard());
    } else {
      // Navigate to Login
      Get.offAll(() => FuturisticLoginPage());
    }
  }

  // Logout function
  Future<void> logout() async {
    print("DEBUG: Starting logout process");
    
    try {
      await SessionManager.logout();
      print("DEBUG: Session cleared successfully");

      // Clear reactive values
      username.value = '';
      password.value = '';
      selectedRole.value = 'Employee';
      rememberMe.value = false;
      print("DEBUG: Local state cleared");

      // Web-specific logout handling
      if (kIsWeb) {
        print("DEBUG WEB: Using web-safe logout navigation");
        
        try {
          // For web, use a more cautious navigation approach
          print("DEBUG WEB: Navigating to login page");
          await Future.delayed(Duration(milliseconds: 300));
          
          if (Get.context != null) {
            Navigator.of(Get.context!).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (context) => FuturisticLoginPage()),
              (route) => false
            );
          } else {
            Get.offAll(() => FuturisticLoginPage());
          }
          
          print("DEBUG WEB: Navigation to login page completed");
        } catch (e) {
          print("ERROR WEB: Logout navigation error: $e");
          // Last resort
          Get.reset();
          Get.to(() => FuturisticLoginPage());
        }
      } else {
        print("DEBUG MOBILE: Standard logout navigation");
        // Navigate to login page using standard method for mobile
        Get.offAll(() => FuturisticLoginPage());
      }
    } catch (e) {
      print("ERROR: Logout failed: $e");
      // Force navigation to login even if logout fails
      Get.offAll(() => FuturisticLoginPage());
    }
  }

  // Update user profile (API-based)
  Future<void> updateUser(String newUsername, String newPassword, String newRole) async {
    // TODO: Implement API-based user profile update
    // This would require a separate API endpoint for user profile updates
    Get.snackbar('Info', 'Profile update feature will be implemented with API endpoint');
  }

  // Force rebuild the app to navigate to CardamomDashboard safely on web
  void _forceRebuildApp() {
    print("DEBUG WEB: Forcing app rebuild as last resort");
    try {
      Get.reset();
      Get.offAll(() => CardamomDashboard());
      print("DEBUG WEB: App rebuild completed");
    } catch (e) {
      print("ERROR WEB: App rebuild failed: $e");
    }
  }
}
