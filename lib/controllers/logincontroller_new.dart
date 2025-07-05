import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/utils/api_endpoints.dart';
import 'package:shopapp/views/auth/login.dart';
import 'package:shopapp/views/dashboard.dart';
import 'dart:convert';

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
      // Use API authentication with ERP parameters
      final authResult = await AuthenticationService.authenticateUser(
        username.value, 
        password.value
      );
      
      if (authResult['success'] == true) {
        // Save session with user data
        await SessionManager.saveSession(authResult['user'], rememberMe: rememberMe.value);
        
        // Fetch and cache party list in background
        _fetchPartyListAsync();

        Get.snackbar("Success", "Welcome ${authResult['user']['name'] ?? username.value}",
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => Dashboard());
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

        Get.snackbar("Success", "Welcome ${authResult['user']['name'] ?? usernameInput}",
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => Dashboard());
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
      // Navigate to Dashboard
      Get.offAll(() => Dashboard());
    } else {
      // Navigate to Login
      Get.offAll(() => FuturisticLoginPage());
    }
  }

  // Logout function
  Future<void> logout() async {
    await SessionManager.logout();

    // Clear reactive values
    username.value = '';
    password.value = '';
    selectedRole.value = 'Employee';
    rememberMe.value = false;

    // Navigate to login page
    Get.offAll(() => FuturisticLoginPage());
  }

  // Update user profile (API-based)
  Future<void> updateUser(String newUsername, String newPassword, String newRole) async {
    // TODO: Implement API-based user profile update
    // This would require a separate API endpoint for user profile updates
    Get.snackbar('Info', 'Profile update feature will be implemented with API endpoint');
  }
}
