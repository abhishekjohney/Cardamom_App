# Cardamom ERP Flutter Application

A comprehensive Flutter application implementing the ERP login system with API-based authentication, matching the exact backend parameters and flow of the React/Next.js ERP system.

## 🚀 Features Implemented

### ✅ Authentication System
- **API-Based Login**: Uses multipart/form-data POST requests to match React/Next.js implementation
- **ERP Login Parameters**: 
  - `tblname`: "employee"
  - `columnname`: "empcode" 
  - `empcode`: [user input]
  - `columnname2`: "password"
  - `password`: [user input]
  - `methodname`: "select"
- **Response Handling**: Non-empty array indicates successful login
- **Session Management**: Secure storage with configurable timeout (8 hours default)
- **Auto-Login**: Automatic session validation on app start

### ✅ Security Features
- **HTTPS Enforcement**: All API calls use secure endpoints
- **Request Timeouts**: 30-second timeout for all network requests
- **Input Validation**: Form validation for employee code and password
- **Session Expiration**: Automatic logout after session timeout
- **Secure Storage**: User credentials and session data stored securely

### ✅ UI/UX Features
- **Modern Login Screen**: Clean, professional design with animations
- **Loading Indicators**: Visual feedback during authentication
- **Error Handling**: User-friendly error messages for all scenarios
- **Remember Me**: Option to save employee code for future logins
- **Password Visibility**: Toggle to show/hide password
- **Responsive Design**: Works on different screen sizes
- **Splash Screen**: Professional app startup experience

### ✅ Data Management
- **Party List Fetching**: Automatic party data retrieval after login
- **Caching System**: Local caching for offline access (1-hour default)
- **Background Sync**: Non-blocking data synchronization
- **Web Compatibility**: All SQLite operations commented out for web support

### ✅ Environment Management
- **Multi-Environment Support**: Development, Staging, Production configurations
- **Easy URL Switching**: Configurable API endpoints
- **Debug Logging**: Comprehensive logging system for development
- **Configuration Management**: Centralized app configuration

## 🏗️ Architecture

### File Structure
```
lib/
├── config/
│   └── app_config.dart           # Environment configuration
├── controllers/
│   └── logincontroller.dart      # Login state management
├── utils/
│   ├── api_endpoints.dart        # API services and session management
│   └── dbhandler.dart           # Legacy database handler (commented out)
├── views/
│   ├── auth/
│   │   └── login.dart           # Login screen UI
│   └── dashboard.dart           # Main dashboard
└── main.dart                    # App entry point with splash screen
```

### Key Components

#### 1. Authentication Service
```dart
class AuthenticationService {
  // Handles ERP login with exact React/Next.js parameters
  static Future<Map<String, dynamic>> authenticateUser(String username, String password)
  
  // Features:
  // - Multipart/form-data POST requests
  // - Base64 encryption support (configurable)
  // - Comprehensive error handling
  // - Timeout management
  // - Debug logging
}
```

#### 2. Session Manager
```dart
class SessionManager {
  // Secure session management
  static Future<void> saveSession(Map<String, dynamic> userData, {bool rememberMe = false})
  static Future<bool> isSessionValid()
  static Future<void> logout()
  
  // Features:
  // - 8-hour session timeout
  // - Remember me functionality
  // - Automatic session cleanup
  // - User data persistence
}
```

#### 3. Party Service
```dart
class PartyService {
  // Handles party data fetching and caching
  static Future<Map<String, dynamic>> fetchPartyList()
  static Future<void> cachePartyList(List<dynamic> partyList)
  static Future<List<dynamic>?> getCachedPartyList()
  
  // Features:
  // - Background data fetching
  // - 1-hour cache timeout
  // - Offline data access
  // - Error handling
}
```

## 🔧 Configuration

### Environment Setup
The app supports multiple environments through `AppConfig`:

```dart
// Production (default)
baseUrl: 'https://cardamombe.magnussoftech.in'
webServiceReact: 'https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx'

// Development
baseUrl: 'https://cardamombe-dev.magnussoftech.in'

// Staging  
baseUrl: 'https://cardamombe-staging.magnussoftech.in'
```

### Build Commands
```bash
# Production build
flutter build apk --release

# Development build
flutter build apk --dart-define=ENVIRONMENT=development

# Web build (SQLite operations are disabled)
flutter build web --release
```

## 🔐 API Endpoints

### Login Endpoint
- **URL**: `https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx`
- **Method**: POST
- **Content-Type**: multipart/form-data
- **Parameters**:
  ```
  tblname: "employee"
  columnname: "empcode"
  empcode: [employee_code]
  columnname2: "password"
  password: [password]
  methodname: "select"
  ```

### Party List Endpoint
- **URL**: `https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx`
- **Method**: POST
- **Content-Type**: multipart/form-data
- **Parameters**:
  ```
  tblname: "partymaster"
  columnname: "partycode"
  partycode: ""
  methodname: "select"
  ```

### Image URLs
- **Stock Images**: `https://cardamombe.magnussoftech.in/PICS/stock`
- **Catalog Images**: `https://cardamombe.magnussoftech.in/CatLog`

## 🛠️ Dependencies

### Core Dependencies
- `flutter`: SDK
- `get`: State management and navigation
- `dio`: HTTP client with multipart support
- `shared_preferences`: Secure local storage

### UI Dependencies
- `flutter/material.dart`: Material Design components
- `flutter/cupertino.dart`: iOS-style components

### Removed Dependencies
- `sqflite`: Commented out for web compatibility
- `path_provider`: Not needed for API-based approach
- Database-related packages: Removed for web support

## 🔄 Migration from SQLite to API

### What Was Changed
1. **Authentication**: Replaced local database validation with API calls
2. **User Management**: Session data stored in SharedPreferences instead of SQLite
3. **Data Fetching**: Party list fetched from API instead of local database
4. **Web Compatibility**: All SQLite operations commented out

### Backward Compatibility
- All database methods are preserved but commented out
- Easy to switch back to SQLite if needed
- No breaking changes to existing UI components

## 🐛 Error Handling

### Network Errors
- Connection timeout: 30-second limit
- Server errors: HTTP status code handling
- JSON parsing errors: Graceful fallback
- Offline mode: Cached data access

### Authentication Errors
- Invalid credentials: User-friendly messages
- Empty responses: Proper error indication
- Server downtime: Timeout handling
- Session expiry: Automatic logout

### User Experience
- Loading indicators during API calls
- Clear error messages
- Retry mechanisms where appropriate
- Graceful degradation for offline use

## 📱 Testing

### Manual Testing Checklist
- [ ] Login with valid credentials
- [ ] Login with invalid credentials
- [ ] Network timeout handling
- [ ] Remember me functionality
- [ ] Auto-login on app restart
- [ ] Session expiration
- [ ] Party list loading
- [ ] Offline data access
- [ ] Different screen sizes
- [ ] Web compatibility

### Test Credentials
Use your existing ERP employee codes and passwords for testing.

## 🚀 Deployment

### Android APK
```bash
flutter build apk --release --dart-define=ENVIRONMENT=production
```

### Web Deployment
```bash
flutter build web --release --dart-define=ENVIRONMENT=production
```

### Environment Variables
```bash
# Development
--dart-define=ENVIRONMENT=development
--dart-define=DEBUG_MODE=true
--dart-define=ENABLE_LOGGING=true

# Production
--dart-define=ENVIRONMENT=production
--dart-define=DEBUG_MODE=false
--dart-define=ENABLE_LOGGING=false
```

## 📄 License

This project is proprietary software developed for Magnus Softech.

## 🤝 Support

For technical support or questions about the implementation, please contact the development team.

---

**Version**: 1.0.0  
**Last Updated**: June 25, 2025  
**Developed by**: Magnus Softech  
**Platform**: Flutter (Cross-platform)
